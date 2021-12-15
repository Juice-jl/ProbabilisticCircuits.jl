# PROBABILISTIC CIRCUITS LIBRARY ROOT

module ProbabilisticCircuits

# USE EXTERNAL MODULES

using Reexport

using LogicCircuits

# only reexport selectively from LogicCircuits
export pos_literals, neg_literals, print_tree, literal
# circuit queries
export issmooth, isdecomposable, isstruct_decomposable, 
       isdeterministic, iscanonical
# circuit status
export num_nodes, num_edges, children, num_parameters, num_children
export num_variables
export zoo_vtree, zoo_vtree_file, VtreeFormat, vtree, respects_vtree
export linearize, isliteralgate, literal, fully_factorized_circuit
# datasets
export twenty_datasets, to_gpu, to_cpu

export isleaf, isinner

include("Utils/Utils.jl")
@reexport using .Utils

include("factor_graph/factor_graph.jl")
include("factor_graph/fg_compile.jl") 

include("abstract_prob_nodes.jl")
include("shared_prob_nodes.jl")
include("plain_prob_nodes.jl")
include("structured_prob_nodes.jl")
include("bit_circuits/param_bit_circuit.jl")
include("parameter_learn/parameters.jl")
include("parameter_learn/gradient_based_learning.jl")

include("bit_circuits/edge_bit_circuit_local.jl")
include("bit_circuits/edge_bit_circuit_sparser.jl")
include("bit_circuits/edge_bit_circuit_local_transposed.jl")

include("queries/likelihood.jl")
include("queries/marginal_flow.jl")
include("queries/map.jl")
include("queries/sample.jl")
include("queries/pr_constraint.jl")
include("queries/information.jl")

include("mixtures/em.jl")

include("structurelearner/chow_liu_tree.jl")
include("structurelearner/init.jl")
include("structurelearner/heuristics.jl")
include("structurelearner/learner.jl")
include("structurelearner/vtree_learner.jl")
include("structurelearner/sample_psdd.jl")
include("structurelearner/bdd.jl")
include("structurelearner/rat_spn.jl")
include("structurelearner/hclt.jl")


include("ensembles/ensembles.jl")
include("ensembles/bmc.jl")

include("io/io.jl")

using Requires

function __init__()
    # optional dependency
    @require BlossomV = "6c721016-9dae-5d90-abf6-67daaccb2332" include("structurelearner/vtree_learner_blossomv.jl")
end

end
