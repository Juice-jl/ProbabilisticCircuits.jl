export estimate_parameters, uniform_parameters, estimate_parameters_em

using StatsFuns: logsumexp
using CUDA
using LoopVectorization

"""
Maximum likilihood estimation of parameters given data

use_gpu: If set to `true`, use gpu learning no matter which device `data` is in.
"""
function estimate_parameters(pc::ProbCircuit, data; pseudocount::Float64, 
                             use_sample_weights::Bool = true, use_gpu::Bool = false)
    if isweighted(data)
        # `data' is weighted according to its `weight' column
        data, weights = split_sample_weights(data)
    else
        use_sample_weights = false
    end
    
    @assert isbinarydata(data) "Probabilistic circuit parameter estimation for binary data only"
    bc = BitCircuit(pc, data; reset=false)
    if isgpu(data)
        use_gpu = true
    end
    params = if use_gpu
        if use_sample_weights
            estimate_parameters_gpu(to_gpu(bc), data, pseudocount; weights)
        else
            estimate_parameters_gpu(to_gpu(bc), data, pseudocount)
        end
    else
        if use_sample_weights
            estimate_parameters_cpu(bc, data, pseudocount; weights)
        else
            estimate_parameters_cpu(bc, data, pseudocount)
        end
    end
    estimate_parameters_cached!(pc, bc, params)
    params
end

function estimate_parameters_cached!(pc, bc, params)
    foreach_reset(pc) do pn
        if is⋁gate(pn)
            if num_children(pn) == 1
                pn.log_probs .= zero(Float64)
            else
                id = (pn.data::⋁NodeIds).node_id
                @inbounds els_start = bc.nodes[1,id]
                @inbounds els_end = bc.nodes[2,id]
                @inbounds @views pn.log_probs .= params[els_start:els_end]
                @assert isapprox(sum(exp.(pn.log_probs)), 1.0, atol=1e-3) "Parameters do not sum to one locally: $(sum(exp.(pn.log_probs))); $(pn.log_probs)"
                pn.log_probs .-= logsumexp(pn.log_probs) # normalize away any leftover error
            end
        end
    end
    nothing
end

function estimate_parameters_cpu(bc::BitCircuit, data, pseudocount; weights = nothing)
    # no need to synchronize, since each computation is unique to a decision node
    if weights === nothing
        node_counts = Vector{UInt}(undef, num_nodes(bc))
    else
        node_counts = Vector{Float64}(undef, num_nodes(bc))
    end
    
    if isbatched(data)
        estimate_parameters_cpu_batched(bc, data, pseudocount, node_counts; weights = weights)
    else
        estimate_parameters_cpu_not_batched(bc, data, pseudocount, node_counts; weights = weights)
    end
