export plot

using TikzGraphs

import TikzGraphs: plot
import Graphs: DiGraph

function plot(pc::ProbCircuit)

    nn = num_nodes(pc)
    g = DiGraph(nn)
    nodeid = label_nodes(pc)
    
    node_labels = Vector{String}(undef, nn)
    edge_labels = Dict()
    
    foreach(pc) do n
        nid = nodeid[n]
        node_labels[nid] = 
            if isinput(n) 
                "\$X_$(randvar(n)) \\sim $(latex(dist(n)))\$"
            elseif ismul(n) 
                "*"
            else 
                "+"
            end
        for i in 1:num_inputs(n)
            cid = nodeid[inputs(n, i)]
            add_edge!(g, nid, cid)
            if issum(n)
                p = round(exp(params(n,i)), digits=3)
                edge_labels[(nid, cid)] = "$p"
            end
        end
    end
    
    TikzGraphs.plot(g, node_labels; edge_labels, edge_style="font=\\tiny")
end