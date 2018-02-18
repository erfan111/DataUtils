using DataFrames;

function input_data()
    iris = readtable("final_normal.txt", nrows=10000, eltypes=[Float64], nastrings=["", "sendto:"])
    deleterows!(iris,find(isna(iris[1])))
    deleterows!(iris,find(x-> x > 10000000, iris[1]))
    return iris
end

function calc_ecdf(input, xmax, xmin, steps)
    stepsize=(xmax-xmin)/(steps)
    xpoints = []
    #println(xpoints, " ", div(xmin,stepsize), " ", div(xmax,stepsize))
    for i in range(convert(Int32, div(xmin,stepsize)),convert(Int32, div(xmax, stepsize)))
        push!(xpoints, i*stepsize)
    end
    #println(xpoints, " ", div(xmin,stepsize), " ", div(xmax,stepsize))
    ypoints = []
    ypoints=map(x-> exp(-x),xpoints)

    ans=[0]
    for i in range(1,length(ypoints)-1)
        push!(ans, ans[i]+(ypoints[i]+ypoints[i+1])/2.0*stepsize)
    end
    return ans
end

iris = input_data()
ans = calc_ecdf(iris[1], maximum(iris[1]), minimum(iris[1]), 1000)