end
function estimate_parameters_cpu_batched(bc::BitCircuit, data, pseudocount, node_counts; weights = nothing)
    # rescale pseudocount using the average weight of samples
    if weights !== nothing
        pseudocount = pseudocount * mapreduce(sum, +, weights) / num_examples(data)
    end
    
    edge_counts::Vector{Float64} = zeros(Float64, num_elements(bc))
    parent_node_counts::Vector{Float64} = zeros(Float64, num_elements(bc))
    
    @inline function weighted_count_ones(bits::UInt64, start_idx::Number, end_idx::Number, weights)
        count::Float64 = 0.0
        op_bits::UInt64 = bits
        @inbounds for idx = 0 : (end_idx - start_idx)
            count += weights[start_idx + idx] * (op_bits & UInt64(0x1))
            op_bits = (op_bits >> 1)
        end
        count
    end

    @inline function on_node(flows, values, dec_id, weights::Nothing)
        node_counts[dec_id] = sum(1:size(flows,1)) do i
            count_ones(flows[i, dec_id]) 
        end
    end
    @inline function on_node(flows, values, dec_id, weights)
        node_counts[dec_id] = sum(1:size(flows,1)) do i
            # count_ones(flows[i, dec_id]) * weights[i]
            weighted_count_ones(flows[i, dec_id], i * 64 - 63, min(i * 64, length(weights)), weights)
        end
    end

    @inline function estimate(element, decision, edge_count)
        edge_counts[element] += edge_count
        parent_node_counts[element] += node_counts[decision]
    end

    @inline function on_edge(flows, values, prime, sub, element, grandpa, single_child, weights::Nothing)
        if !single_child
            edge_count = sum(1:size(flows,1)) do i
                count_ones(values[i, prime] & values[i, sub] & flows[i, grandpa]) 
            end
            estimate(element, grandpa, edge_count)
        end # no need to estimate single child params, they are always prob 1
    end
    @inline function on_edge(flows, values, prime, sub, element, grandpa, single_child, weights)
        if !single_child
            edge_count = sum(1:size(flows,1)) do i
                # count_ones(values[i, prime] & values[i, sub] & flows[i, grandpa]) * weights[i]
                weighted_count_ones(values[i, prime] & values[i, sub] & flows[i, grandpa], 
                                    i * 64 - 63, min(i * 64, length(weights)), weights)
            end
            estimate(element, grandpa, edge_count)
        end # no need to estimate single child params, they are always prob 1
    end

    v, f = nothing, nothing
    map(zip(data, weights)) do (d, w)
        v, f = satisfies_flows(bc, d, v, f; on_node = on_node, on_edge = on_edge, weights = w)
    end
    
    # Reuse `edge_counts` to store log_params to save space and time.
    for i = 1 : num_elements(bc)
        @inbounds edge_counts[i] = log((edge_counts[i] + pseudocount / num_elements(bc.nodes, bc.elements[1, i])) / (parent_node_counts[i] + pseudocount))
    end

    edge_counts # a.k.a. log_params
end
function estimate_parameters_cpu_not_batched(bc::BitCircuit, data, pseudocount, node_counts; weights = nothing)
    # rescale pseudocount using the average weight of samples
    if weights !== nothing
        pseudocount = pseudocount * sum(weights) / size(weights, 1)
    end
    
    log_params::Vector{Float64} = Vector{Float64}(undef, num_elements(bc))
    
    @inline function weighted_count_ones(bits::UInt64, start_idx::Number, end_idx::Number)
        count::Float64 = 0.0
        op_bits::UInt64 = bits
        @inbounds for idx = 0 : (end_idx - start_idx)
            count += weights[start_idx + idx] * (op_bits & UInt64(0x1))
            op_bits = (op_bits >> 1)
        end
        count
    end

    @inline function on_node(flows, values, dec_id, weights::Nothing)
        node_counts[dec_id] = sum(1:size(flows,1)) do i
            count_ones(flows[i, dec_id]) 
        end
    end
    @inline function on_node(flows, values, dec_id, weights)
        node_counts[dec_id] = sum(1:size(flows,1)) do i
            # count_ones(flows[i, dec_id]) * weights[i]
            weighted_count_ones(flows[i, dec_id], i * 64 - 63, min(i * 64, length(weights)))
        end
    end

    @inline function estimate(element, decision, edge_count)
        num_els = num_elements(bc.nodes, decision)
        log_params[element] = 
            log((edge_count+pseudocount/num_els)
                   /(node_counts[decision]+pseudocount))
    end

    @inline function on_edge(flows, values, prime, sub, element, grandpa, single_child, weights::Nothing)
        if !single_child
            edge_count = sum(1:size(flows,1)) do i
                count_ones(values[i, prime] & values[i, sub] & flows[i, grandpa]) 
            end
            estimate(element, grandpa, edge_count)
        end # no need to estimate single child params, they are always prob 1
    end
    @inline function on_edge(flows, values, prime, sub, element, grandpa, single_child, weights)
        if !single_child
            edge_count = sum(1:size(flows,1)) do i
                # count_ones(values[i, prime] & values[i, sub] & flows[i, grandpa]) * weights[i]
                weighted_count_ones(values[i, prime] & values[i, sub] & flows[i, grandpa], 
                                    i * 64 - 63, min(i * 64, length(weights)))
            end
            estimate(element, grandpa, edge_count)
        end # no need to estimate single child params, they are always prob 1
    end

    v, f = satisfies_flows(bc, data; on_node, on_edge, weights)

    log_params
end

