module ParetoFront

export update_pareto!,  get_pareto

# We have two n-vectors x and y.  min_idxs is a vector of indices at which
# x[i] < y[i], if x is to dominate y. Likewise, max_idxs is a vector of
# indices at which x[i] > y[i], if x is to dominate y
function domvals(x, y, min_idxs, max_idxs)
    n_better = 0
    n_worse  = 0

    for i in min_idxs
        n_better += x[i] < y[i]
        n_worse  += x[i] > y[i]
    end
    
    for i in max_idxs
        n_better += x[i] > y[i]
        n_worse  += x[i] < y[i]
    end
    
    return n_better, n_worse
end


# Conditionally update the pareto set (a set of n-vectors) with a new candidate
# vector x. The vector min_idxs contains the indices of the vector x whose
# values we want to find the minimum and analogously for the vector max_idxs.
# Note that if an index does not appear in either min_idxs or max_idxs, it will
# not be used in calculating the Pareto front
function update_pareto!(pareto, x, min_idxs, max_idxs)
    remove_pts = Set()
    for p in pareto
        n_better, n_worse = domvals(x, p, min_idxs, max_idxs)

        # Current candidate is dominated by point j in pareto so ignore it
        # To avoid including duplicate points, change "n_worse > 0" to "n_worse >= 0"
        n_worse > 0 && n_better == 0 && return pareto

        # Current candidate dominates point p in pareto, so remove p from pareto
        n_better > 0 && n_worse == 0 && push!(remove_pts, p)
    end
        
    setdiff!(pareto, remove_pts)
    push!(pareto, x)
    return pareto
end


# Use get_pareto when you already have a matrix (whose rows are points)
# out of which you want to extract the Pareto front
function get_pareto(V::Matrix{T}; min_idxs, max_idxs) where {T}
    pareto = Set{Vector{T}}()
    @inbounds for x in eachrow(V)
        update_pareto!(pareto, x, min_idxs, max_idxs)
    end
    return pareto
end

end
