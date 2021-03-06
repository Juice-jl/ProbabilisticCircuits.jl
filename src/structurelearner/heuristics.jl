
using LinearAlgebra: diagind
export heuristic_loss
"""
Pick the edge with maximum flow
"""
function eFlow(values, flows, candidates::Vector{Tuple{Node, Node}}, node2id)
    edge2flows = map(candidates) do (or, and)
        count_downflow(values, flows, nothing, or, and, node2id)
    end
    (max_flow, max_edge_id) = findmax(edge2flows)
    candidates[max_edge_id], max_flow
end

"""
Pick the variable with maximum sum of mutual information
"""
function vMI(values, flows, edge, vars::Vector{Var}, train_x, node2id)
    examples_id = downflow_all(values, flows, num_examples(train_x), edge..., node2id)
    sub_matrix = train_x[examples_id, vars]
    (_, mi) = mutual_information(sub_matrix; α=1.0)
    mi[diagind(mi)] .= 0
    scores = dropdims(sum(mi, dims = 1), dims = 1)
    var = vars[argmax(scores)]
    score = maximum(scores)
    var, score
end

"""
Pick the edge randomly
"""
function eRand(candidates::Vector{Tuple{Node, Node}})
    return rand(candidates)
end

"""
Pick the variable randomly
"""
function vRand(vars::Vector{Var})
    return Var(rand(vars))
end

function heuristic_loss(circuit::LogicCircuit, train_x; 
                                    pick_edge = "eFlow", 
                                    pick_var = "vMI",
                                    miss_data::Bool = false
                                    )
    if isweighted(train_x)
        train_x, weights = split_sample_weights(train_x)
    else
        weights = nothing
    end


    @assert !(miss_data && pick_var=="vMI") "Cannot use vMI for picking vars for missing data. Use vRand instead."

    candidates, variable_scope = split_candidates(circuit)
    if isempty(candidates) return nothing end

    if miss_data
        # Have to use marginal flows when have missing data
        values, flows, node2id = marginal_flows(circuit, train_x; weights = nothing) # Do not use samples weights here 
    else
        # Satisfies Flows much faster than marginal flows
        values, flows, node2id = satisfies_flows(circuit, train_x; weights = nothing) # Do not use samples weights here    
    end
    
    if pick_edge == "eFlow"
        edge, flow = eFlow(values, flows, candidates, node2id)
    elseif pick_edge == "eRand"
        edge = eRand(candidates)
    else
        error("Heuristics $pick_edge to pick edge is undefined.")
    end

    or, and = edge
    vars = Var.(collect(variable_scope[and]))

    if pick_var == "vMI"
        var, score = vMI(values, flows, edge, vars, train_x, node2id)
    elseif pick_var == "vRand"
        var = vRand(vars)
    else
        error("Heuristics $pick_var to pick variable is undefined.")
    end

    return (or, and), var
end

