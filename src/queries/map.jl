export map_state, MAP

import DataFrames: DataFrame, mapcols!

#####################
# Circuit MAP/MPE evaluation
#####################

"Evaluate maximum a-posteriori state of the circuit for a given input"
map_state(root::ProbCircuit, data::Union{Bool,Missing}...) =
    map_state(root, collect(Union{Bool,Missing}, data))

map_state(root::ProbCircuit, data::Union{Vector{Union{Bool,Missing}},CuVector{UInt8}}) =
    map_state(root, DataFrame(reshape(data, 1, :)))[1,:]

map_state(circuit::ProbCircuit, data::DataFrame) =
    map_state(same_device(ParamBitCircuit(circuit, data), data) , data)

function map_state(pbc::ParamBitCircuit, data; Float=Float32)
    @assert isgpu(data) == isgpu(pbc) "ParamBitCircuit and data need to be on the same device"
    values = marginal_all(pbc, data)
    state = Matrix{Bool}(undef, num_examples(data), num_features(data))
    logprob = zeros(Float, num_examples(data))
    Threads.@threads for ex_id = 1:num_examples(data)
        map_state_rec(num_leafs(pbc), params(pbc), nodes(pbc), elements(pbc), 
                        ex_id, num_nodes(pbc), values, state, logprob)
    end
    df = DataFrame(state)
    mapcols!(c -> BitVector(c), df)
    df, logprob
end

"""
Maximum a-posteriori queries
"""
const MAP = map_state

function map_state_rec(nl, params, nodes, elements, ex_id, dec_id, values, state, logprob)
    if isleafgate(nl, dec_id)
        if isliteralgate(nl, dec_id)
            l = literal(nl, dec_id)
            @inbounds state[ex_id, lit2var(l)] = (l > 0) 
        end
    else
        # recurse
        edge_log_pr, prime, sub = map_child(params, nodes, elements, ex_id, dec_id, values)
        logprob[ex_id] += edge_log_pr
        map_state_rec(nl, params, nodes, elements, 
            ex_id, prime, values, state, logprob)
        map_state_rec(nl, params, nodes, elements, 
            ex_id, sub, values, state, logprob)
    end
end


"Find the MAP child value and node id of a given decision node"
function map_child(params, nodes, elements, ex_id, dec_id, values)
    els_start = @inbounds nodes[1,dec_id]
    els_end = @inbounds nodes[2,dec_id]
    pr_opt = typemin(eltype(values))
    j_opt = 0
    for j = els_start:els_end
        pr = @inbounds values[ex_id, elements[2,j]] + values[ex_id, elements[3,j]] + params[j]
        if pr > pr_opt
            pr_opt = pr
            j_opt = j
        end
    end
    @inbounds return params[j_opt], elements[2,j_opt], elements[3,j_opt]
end