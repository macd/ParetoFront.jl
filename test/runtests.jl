using ParetoFront
using Test


# Suppose we are in two dimensions and want min, min to dominate.
# We know then, that the point that has a minimum value of y will dominate
# all points to the right of it, ie  at x > x(at ymin) will be dominated
# and so for all x on the Pareto front we must have x < x(at ymin)
# and also the point with the minimum value of x will dominate all 
# points that are above it, ie that y > y(at xmin) will be dominated
# and so for all y on the Pareto front we must have y < y(at xmin)
function test_min_blob(n)
    v = randn(n, 2)
    ((xmin, ymin), (ix, iy)) = findmin(v, dims=1)
    ymax = v[ix[1], 2]
    xmax = v[iy[1], 1]
    pareto = get_pareto(v, min_idxs=[1,2], max_idxs=[])
    front = Matrix(reduce(hcat, collect(pareto))')
    pxmax, pymax = maximum(front, dims=1)
    return pxmax <= xmax && pymax <= ymax
end

# the test for max, max as optimal
function test_max_blob(n)
    v = randn(n, 2)
    ((xmax, ymax), (ix, iy)) = findmax(v, dims=1)
    ymin = v[ix[1], 2]
    xmin = v[iy[1], 1]
    pareto = get_pareto(v, min_idxs=[], max_idxs=[1,2])
    front = Matrix(reduce(hcat, collect(pareto))')
    pxmin, pymin = minimum(front, dims=1)
    return pxmin >= xmin && pymin >= ymin
end


@testset "ParetoFront.jl" begin
    for i in 10 .^ (1:6)
        @test test_min_blob(i)
        @test test_max_blob(i)
    end
end

