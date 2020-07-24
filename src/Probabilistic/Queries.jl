export EVI, log_likelihood_per_instance,
MAR, marginal_log_likelihood_per_instance,
MPE, MAP

"""
Complete evidence queries
"""
function log_likelihood_per_instance(pc::ProbCircuit, data)
    @assert isbinarydata(data) "Can only calculate EVI on Bool data"
    
    compute_flows(origin(pc), data)
    log_likelihoods = zeros(Float64, num_examples(data))
    indices = init_array(Bool, num_examples(data))::BitVector
    
    ll(n::ProbCircuit) = ()
    ll(n::Prob⋁Node) = begin
        if num_children(n) != 1 # other nodes have no effect on likelihood
            foreach(children(origin(n)), n.log_thetas) do c, log_theta
                indices = get_downflow(origin(n), c)
                view(log_likelihoods, indices::BitVector) .+=  log_theta # see MixedProductKernelBenchmark.jl
            end
         end
    end

    foreach(ll, pc)
    log_likelihoods
end

EVI = log_likelihood_per_instance

"""
Marginal queries
"""
function marginal_log_likelihood_per_instance(pc::ProbCircuit, data)
    evaluate(pc, data)
end
MAR = marginal_log_likelihood_per_instance


"""
Most Probable Explanation (MPE), aka MAP
"""
@inline function MAP(pc::ProbCircuit, evidence)::BitMatrix
    MPE(pc, evidence)
end

function MPE(pc::ProbCircuit, evidence)::BitMatrix
    mlls = marginal_log_likelihood_per_instance(pc, evidence)
    
    ans = falses(num_examples(evidence), num_features(evidence))
    active_samples = trues(num_examples(evidence))

    function mpe_simulate(node::ProbLiteralNode, active_samples::BitVector, result::BitMatrix)
        if ispositive(node)
            result[active_samples, variable(node)] .= 1
        else
            result[active_samples, variable(node)] .= 0
        end
    end
    
    function mpe_simulate(node::Prob⋁Node, active_samples::BitVector, result::BitMatrix)
        prs = zeros(length(node.children), size(active_samples)[1] )
        @simd  for i=1:length(node.children)
            prs[i,:] .= get_upflow(node.children[i]) .+ (node.log_thetas[i])
        end
    
        max_child_ids = [a[1] for a in argmax(prs, dims = 1) ]
        @simd for i=1:length(node.children)
            # Only active for this child if it was the max for that sample
            ids = convert(BitVector, active_samples .* (max_child_ids .== i)[1,:])
            mpe_simulate(node.children[i], ids, result)
        end
    end
    
    function mpe_simulate(node::Prob⋀Node, active_samples::BitVector, result::BitMatrix)
        for child in children(node)
            mpe_simulate(child, active_samples, result)
        end
    end

    mpe_simulate(pc, active_samples, ans)
    ans
end



