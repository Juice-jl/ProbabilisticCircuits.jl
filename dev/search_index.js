var documenterSearchIndex = {"docs":
[{"location":"manual/examples/#Examples-1","page":"Examples","title":"Examples","text":"","category":"section"},{"location":"manual/examples/#","page":"Examples","title":"Examples","text":"note: Note\nMore examples coming soon, for now please refer to the Juice Examples Repository","category":"page"},{"location":"manual/installation/#Installation-1","page":"Installation","title":"Installation","text":"","category":"section"},{"location":"manual/installation/#","page":"Installation","title":"Installation","text":"To install the latest stable release, run:","category":"page"},{"location":"manual/installation/#","page":"Installation","title":"Installation","text":"julia -e 'using Pkg; Pkg.add(\"ProbabilisticCircuits\")'","category":"page"},{"location":"api/internals/utils/#Utils-1","page":"Utils","title":"Utils","text":"","category":"section"},{"location":"api/internals/utils/#","page":"Utils","title":"Utils","text":"Modules = [Utils]","category":"page"},{"location":"api/internals/utils/#ProbabilisticCircuits.Utils","page":"Utils","title":"ProbabilisticCircuits.Utils","text":"Module with general utilities and missing standard library features that could be useful in any Julia project\n\n\n\n\n\n","category":"module"},{"location":"api/internals/utils/#ProbabilisticCircuits.Utils.generate_all-Tuple{Array{Int8,N} where N}","page":"Utils","title":"ProbabilisticCircuits.Utils.generate_all","text":"Given some missing values generates all possible fillings\n\n\n\n\n\n","category":"method"},{"location":"api/internals/utils/#ProbabilisticCircuits.Utils.generate_data_all-Tuple{Int64}","page":"Utils","title":"ProbabilisticCircuits.Utils.generate_data_all","text":"Generates all possible binary configurations of size N\n\n\n\n\n\n","category":"method"},{"location":"api/internals/utils/#ProbabilisticCircuits.Utils.one_hot_encode-Union{Tuple{T}, Tuple{Array{T,2},Array{T,1}}} where T","page":"Utils","title":"ProbabilisticCircuits.Utils.one_hot_encode","text":"One-hot encode data (2-D Array) based on categories (1-D Array) Each row of the return value is a concatenation of one-hot encoding of elements of the same row in data Assumption: both input arrays have elements of same type\n\n\n\n\n\n","category":"method"},{"location":"api/internals/logistic/#Logistic-1","page":"Logistic","title":"Logistic","text":"","category":"section"},{"location":"api/internals/logistic/#","page":"Logistic","title":"Logistic","text":"Modules = [Logistic]","category":"page"},{"location":"api/internals/logistic/#ProbabilisticCircuits.Logistic.class_conditional_likelihood_per_instance-Tuple{AbstractArray{#s45,1} where #s45<:LogisticΔNode{O} where O,Int64,LogicCircuits.Data.PlainXData{Bool,M} where M<:(AbstractArray{#s14,2} where #s14<:Bool)}","page":"Logistic","title":"ProbabilisticCircuits.Logistic.class_conditional_likelihood_per_instance","text":"Calculate conditional log likelihood for a batch of samples with evidence P(c | x). (Also returns the generated FlowΔ)\n\n\n\n\n\n","category":"method"},{"location":"api/internals/logistic/#ProbabilisticCircuits.Logistic.logistic_origin-Tuple{AbstractArray{#s36,1} where #s36<:LogicCircuits.Logical.DecoratorΔNode{O} where O}","page":"Logistic","title":"ProbabilisticCircuits.Logistic.logistic_origin","text":"Return the first origin that is a Logistic circuit\n\n\n\n\n\n","category":"method"},{"location":"api/internals/logistic/#ProbabilisticCircuits.Logistic.logistic_origin-Tuple{LogicCircuits.Logical.DecoratorΔNode}","page":"Logistic","title":"ProbabilisticCircuits.Logistic.logistic_origin","text":"Return the first origin that is a Logistic circuit node\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#Probabilistic-1","page":"Probabilistic","title":"Probabilistic","text":"","category":"section"},{"location":"api/internals/probabilistic/#","page":"Probabilistic","title":"Probabilistic","text":"Modules = [Probabilistic]","category":"page"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.AbstractFlatMixture","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.AbstractFlatMixture","text":"A probabilistic mixture model whose components are not themselves mixtures\n\n\n\n\n\n","category":"type"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.AbstractMetaMixture","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.AbstractMetaMixture","text":"A probabilistic mixture model whose components are themselves mixtures\n\n\n\n\n\n","category":"type"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.AbstractMixture","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.AbstractMixture","text":"A probabilistic mixture model\n\n\n\n\n\n","category":"type"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.DisCache","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.DisCache","text":"Cache pairwise / marginal distribution for all variables in one dataset\n\n\n\n\n\n","category":"type"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.FlatMixture","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.FlatMixture","text":"A probabilistic mixture model of probabilistic circuits\n\n\n\n\n\n","category":"type"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.FlatMixtureWithFlow","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.FlatMixtureWithFlow","text":"A mixture with cached flow circuits for each component (which are assumed to be ProbΔs)\n\n\n\n\n\n","category":"type"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.MetaMixture","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.MetaMixture","text":"A probabilistic mixture model of mixture models\n\n\n\n\n\n","category":"type"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.aggregate_flows-Tuple{Any,Any,Any}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.aggregate_flows","text":"Compute and aggregate flows for mixture components\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.blossom_bottom_up!-Tuple{Array{UInt32,1},BlossomContext}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.blossom_bottom_up!","text":"Blossom bottom up method, vars are not used\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.component_weights-Tuple{FlatMixture}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.component_weights","text":"Get the component weights in this mixture\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.components-Tuple{FlatMixture}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.components","text":"Get the components in this mixture\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.conjoin_like-Tuple{ProbΔNode,Array{T,1} where T}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.conjoin_like","text":"Conjoin nodes in the same way as the example\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.disjoin_like-Tuple{ProbΔNode,Array{T,1} where T}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.disjoin_like","text":"Disjoin nodes in the same way as the example\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.init_mixture_with_flows-Tuple{FlatMixtureWithFlow,AbstractArray{#s14,1} where #s14<:XD where XD<:(LogicCircuits.Data.XData{Bool,M} where M<:(AbstractArray{#s14,2} where #s14<:Bool))}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.init_mixture_with_flows","text":"Ensure we have a FlatMixtureWithFlow where the flow circuits have aggregate flow circuits as origin\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.literal_like-Tuple{ProbΔNode,Int32}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.literal_like","text":"Construct a new literal node like the given node's type\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.log_likelihood_per_instance-Tuple{AbstractArray{#s16,1} where #s16<:(ProbΔNode{#s15} where #s15<:O) where O,AbstractArray{#s14,1} where #s14<:XD where XD<:(LogicCircuits.Data.XData{Bool,M} where M<:(AbstractArray{#s14,2} where #s14<:Bool))}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.log_likelihood_per_instance","text":"Calculate log likelihood per instance for batches of samples.\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.log_likelihood_per_instance-Tuple{AbstractArray{#s16,1} where #s16<:(ProbΔNode{#s15} where #s15<:O) where O,LogicCircuits.Data.PlainXData{Bool,M} where M<:(AbstractArray{#s14,2} where #s14<:Bool)}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.log_likelihood_per_instance","text":"Calculates log likelihood for a batch of fully observed samples. (Also retures the generated FlowΔ)\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.log_likelihood_per_instance-Tuple{AbstractArray{#s36,1} where #s36<:LogicCircuits.Logical.DownFlowΔNode{O,F} where F where O,LogicCircuits.Data.PlainXData{Bool,M} where M<:(AbstractArray{#s14,2} where #s14<:Bool)}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.log_likelihood_per_instance","text":"Calculate log likelihood for a batch of fully observed samples. (This is for when you already have a FlowΔ)\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.log_likelihood_per_instance_component-Tuple{FlatMixtureWithFlow,AbstractArray{#s14,1} where #s14<:XD where XD<:(LogicCircuits.Data.XData{Bool,M} where M<:(AbstractArray{#s14,2} where #s14<:Bool))}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.log_likelihood_per_instance_component","text":"Log likelihood per instance and component. A vector of matrices per batch where the first dimension is instance, second is components.\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.log_likelihood_per_instance_component-Tuple{FlatMixtureWithFlow,LogicCircuits.Data.PlainXData{Bool,M} where M<:(AbstractArray{#s14,2} where #s14<:Bool)}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.log_likelihood_per_instance_component","text":"Log likelihood per instance and component. First dimension is instance, second is components.\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.log_likelihood_per_instance_component-Tuple{MetaMixture,AbstractArray{#s14,1} where #s14<:XD where XD<:(LogicCircuits.Data.XData{Bool,M} where M<:(AbstractArray{#s14,2} where #s14<:Bool))}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.log_likelihood_per_instance_component","text":"Log likelihood per instance and component. A vector of matrices per batch where the first dimension is instance, second is components.\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.log_likelihood_per_instance_component-Tuple{MetaMixture,LogicCircuits.Data.PlainXData{Bool,M} where M<:(AbstractArray{#s14,2} where #s14<:Bool)}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.log_likelihood_per_instance_component","text":"Log likelihood per instance and component. First dimension is instance, second is components.\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.marginal_log_likelihood_per_instance-Tuple{AbstractArray{#s16,1} where #s16<:(ProbΔNode{#s15} where #s15<:O) where O,LogicCircuits.Data.PlainXData{Int8,M} where M<:(AbstractArray{#s14,2} where #s14<:Int8)}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.marginal_log_likelihood_per_instance","text":"Calculate log likelihood for a batch of samples with partial evidence P(e). (Also returns the generated FlowΔ)\n\nTo indicate a variable is not observed, pass -1 for that variable.\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.marginal_log_likelihood_per_instance-Tuple{AbstractArray{#s36,1} where #s36<:LogicCircuits.Logical.UpFlowΔNode{O,F} where F where O,LogicCircuits.Data.PlainXData{Int8,M} where M<:(AbstractArray{#s14,2} where #s14<:Int8)}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.marginal_log_likelihood_per_instance","text":"Calculate log likelihood for a batch of samples with partial evidence P(e). (If you already have a FlowΔ)\n\nTo indicate a variable is not observed, pass -1 for that variable.\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.metis_top_down-Tuple{Array{UInt32,1},MetisContext}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.metis_top_down","text":"Metis top down method\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.mutual_information","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.mutual_information","text":"Calculate mutual information of given bit matrix bm, example weights w, and smoothing pseudocount α\n\n\n\n\n\n","category":"function"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.num_components-Tuple{AbstractMixture}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.num_components","text":"Number of components in a mixture\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.pr_constraint-Tuple{ProbΔNode,Union{LogicCircuits.Logical.StructLogicalΔNode, ProbΔNode}}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.pr_constraint","text":"Calculate the probability of the logic formula given by sdd for the psdd\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.prob_origin-Tuple{AbstractArray{#s36,1} where #s36<:LogicCircuits.Logical.DecoratorΔNode{O} where O}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.prob_origin","text":"Return the first origin that is a probabilistic circuit\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.prob_origin-Tuple{LogicCircuits.Logical.DecoratorΔNode}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.prob_origin","text":"Return the first origin that is a probabilistic circuit node\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.psdd_entropy-Tuple{ProbΔNode}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.psdd_entropy","text":"Entropy of the distribution of the input psdd.\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.psdd_kl_divergence-Tuple{ProbΔNode,ProbΔNode}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.psdd_kl_divergence","text":"KL divergence calculation for psdds that are not necessarily identical\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.sample-Tuple{AbstractArray{#s16,1} where #s16<:(ProbΔNode{#s15} where #s15<:O) where O,LogicCircuits.Data.PlainXData{Int8,M} where M<:(AbstractArray{#s14,2} where #s14<:Int8)}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.sample","text":"Sampling with Evidence from a psdd. Internally would call marginal pass up on a newly generated flow circuit.\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.sample-Tuple{AbstractArray{#s16,1} where #s16<:(ProbΔNode{#s15} where #s15<:O) where O}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.sample","text":"Sample from a PSDD without any evidence\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.sample-Tuple{AbstractArray{#s36,1} where #s36<:LogicCircuits.Logical.UpFlowΔNode{O,F} where F where O}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.sample","text":"Sampling with Evidence from a psdd. Assuming already marginal pass up has been done on the flow circuit.\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.test_bottom_up!-Tuple{Array{UInt32,1}}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.test_bottom_up!","text":"Test bottom up method, split nodes by ascending order, balanced\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.test_top_down-Tuple{Array{UInt32,1}}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.test_top_down","text":"Test top down method, split nodes by ascending order, balanced\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.train_mixture-Tuple{AbstractFlatMixture,AbstractArray{#s14,1} where #s14<:XD where XD<:(LogicCircuits.Data.XData{Bool,M} where M<:(AbstractArray{#s14,2} where #s14<:Bool)),Any,Any}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.train_mixture","text":"Train a mixture model from data. Learning is initialized from the parameters stored in the given mixture. When a structure_learner is given, it will be called between EM steps to update circuit structures.\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.train_mixture-Tuple{Array{#s38,1} where #s38<:(AbstractArray{#s16,1} where #s16<:(ProbΔNode{#s15} where #s15<:O) where O),AbstractArray{#s14,1} where #s14<:XD where XD<:(LogicCircuits.Data.XData{Bool,M} where M<:(AbstractArray{#s14,2} where #s14<:Bool)),Any,Any}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.train_mixture","text":"Train a mixture of probabilistic circuits from data, starting with random example weights.\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.aggregate_flows_cached-Tuple{Any,Any,Any}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.aggregate_flows_cached","text":"Aggregate already-computed flows for mixture components\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.component_weights_per_example-Tuple{Any}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.component_weights_per_example","text":"Compute the component weights for each example from likelihoods\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.ensure_with_flows-Tuple{FlatMixture,Int64}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.ensure_with_flows","text":"Convert a given flat mixture into one with cached flows\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.log_likelihood_per_component_instance-Tuple{FlatMixtureWithFlow,LogicCircuits.Data.PlainXData{Bool,M} where M<:(AbstractArray{#s14,2} where #s14<:Bool)}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.log_likelihood_per_component_instance","text":"Log likelihood per component and instance. Outer vector is components, inner vector is instances\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.log_likelihood_per_component_instance-Tuple{MetaMixture,LogicCircuits.Data.PlainXData{Bool,M} where M<:(AbstractArray{#s14,2} where #s14<:Bool)}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.log_likelihood_per_component_instance","text":"Log likelihood per component and instance. Outer vector is components, inner vector is instances\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.mpe_simulate-Tuple{LogicCircuits.Logical.UpFlowLiteral,Array{Bool,1},Array{Bool,2}}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.mpe_simulate","text":"activesamples: bool vector indicating which samples are active for this node during mpe result: Matrix (numsamples, num_variables) indicating the final result of mpe\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.random_example_weights-Tuple{Int64,Int64}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.random_example_weights","text":"Create random example weights that sum to one overall components\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.set_mutual_information-Tuple{Array{T,2} where T,Array{Array{UInt32,1},1}}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.set_mutual_information","text":"Calculate set mutual information\n\n\n\n\n\n","category":"method"},{"location":"api/internals/probabilistic/#ProbabilisticCircuits.Probabilistic.weighted_batch_for_component-Tuple{LogicCircuits.Data.PlainXData,Any,Any}","page":"Probabilistic","title":"ProbabilisticCircuits.Probabilistic.weighted_batch_for_component","text":"Get a new weighted batch for this component\n\n\n\n\n\n","category":"method"},{"location":"api/internals/structureLearner/#StructureLearner-1","page":"StructureLearner","title":"StructureLearner","text":"","category":"section"},{"location":"api/internals/structureLearner/#","page":"StructureLearner","title":"StructureLearner","text":"Modules = [StructureLearner]","category":"page"},{"location":"api/internals/structureLearner/#ProbabilisticCircuits.StructureLearner.⊤","page":"StructureLearner","title":"ProbabilisticCircuits.StructureLearner.⊤","text":"Use literal to represent constraint (1 to X, -1 to not X), 0 to represent true\n\n\n\n\n\n","category":"constant"},{"location":"api/internals/structureLearner/#ProbabilisticCircuits.StructureLearner.CLT","page":"StructureLearner","title":"ProbabilisticCircuits.StructureLearner.CLT","text":"Chow-Liu Tree\n\n\n\n\n\n","category":"type"},{"location":"api/internals/structureLearner/#ProbabilisticCircuits.StructureLearner.LitCache","page":"StructureLearner","title":"ProbabilisticCircuits.StructureLearner.LitCache","text":"Map from literal to LogicalΔNode\n\n\n\n\n\n","category":"type"},{"location":"api/internals/structureLearner/#ProbabilisticCircuits.StructureLearner.compile_prob_circuit_from_clt-Tuple{MetaGraphs.MetaDiGraph}","page":"StructureLearner","title":"ProbabilisticCircuits.StructureLearner.compile_prob_circuit_from_clt","text":"Build decomposable probability circuits from Chow-Liu tree\n\n\n\n\n\n","category":"method"},{"location":"api/internals/structureLearner/#ProbabilisticCircuits.StructureLearner.compile_psdd_from_clt-Tuple{MetaGraphs.MetaDiGraph,AbstractArray{#s36,1} where #s36<:LogicCircuits.Logical.PlainVtreeNode}","page":"StructureLearner","title":"ProbabilisticCircuits.StructureLearner.compile_psdd_from_clt","text":"Compile a psdd circuit from clt and vtree\n\n\n\n\n\n","category":"method"},{"location":"api/internals/structureLearner/#ProbabilisticCircuits.StructureLearner.learn_chow_liu_tree-Tuple{LogicCircuits.Data.XData}","page":"StructureLearner","title":"ProbabilisticCircuits.StructureLearner.learn_chow_liu_tree","text":"learn a Chow-Liu tree from training set train_x, with Laplace smoothing factor α, specifying the tree root by clt_root return a CLT\n\n\n\n\n\n","category":"method"},{"location":"api/internals/structureLearner/#ProbabilisticCircuits.StructureLearner.learn_probabilistic_circuit-Tuple{Union{LogicCircuits.Data.WXData, LogicCircuits.Data.XData}}","page":"StructureLearner","title":"ProbabilisticCircuits.StructureLearner.learn_probabilistic_circuit","text":"Learning from data a circuit with several structure learning algorithms\n\n\n\n\n\n","category":"method"},{"location":"api/internals/structureLearner/#ProbabilisticCircuits.StructureLearner.learn_struct_prob_circuit-Tuple{Union{LogicCircuits.Data.WXData, LogicCircuits.Data.XData}}","page":"StructureLearner","title":"ProbabilisticCircuits.StructureLearner.learn_struct_prob_circuit","text":"Learning from data a structured-decomposable circuit with several structure learning algorithms\n\n\n\n\n\n","category":"method"},{"location":"api/internals/structureLearner/#ProbabilisticCircuits.StructureLearner.learn_vtree_from_clt-Tuple{MetaGraphs.MetaDiGraph}","page":"StructureLearner","title":"ProbabilisticCircuits.StructureLearner.learn_vtree_from_clt","text":"Learn a vtree from clt, with strategy (close to) linear or balanced\n\n\n\n\n\n","category":"method"},{"location":"api/internals/structureLearner/#ProbabilisticCircuits.StructureLearner.parent_vector-Tuple{MetaGraphs.MetaDiGraph}","page":"StructureLearner","title":"ProbabilisticCircuits.StructureLearner.parent_vector","text":"Get parent vector of a tree\n\n\n\n\n\n","category":"method"},{"location":"api/internals/structureLearner/#ProbabilisticCircuits.StructureLearner.print_tree-Tuple{MetaGraphs.MetaDiGraph}","page":"StructureLearner","title":"ProbabilisticCircuits.StructureLearner.print_tree","text":"Print edges and vertices of a ChowLiu tree\n\n\n\n\n\n","category":"method"},{"location":"api/internals/structureLearner/#ProbabilisticCircuits.StructureLearner.add_prob_leaf_node-Tuple{UInt32,LogicCircuits.Logical.PlainVtreeLeafNode,Dict{Int32,LogicCircuits.Logical.LogicalΔNode},Dict{LogicCircuits.Logical.ΔNode,ProbΔNode},Any}","page":"StructureLearner","title":"ProbabilisticCircuits.StructureLearner.add_prob_leaf_node","text":"Add leaf nodes to circuit lin\n\n\n\n\n\n","category":"method"},{"location":"api/internals/structureLearner/#ProbabilisticCircuits.StructureLearner.add_prob⋀_node-Tuple{AbstractArray{#s16,1} where #s16<:(ProbΔNode{#s15} where #s15<:O) where O,LogicCircuits.Logical.PlainVtreeInnerNode,Dict{LogicCircuits.Logical.ΔNode,ProbΔNode},Any}","page":"StructureLearner","title":"ProbabilisticCircuits.StructureLearner.add_prob⋀_node","text":"Add prob⋀ node to circuit lin\n\n\n\n\n\n","category":"method"},{"location":"api/internals/structureLearner/#ProbabilisticCircuits.StructureLearner.add_prob⋁_node-Tuple{AbstractArray{#s16,1} where #s16<:(ProbΔNode{#s15} where #s15<:O) where O,LogicCircuits.Logical.PlainVtreeNode,Array{Float64,1},Dict{LogicCircuits.Logical.ΔNode,ProbΔNode},Any}","page":"StructureLearner","title":"ProbabilisticCircuits.StructureLearner.add_prob⋁_node","text":"Add prob⋁ node to circuit lin\n\n\n\n\n\n","category":"method"},{"location":"api/internals/structureLearner/#ProbabilisticCircuits.StructureLearner.compile_decision_node-Tuple{AbstractArray{#s16,1} where #s16<:(ProbΔNode{#s15} where #s15<:O) where O,AbstractArray{#s16,1} where #s16<:(ProbΔNode{#s15} where #s15<:O) where O,LogicCircuits.Logical.PlainVtreeInnerNode,Array{Float64,1},Dict{LogicCircuits.Logical.ΔNode,ProbΔNode},Any}","page":"StructureLearner","title":"ProbabilisticCircuits.StructureLearner.compile_decision_node","text":"Construct decision nodes given primes and subs\n\n\n\n\n\n","category":"method"},{"location":"api/internals/structureLearner/#ProbabilisticCircuits.StructureLearner.compile_decision_nodes-Tuple{AbstractArray{#s16,1} where #s16<:(ProbΔNode{#s15} where #s15<:O) where O,AbstractArray{#s16,1} where #s16<:(ProbΔNode{#s15} where #s15<:O) where O,LogicCircuits.Logical.PlainVtreeInnerNode,Array{Float64,1},Dict{LogicCircuits.Logical.ΔNode,ProbΔNode},Any}","page":"StructureLearner","title":"ProbabilisticCircuits.StructureLearner.compile_decision_nodes","text":"Construct decision nodes conditiond on different distribution\n\n\n\n\n\n","category":"method"},{"location":"api/internals/structureLearner/#ProbabilisticCircuits.StructureLearner.compile_literal_nodes-Tuple{UInt32,LogicCircuits.Logical.PlainVtreeLeafNode,Array{Float64,1},Dict{Int32,LogicCircuits.Logical.LogicalΔNode},Dict{LogicCircuits.Logical.ΔNode,ProbΔNode},Any}","page":"StructureLearner","title":"ProbabilisticCircuits.StructureLearner.compile_literal_nodes","text":"Construct literal nodes given variable var\n\n\n\n\n\n","category":"method"},{"location":"api/internals/structureLearner/#ProbabilisticCircuits.StructureLearner.compile_true_nodes-Tuple{UInt32,LogicCircuits.Logical.PlainVtreeLeafNode,Array{Float64,1},Dict{Int32,LogicCircuits.Logical.LogicalΔNode},Dict{LogicCircuits.Logical.ΔNode,ProbΔNode},Any}","page":"StructureLearner","title":"ProbabilisticCircuits.StructureLearner.compile_true_nodes","text":"Construct true nodes given variable var\n\n\n\n\n\n","category":"method"},{"location":"api/internals/structureLearner/#ProbabilisticCircuits.StructureLearner.get_cpt-Tuple{Any,Any,Any}","page":"StructureLearner","title":"ProbabilisticCircuits.StructureLearner.get_cpt","text":"Calculate CPT of child conditioned on parent from dis_cache\n\n\n\n\n\n","category":"method"},{"location":"api/internals/structureLearner/#ProbabilisticCircuits.StructureLearner.lit2value-Tuple{Int32}","page":"StructureLearner","title":"ProbabilisticCircuits.StructureLearner.lit2value","text":"convert literal+/- to probability value 0/1\n\n\n\n\n\n","category":"method"},{"location":"api/internals/io/#IO-1","page":"IO","title":"IO","text":"","category":"section"},{"location":"api/internals/io/#","page":"IO","title":"IO","text":"Modules = [ProbabilisticCircuits.IO]","category":"page"},{"location":"api/internals/io/#ProbabilisticCircuits.IO.load_prob_circuit-Tuple{String}","page":"IO","title":"ProbabilisticCircuits.IO.load_prob_circuit","text":"Load a probabilistic circuit from file. Support circuit file formats:\n\n\".psdd\" for PSDD files\n\n\n\n\n\n","category":"method"},{"location":"api/internals/io/#ProbabilisticCircuits.IO.load_struct_prob_circuit-Tuple{String,String}","page":"IO","title":"ProbabilisticCircuits.IO.load_struct_prob_circuit","text":"Load a structured probabilistic circuit from file. Support circuit file formats:\n\n\".psdd\" for PSDD files\n\nSupported vtree file formats:\n\n\".vtree\" for VTree files\n\n\n\n\n\n","category":"method"},{"location":"api/internals/io/#ProbabilisticCircuits.IO.parse_clt-Tuple{String}","page":"IO","title":"ProbabilisticCircuits.IO.parse_clt","text":"Parse a clt from given file\n\n\n\n\n\n","category":"method"},{"location":"api/internals/io/#ProbabilisticCircuits.IO.save_as_dot-Tuple{AbstractArray{#s16,1} where #s16<:(ProbΔNode{#s15} where #s15<:O) where O,String}","page":"IO","title":"ProbabilisticCircuits.IO.save_as_dot","text":"Save prob circuits to .dot file\n\n\n\n\n\n","category":"method"},{"location":"api/internals/io/#ProbabilisticCircuits.IO.save_as_dot-Tuple{ProbΔNode,String}","page":"IO","title":"ProbabilisticCircuits.IO.save_as_dot","text":"Save prob circuit to .dot file\n\n\n\n\n\n","category":"method"},{"location":"api/internals/io/#ProbabilisticCircuits.IO.compile_logistic-Tuple{AbstractArray{#s36,1} where #s36<:LogicCircuits.IO.CircuitFormatLine,Int64}","page":"IO","title":"ProbabilisticCircuits.IO.compile_logistic","text":"Compile lines into a logistic circuit.\n\n\n\n\n\n","category":"method"},{"location":"api/internals/io/#ProbabilisticCircuits.IO.compile_prob-Tuple{AbstractArray{#s36,1} where #s36<:LogicCircuits.IO.CircuitFormatLine}","page":"IO","title":"ProbabilisticCircuits.IO.compile_prob","text":"Compile lines into a probabilistic circuit.\n\n\n\n\n\n","category":"method"},{"location":"api/internals/io/#ProbabilisticCircuits.IO.compile_struct_prob-Tuple{AbstractArray{#s36,1} where #s36<:LogicCircuits.IO.CircuitFormatLine,AbstractArray{#s36,1} where #s36<:LogicCircuits.IO.VtreeFormatLine}","page":"IO","title":"ProbabilisticCircuits.IO.compile_struct_prob","text":"Compile circuit and vtree lines into a structured probabilistic circuit (one whose logical circuit origin is structured).\n\n\n\n\n\n","category":"method"},{"location":"#ProbabilisticCircuits.jl-1","page":"Home","title":"ProbabilisticCircuits.jl","text":"","category":"section"},{"location":"#","page":"Home","title":"Home","text":"Documentation for ProbabilisticCircuits.jl.","category":"page"},{"location":"#","page":"Home","title":"Home","text":"note: Note\nThe documentation is still under construction and not complete yet. For more information or documentation requests please refer to the github repo for now.","category":"page"},{"location":"api/internals/reasoning/#Reasoning-1","page":"Reasoning","title":"Reasoning","text":"","category":"section"},{"location":"api/internals/reasoning/#","page":"Reasoning","title":"Reasoning","text":"Modules = [Reasoning]","category":"page"},{"location":"api/internals/reasoning/#ProbabilisticCircuits.Reasoning.ExpFlowΔ-Union{Tuple{El}, Tuple{AbstractArray{#s16,1} where #s16<:(ProbΔNode{#s15} where #s15<:O) where O,AbstractArray{#s45,1} where #s45<:LogisticΔNode{O} where O,Int64,Type{El}}} where El","page":"Reasoning","title":"ProbabilisticCircuits.Reasoning.ExpFlowΔ","text":"Construct a upward expectation flow circuit from a given pair of PC and LC circuits Note that its assuming the two circuits share the same vtree\n\n\n\n\n\n","category":"method"},{"location":"api/internals/reasoning/#ProbabilisticCircuits.Reasoning.Expectation-Tuple{AbstractArray{#s16,1} where #s16<:(ProbΔNode{#s15} where #s15<:O) where O,AbstractArray{#s45,1} where #s45<:LogisticΔNode{O} where O,LogicCircuits.Data.XData{Int8,M} where M<:(AbstractArray{#s14,2} where #s14<:Int8)}","page":"Reasoning","title":"ProbabilisticCircuits.Reasoning.Expectation","text":"Missing values should be denoted by -1\n\n\n\n\n\n","category":"method"},{"location":"api/internals/reasoning/#ProbabilisticCircuits.Reasoning.DecoratorΔNodePair","page":"Reasoning","title":"ProbabilisticCircuits.Reasoning.DecoratorΔNodePair","text":"A expectation circuit node that has pair of origins of type PC and type LC\n\n\n\n\n\n","category":"type"},{"location":"api/internals/reasoning/#ProbabilisticCircuits.Reasoning.exp_f-Tuple{ProbLiteral,Logistic⋁,LogicCircuits.Data.XData{Int8,M} where M<:(AbstractArray{#s14,2} where #s14<:Int8),Union{ProbabilisticCircuits.Reasoning.ExpectationCache, ProbabilisticCircuits.Reasoning.MomentCache}}","page":"Reasoning","title":"ProbabilisticCircuits.Reasoning.exp_f","text":"Has to be a Logistic⋁ with only one child, which is a leaf node \n\n\n\n\n\n","category":"method"},{"location":"api/internals/reasoning/#ProbabilisticCircuits.Reasoning.exp_fg-Tuple{ProbLiteral,Logistic⋁,LogicCircuits.Data.XData{Int8,M} where M<:(AbstractArray{#s14,2} where #s14<:Int8),ProbabilisticCircuits.Reasoning.ExpectationCache}","page":"Reasoning","title":"ProbabilisticCircuits.Reasoning.exp_fg","text":"Has to be a Logistic⋁ with only one child, which is a leaf node \n\n\n\n\n\n","category":"method"},{"location":"api/internals/reasoning/#ProbabilisticCircuits.Reasoning.moment_fg-Tuple{Prob⋁,Logistic⋁,LogicCircuits.Data.XData{Int8,M} where M<:(AbstractArray{#s14,2} where #s14<:Int8),Int64,ProbabilisticCircuits.Reasoning.MomentCache}","page":"Reasoning","title":"ProbabilisticCircuits.Reasoning.moment_fg","text":"Calculating  E[g^k * f]\n\n\n\n\n\n","category":"method"},{"location":"api/public/#Public-Documentation-1","page":"Public","title":"Public Documentation","text":"","category":"section"},{"location":"api/public/#","page":"Public","title":"Public","text":"Documentation for ProbabilisticCircuits.jl's public interface.","category":"page"},{"location":"api/public/#","page":"Public","title":"Public","text":"See the Internals section of the manual for internal package docs covering all submodules.","category":"page"},{"location":"api/public/#Contents-1","page":"Public","title":"Contents","text":"","category":"section"},{"location":"api/public/#","page":"Public","title":"Public","text":"Pages = [\"public.md\"]","category":"page"},{"location":"api/public/#Index-1","page":"Public","title":"Index","text":"","category":"section"},{"location":"api/public/#","page":"Public","title":"Public","text":"Pages = [\"public.md\"]","category":"page"},{"location":"api/public/#Public-Interface-1","page":"Public","title":"Public Interface","text":"","category":"section"},{"location":"api/public/#","page":"Public","title":"Public","text":"load_prob_circuit\nload_struct_prob_circuit","category":"page"},{"location":"api/public/#ProbabilisticCircuits.IO.load_prob_circuit","page":"Public","title":"ProbabilisticCircuits.IO.load_prob_circuit","text":"Load a probabilistic circuit from file. Support circuit file formats:\n\n\".psdd\" for PSDD files\n\n\n\n\n\n","category":"function"},{"location":"api/public/#ProbabilisticCircuits.IO.load_struct_prob_circuit","page":"Public","title":"ProbabilisticCircuits.IO.load_struct_prob_circuit","text":"Load a structured probabilistic circuit from file. Support circuit file formats:\n\n\".psdd\" for PSDD files\n\nSupported vtree file formats:\n\n\".vtree\" for VTree files\n\n\n\n\n\n","category":"function"}]
}