function estimate_parameters_gpu(bc::BitCircuit, data, pseudocount; weights = nothing)
    # rescale pseudocount using the average weight of samples
    if weights !== nothing
        if isbatched(data)
            pseudocount = pseudocount * mapreduce(sum, +, weights) / num_examples(data)
        else
            pseudocount = pseudocount * sum(weights) / size(weights, 1)
        end
    end
    
    node_counts::CuVector{Float32} = CUDA.zeros(Float32, num_nodes(bc))
    edge_counts::CuVector{Float32} = CUDA.zeros(Float32, num_elements(bc))
    # need to manually cudaconvert closure variables
    node_counts_device = CUDA.cudaconvert(node_counts)
    edge_counts_device = CUDA.cudaconvert(edge_counts)
    
    @inline function on_node(flows, values, dec_id, chunk_id, flow, weight::Nothing)
        c::Float32 = CUDA.count_ones(flow) # cast for @atomic to be happy
        CUDA.@atomic node_counts_device[dec_id] += c
    end
    @inline function on_node(flows, values, dec_id, bit_idx, flow, weight::Float32)
        c::Float32 = ((flow >> bit_idx) & UInt64(0x1)) * weight # cast for @atomic to be happy
        CUDA.@atomic node_counts_device[dec_id] += c
    end

    @inline function on_edge(flows, values, prime, sub, element, grandpa, chunk_id, edge_flow, single_child, weight::Nothing)
        if !single_child
            c::Float32 = CUDA.count_ones(edge_flow) # cast for @atomic to be happy
            CUDA.@atomic edge_counts_device[element] += c
        end
    end
    @inline function on_edge(flows, values, prime, sub, element, grandpa, bit_idx, edge_flow, single_child, weight::Float32)
        if !single_child
            c::Float32 = ((edge_flow >> bit_idx) & UInt64(0x1)) * weight # cast for @atomic to be happy
            CUDA.@atomic edge_counts_device[element] += c
        end
    end
    
    if isbatched(data)
        v, f = nothing, nothing
        map(zip(data, weights)) do (d, w)
            if w != nothing
                w = to_gpu(w)
            end
            v, f = satisfies_flows(to_gpu(bc), to_gpu(d), v, f; on_node = on_node, on_edge = on_edge, weights = w)
        end
    else
        if weights != nothing
            weights = to_gpu(weights)
        end
        v, f = satisfies_flows(to_gpu(bc), to_gpu(data); on_node = on_node, on_edge = on_edge, weights = weights)
    end
    
    CUDA.unsafe_free!(v) # save the GC some effort
    CUDA.unsafe_free!(f) # save the GC some effort

    # TODO: reinstate simpler implementation once https://github.com/JuliaGPU/GPUArrays.jl/issues/313 is fixed and released
    @inbounds parents = bc.elements[1,:]
    @inbounds parent_counts = node_counts[parents]
    @inbounds parent_elcount = bc.nodes[2,parents] .- bc.nodes[1,parents] .+ 1 
    params = log.((edge_counts .+ (pseudocount ./ parent_elcount)) 
                    ./ (parent_counts .+ pseudocount))
    
    to_cpu(params)
end

"""
Uniform distribution
"""
function uniform_parameters(pc::ProbCircuit)
    foreach(pc) do pn
        if is⋁gate(pn)
            if num_children(pn) == 1
                pn.log_probs .= 0.0
            else
                pn.log_probs .= log.(ones(Float64, num_children(pn)) ./ num_children(pn))
            end
        end
    end
end

"""
Expectation maximization parameter learning given missing data
"""
function estimate_parameters_em(pc::ProbCircuit, data; pseudocount::Float64, use_sample_weights::Bool = true)
    if isweighted(data)
        # `data' is weighted according to its `weight' column
        data, weights = split_sample_weights(data)
    else
        use_sample_weights = false
    end
    
    pbc = ParamBitCircuit(pc, data; reset=false)
    params = if isgpu(data)
        if use_sample_weights
            estimate_parameters_gpu(to_gpu(pbc), data, pseudocount; weights)
        else
            estimate_parameters_gpu(to_gpu(pbc), data, pseudocount)
        end
    else
        if use_sample_weights
            estimate_parameters_cpu(pbc, data, pseudocount; weights)
        else
            estimate_parameters_cpu(pbc, data, pseudocount)
        end
    end
    estimate_parameters_cached!(pc, pbc.bitcircuit, params)
    params
