using Random

export loglikelihoods, loglikelihood, 
    loglikelihoods_vectorized, 
    loglikelihoods_linearized

"""
    loglikelihoods(pc::ProbCircuit, data::Matrix)

Computes loglikelihoods of circuit recursively on cpu. Not vectorized.
"""
function loglikelihoods(pc::ProbCircuit, data::Matrix)
    num_examples = size(data, 1)
    log_likelihoods = zeros(Float32, num_examples)

    for idx = 1 : num_examples
        log_likelihoods[idx] = loglikelihood(pc, data, idx)
    end

    return log_likelihoods
end

"""
    loglikelihood(root::ProbCircuit, data::Matrix, example_id; Float=Float32)

Computes marginal loglikelihood on cpu for a single instance `data[example_id, :]`
"""
function loglikelihood(root::ProbCircuit, data::Matrix, example_id; Float=Float32)
    f_i(node) = begin
        val = data[example_id, first(randvars(node))]
        ismissing(val) ? Float(0.0) : loglikelihood(dist(node), val)
    end
    f_m(node, ins) = sum(ins)
    f_s(node, ins) = reduce(logsumexp, node.params .+ ins)  
    foldup_aggregate(root, f_i, f_m, f_s, Float)
end

function logsumexp(vals::Vector{Float32})
    reduce(logsumexp, vals)
end

"""
    loglikelihoods_vectorized(root::ProbCircuit, data::Matrix; Float=Float32)    

Recursively Computes the loglikelihoods for the whole dataset `data` on cpu. Vectorized but does not do smaller batching, i.e. operates on vectors with length `size(data, 1)`.
**Note: Experimental**; might be removed or renamed later
"""
function loglikelihoods_vectorized(root::ProbCircuit, data::Matrix; Float=Float32)
    f_i(node) = begin
        [ismissing(data[idx, first(randvars(node))]) ? Float(0.0) : loglikelihood(dist(node), data[idx, first(randvars(node))]) for idx=1:size(data,1)]    
    end
    f_m(node, ins) = begin
        sum(ins)
    end
    f_s(node, ins) = begin        
        entry(i, data_idx) = node.params[i] + ins[i][data_idx]

        ans = zeros(Float, size(data, 1))
        for idx = 1:size(data, 1)
            ans[idx] = logsumexp([entry(i, idx) for i=1:size(node.params, 1)])
        end        
        ans
    end
    foldup_aggregate(root, f_i, f_m, f_s, Vector{Float})
end

function loglikelihoods_linearized(root::ProbCircuit, data::Matrix; Float=Float32)
    nodes = num_nodes(root)
    examples = size(data, 1)
    # TODO do batching later
    mars = zeros(Float, (examples, nodes))

    node_mar(node; mars_idx) = begin
        if isinput(node)
            for idx = 1:size(data, 1)
                mars[idx, mars_idx] = ismissing(data[idx, first(randvars(node))]) ? Float(0.0) : loglikelihood(dist(node), data[idx, first(randvars(node))])
            end
        elseif ismul(node)
            for ch in inputs(node)
                mars[:, mars_idx] .+= mars[:, dict[ch]]
            end
        elseif issum(node)
            mars[:, mars_idx] .= typemin(Float)
            for (cidx, ch) in enumerate(inputs(node))
                child_mar_idx = dict[ch]
                mars[:, mars_idx] .= logsumexp.(mars[:, mars_idx], mars[:, child_mar_idx] .+ node.params[cidx])
            end
        end
    end

    linPC = linearize(root)
    dict = Dict{ProbCircuit, Int32}()
    for (i, node) in enumerate(linPC)
        dict[node] = i
    end
    for (mars_idx, node) in enumerate(linPC)
        node_mar(node; mars_idx)
    end

    return mars[:, end]
end