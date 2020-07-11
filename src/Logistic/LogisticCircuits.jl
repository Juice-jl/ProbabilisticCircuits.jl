#######################
## Logistic Circuits
#######################


abstract type LogisticNode{O} <: DecoratorNode{O} end
abstract type LogisticLeafNode{O} <: LogisticNode{O} end
abstract type LogisticInnerNode{O} <: LogisticNode{O} end

struct LogisticLiteral{O} <: LogisticLeafNode{O}
    origin::O
end

struct Logistic⋀{O} <: LogisticInnerNode{O}
    origin::O
    children::Vector{<:LogisticNode{<:O}}
end

mutable struct Logistic⋁{O} <: LogisticInnerNode{O}
    origin::O
    children::Vector{<:LogisticNode{<:O}}
    thetas::Array{Float64, 2}
end



const LogisticΔ{O} = AbstractVector{<:LogisticNode{O}}

#####################
# traits
#####################

import LogicCircuits.GateType # make available for extension

@inline GateType(::Type{<:LogisticLiteral}) = LiteralGate()
@inline GateType(::Type{<:Logistic⋀}) = ⋀Gate()
@inline GateType(::Type{<:Logistic⋁}) = ⋁Gate()



#####################
# constructors and conversions
#####################

function Logistic⋁(::Type{O}, origin, children, classes::Int) where {O}
    Logistic⋁{O}(origin, children, Array{Float64, 2}(undef, (length(children), classes)))
end


const LogisticCache = Dict{Node, LogisticNode}

function LogisticΔ(circuit::Δ, classes::Int, cache::LogisticCache = LogisticCache())

    sizehint!(cache, length(circuit)*4÷3)
    
    O = grapheltype(circuit) # type of node in the origin

    pc_node(::LiteralGate, n::LogicCircuit) = LogisticLiteral{O}(n)
    pc_node(::ConstantGate, n::LogicCircuit) = error("Cannot construct a logistic circuit from constant leafs: first smooth and remove unsatisfiable branches.")

    pc_node(::⋀Gate, n::LogicCircuit) = begin
        children = map(c -> cache[c], n.children)
        Logistic⋀{O}(n, children)
    end

    pc_node(::⋁Gate, n::LogicCircuit) = begin
        children = map(c -> cache[c], n.children)
        Logistic⋁(O, n, children, classes)
    end
        
    map(circuit) do node
        pcn = pc_node(GateType(node), node)
        cache[node] = pcn
        pcn
    end
end


#####################
# methods
#####################

import LogicCircuits: literal, children # make available for extension

@inline literal(n::LogisticLiteral)::Lit  = literal(n.origin)
@inline children(n::LogisticInnerNode) = n.children
@inline classes(n::Logistic⋁) = size(n.thetas)[2]

num_parameters(n::Logistic⋁) = num_children(n) * classes(n)
num_parameters(c::LogisticΔ) = sum(n -> num_parameters(n), ⋁_nodes(c))

num_parameters_perclass(n::Logistic⋁) = num_children(n)
num_parameters_perclass(c::LogisticΔ) = sum(n -> num_parameters_perclass(n), ⋁_nodes(c))

"Return the first origin that is a Logistic circuit node"
logistic_origin(n::DecoratorNode)::LogisticNode = origin(n,LogisticNode)

"Return the first origin that is a Logistic circuit"
logistic_origin(c::DecoratorΔ)::LogisticΔ = origin(c, LogisticNode)


# TODO Learning



# Class Conditional Probability
function class_conditional_likelihood_per_instance(fc::FlowΔ, 
                                                    classes::Int, 
                                                    batch::PlainXData{Bool})
    lc = origin(origin(fc))
    @assert(lc isa LogisticΔ)
    pass_up_down(fc, batch)
    likelihoods = zeros(num_examples(batch), classes)
    for n in fc
        orig = logistic_origin(n)
        if orig isa Logistic⋁
            # For each class. orig.thetas is 2D so used eachcol
            for (idx, thetaC) in enumerate(eachcol(orig.thetas))
                foreach(n.children, thetaC) do c, theta
                    likelihoods[:, idx] .+= prod_fast(downflow(n), pr_factors(origin(c))) .* theta
                end
            end
        end
    end
    likelihoods
end

"""
Calculate conditional log likelihood for a batch of samples with evidence P(c | x).
(Also returns the generated FlowΔ)
"""
function class_conditional_likelihood_per_instance(lc::LogisticΔ, 
                                                    classes::Int, 
                                                    batch::PlainXData{Bool})
    opts = (max_factors = 2, compact⋀=false, compact⋁=false)
    fc = FlowΔ(lc, num_examples(batch), Float64, opts)
    (fc, class_conditional_likelihood_per_instance(fc, classes, batch))
end