end

function estimate_parameters_cpu(pbc::ParamBitCircuit, data, pseudocount; weights = nothing)
    # no need to synchronize, since each computation is unique to a decision node
    node_counts::Vector{Float64} = Vector{Float64}(undef, num_nodes(pbc.bitcircuit))
    
    if isbatched(data)
        estimate_parameters_cpu_batched(pbc, data, pseudocount, node_counts; weights = weights)
    else
        estimate_parameters_cpu_not_batched(pbc, data, pseudocount, node_counts; weights = weights)
    end
end
function estimate_parameters_cpu_batched(pbc::ParamBitCircuit, data, pseudocount, 
                                         node_counts::Vector{Float64}; weights = nothing)
    # rescale pseudocount using the average weight of samples
    if weights !== nothing
        pseudocount = pseudocount * mapreduce(sum, +, weights) / num_examples(data)
    end
    
    bc = pbc.bitcircuit
    
    edge_counts::Vector{Float64} = zeros(Float64, num_elements(bc))
    parent_node_counts::Vector{Float64} = zeros(Float64, num_elements(bc))

    @inline function on_node(flows, values, dec_id, weights::Nothing)
        sum_flows = map(1:size(flows,1)) do i
            flows[i, dec_id]
        end
        node_counts[dec_id] = logsumexp(sum_flows)
    end
    @inline function on_node(flows, values, dec_id, weights)
        sum_flows = map(1:size(flows,1)) do i
            flows[i, dec_id] + log(weights[i])
        end
        node_counts[dec_id] = logsumexp(sum_flows)
    end

    @inline function estimate(element, decision, edge_count)
        edge_counts[element] += exp(edge_count)
        parent_node_counts[element] += exp(node_counts[decision])
    end

    @inline function on_edge(flows, values, prime, sub, element, grandpa, single_child, weights::Nothing)
        θ = eltype(flows)(pbc.params[element])
        if !single_child
            edge_flows = map(1:size(flows,1)) do i
                f = values[i, prime] + values[i, sub] - values[i, grandpa] + flows[i, grandpa] + θ
                f = ifelse(isnan(f), typemin(eltype(flows)), f)
            end
            edge_count = logsumexp(edge_flows)
            estimate(element, grandpa, edge_count)
        end # no need to estimate single child params, they are always prob 1
    end
    @inline function on_edge(flows, values, prime, sub, element, grandpa, single_child, weights)
        θ = eltype(flows)(pbc.params[element])
        if !single_child
            edge_flows = map(1:size(flows,1)) do i
                f = values[i, prime] + values[i, sub] - values[i, grandpa] + flows[i, grandpa] + θ + log(weights[i])
                f = ifelse(isnan(f), typemin(eltype(flows)), f)
            end
            edge_count = logsumexp(edge_flows)
            estimate(element, grandpa, edge_count)
        end # no need to estimate single child params, they are always prob 1
    end

    v, f = nothing, nothing
    map(zip(data, weights)) do (d, w)
        v, f = marginal_flows(pbc, d, v, f; on_node = on_node, on_edge = on_edge, weights = w)
    end
    
    # Reuse `edge_counts` to store log_params to save space and time.
    for i = 1 : num_elements(bc)
        @inbounds edge_counts[i] = log((edge_counts[i] + pseudocount / num_elements(bc.nodes, bc.elements[1, i])) / (parent_node_counts[i] + pseudocount))
    end

    edge_counts # a.k.a. log_params
