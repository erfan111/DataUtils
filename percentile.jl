using DataFrames;
using CSV;
using PyPlot;

function input_data()
    iris = readtable("final_normal.txt", nrows=1000000, eltypes=[Float64], nastrings=["", "sendto:"])
    deleterows!(iris,find(isna(iris[1])))
    deleterows!(iris,find(x-> x > 10000000, iris[1]))
    return iris
end

function print_statistics(input)
    println("average: ", mean(input[1]))
    println("99-percentile: ", percentile(input[1],99))
    println("99.9-percentile: ", percentile(input[1],99.9))
    println("99.99-percentile: ", percentile(input[1],99.99))
    println("max: ", maximum(input[1]))
    println("min: ", minimum(input[1]))
end

function e_histogram(input, bins)
    max = maximum(input)
    min = minimum(input)
    step = (max-min)/bins
    x = collect(min:step:max)
    y = Array{Int64}(bins+1)
    sort!(input)
    temp = min
    println("max min \n", max , " - ", min)
    for i in y
        i = 0
    end

    for i in input
        aa = floor(Int, div(i, step))+1
        y[aa]+=1
    end
    return x, y
end

function plot_histogram(iris)
    x, y = e_histogram(iris[1], 10)
    fig = figure("pyplot_histogram") # Not strictly required
    ax = axes() # Not strictly required
    # plt[:bar](x, y, color="red",align="center",linewidth=10.0) # Histogram
    # bar(x, y, color="red",align="center",linewidth=10.0) # Histogram
    plot(x, y) # Histogram
    grid("on")
    xlabel("X")
    ylabel("Y")
    title("Histogram")
    plt[:show]()
end

function input_data()
    iris = readtable("final_normal.txt", nrows=10000, eltypes=[Float64], nastrings=["", "sendto:"])
    deleterows!(iris,find(isna(iris[1])))
    deleterows!(iris,find(x-> x > 10000000, iris[1]))
    return iris
end

function calc_ecdf(input)
    sort!(input)
    size = length(input)
    step = size/100
    xpoints = collect(1.0:99.0)
    append!(xpoints, collect(99.1:0.1:99.9))
    append!(xpoints, collect(99.91:0.01:99.99))
    append!(xpoints, collect(99.991:0.001:99.999))
    println(xpoints)
    ypoints = []
    for i in xpoints
        aaaa = convert(Int64, floor(i * step))
        if(aaaa < size)
            push!(ypoints, input[aaaa])
        end
    end
    println("ecdf done")
    return xpoints, ypoints
end

function plot_ecdf(input)
    x, y = calc_ecdf(input)
    fig = figure("pyplot_histogram") # Not strictly required
    ax = axes() # Not strictly required
    # plt[:bar](x, y, color="red",align="center",linewidth=10.0) # Histogram
    # bar(x, y, color="red",align="center",linewidth=10.0) # Histogram
    plot(y, x) # Histogram
    grid("on")
    xlabel("Latency (us)")
    ylabel("Percentile")
    title("ECDF")
    plt[:show]()
end

function main()
    iris = input_data()
    print_statistics(iris)
    #plotter(iris)
    plot_ecdf(iris[1])

end

main()