end
function estimate_parameters_cpu_not_batched(pbc::ParamBitCircuit, data, pseudocount, 
                                             node_counts::Vector{Float64}; weights = nothing)
    # rescale pseudocount using the average weight of samples
    if weights !== nothing
        pseudocount = pseudocount * sum(weights) / size(weights, 1)
    end
    
    bc = pbc.bitcircuit
    
    log_params::Vector{Float64} = Vector{Float64}(undef, num_elements(bc))

    @inline function on_node(flows, values, dec_id, weights::Nothing)
        sum_flows = map(1:size(flows,1)) do i
            flows[i, dec_id]
        end
        node_counts[dec_id] = logsumexp(sum_flows)
    end
    @inline function on_node(flows, values, dec_id, weights)
        sum_flows = map(1:size(flows,1)) do i
            flows[i, dec_id] + log(weights[i])
        end
        node_counts[dec_id] = logsumexp(sum_flows)
    end

    @inline function estimate(element, decision, edge_count)
        num_els = num_elements(bc.nodes, decision)
        @inbounds log_params[element] = 
            log((exp(edge_count)+pseudocount/num_els) / (exp(node_counts[decision])+pseudocount))
    end

    @inline function on_edge(flows, values, prime, sub, element, grandpa, single_child, weights::Nothing)
        θ = eltype(flows)(pbc.params[element])
        if !single_child
            edge_flows = map(1:size(flows,1)) do i
                @inbounds f = values[i, prime] + values[i, sub] - values[i, grandpa] + flows[i, grandpa] + θ
                f = ifelse(isnan(f), typemin(eltype(flows)), f)
            end
            edge_count = logsumexp(edge_flows)
            estimate(element, grandpa, edge_count)
        end # no need to estimate single child params, they are always prob 1
    end
    @inline function on_edge(flows, values, prime, sub, element, grandpa, single_child, weights)
        θ = eltype(flows)(pbc.params[element])
        if !single_child
            edge_flows = map(1:size(flows,1)) do i
                @inbounds f = values[i, prime] + values[i, sub] - values[i, grandpa] + flows[i, grandpa] + θ + log(weights[i])
                f = ifelse(isnan(f), typemin(eltype(flows)), f)
            end
            edge_count = logsumexp(edge_flows)
            estimate(element, grandpa, edge_count)
        end # no need to estimate single child params, they are always prob 1
    end

    v, f = marginal_flows(pbc, data; on_node, on_edge, weights)

    log_params
end

function estimate_parameters_gpu(pbc::ParamBitCircuit, data, pseudocount; weights = nothing)
    # rescale pseudocount using the average weight of samples
    if weights !== nothing
        pseudocount = pseudocount * sum(weights) / size(weights, 1)
    end
    
    bc = pbc.bitcircuit
    node_counts::CuVector{Float64} = CUDA.zeros(Float64, num_nodes(bc))
    edge_counts::CuVector{Float64} = CUDA.zeros(Float64, num_elements(bc))
    # need to manually cudaconvert closure variables
    node_counts_device = CUDA.cudaconvert(node_counts)
    edge_counts_device = CUDA.cudaconvert(edge_counts)
    
    @inline function on_node(flows, values, dec_id, chunk_id, flow, weight::Nothing)
        c::Float64 = exp(flow) # cast for @atomic to be happy
        CUDA.@atomic node_counts_device[dec_id] += c
    end
    @inline function on_node(flows, values, dec_id, chunk_id, flow, weight::AbstractFloat)
        c::Float64 = exp(flow) * weight # cast for @atomic to be happy
        CUDA.@atomic node_counts_device[dec_id] += c
    end

    @inline function on_edge(flows, values, prime, sub, element, grandpa, chunk_id, edge_flow, single_child, weight::Nothing)
        if !single_child
            c::Float64 = exp(edge_flow) # cast for @atomic to be happy
            CUDA.@atomic edge_counts_device[element] += c
        end
    end
    @inline function on_edge(flows, values, prime, sub, element, grandpa, chunk_id, edge_flow, single_child, weight::AbstractFloat)
        if !single_child
            c::Float64 = exp(edge_flow) * weight # cast for @atomic to be happy
            CUDA.@atomic edge_counts_device[element] += c
        end
    end

    v, f = marginal_flows(pbc, data; on_node, on_edge, weights)

    CUDA.unsafe_free!(v) # save the GC some effort
    CUDA.unsafe_free!(f) # save the GC some effort

    # TODO: reinstate simpler implementation once https://github.com/JuliaGPU/GPUArrays.jl/issues/313 is fixed and released
    @inbounds parents = bc.elements[1,:]
    @inbounds parent_counts = node_counts[parents]
    @inbounds parent_elcount = bc.nodes[2,parents] .- bc.nodes[1,parents] .+ 1 
    params = log.((edge_counts .+ (pseudocount ./ parent_elcount)) 
                    ./ (parent_counts .+ pseudocount))
    return to_cpu(params)
end
