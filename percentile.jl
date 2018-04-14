using DataFrames;
using CSV;
using PyPlot;
using ArgParse;

function input_data_rtt(parsed_args)
    iris = readtable(parsed_args["file1"], nrows=parsed_args["lines"],
     eltypes=[Float64], nastrings=["", "sendto:", "ERROR"])
    deleterows!(iris,find(isna(iris[1])))
    deleterows!(iris,find(x-> x > 10000000, iris[1]))
    iris2 = []
    if parsed_args["compare"] != nothing
        iris2 = readtable(parsed_args["compare"], nrows=parsed_args["lines"],
         eltypes=[Float64], nastrings=["", "sendto:", "ERROR"])
        deleterows!(iris2,find(isna(iris2[1])))
        deleterows!(iris2,find(x-> x > 10000000, iris2[1]))
    end
    println("returning from input_data_rtt")
    return iris, iris2
end

function input_data_nictonic(parsed_args)
    iris = readtable(parsed_args["file1"], nrows=parsed_args["lines"],
     eltypes=[Float64], nastrings=["", "sendto:", "-9223372036854775808", "Connection", "connecting:"])
    deleterows!(iris,find(isna(iris[1])))
    deleterows!(iris,find(x-> x > 10000000, iris[1]))
    deleterows!(iris,find(x-> x == 0.0, iris[1]))
    iris2 = []
    if parsed_args["compare"] != nothing
        iris2 = readtable(parsed_args["compare"], nrows=parsed_args["lines"],
         eltypes=[Float64], nastrings=["", "sendto:", "-9223372036854775808", "Connection", "connecting:"])
         deleterows!(iris2,find(isna(iris2[1])))
         deleterows!(iris2,find(x-> x > 10000000, iris2[1]))
         deleterows!(iris2,find(x-> x == 0.0, iris2[1]))
    end
    return iris, iris2
end

function print_statistics(input, input2)
    println("Input1 stats ============")
    println("average: ", mean(input[1]))
    println("99-percentile: ", percentile(input[1],99))
    println("99.9-percentile: ", percentile(input[1],99.9))
    println("99.99-percentile: ", percentile(input[1],99.99))
    println("max: ", maximum(input[1]))
    println("min: ", minimum(input[1]))
    if input2 != []
        println("Input2 stats ============")
        println("average: ", mean(input2[1]))
        println("99-percentile: ", percentile(input2[1],99))
        println("99.9-percentile: ", percentile(input2[1],99.9))
        println("99.99-percentile: ", percentile(input2[1],99.99))
        println("max: ", maximum(input2[1]))
        println("min: ", minimum(input2[1]))
    end
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

function plot_histogram(iris, dual=nothing)
    x, y = e_histogram(iris, 10)
    fig = figure("pyplot_histogram") # Not strictly required
    ax = axes() # Not strictly required
    # plt[:bar](x, y, color="red",align="center",linewidth=10.0) # Histogram
    # bar(x, y, color="red",align="center",linewidth=10.0) # Histogram
    plt[:stem](x, y) # Histogram
    grid("on")
    xlabel("Latency (us)")
    ylabel("Count")
    title("Latency Histogram")
    if dual != nothing
        x2, y2 = e_histogram(dual, 10)
        plt[:stem](x2, y2, linefmt="C1:", markerfmt="C1*") # Histogram
    end

    plt[:show]()
end

function plot_scatter(iris, dual=nothing)
    x = collect(1:length(iris))
    fig = figure("pyplot_histogram") # Not strictly required
    ax = axes() # Not strictly required
    # plt[:bar](x, y, color="red",align="center",linewidth=10.0) # Histogram
    # bar(x, y, color="red",align="center",linewidth=10.0) # Histogram
    plt[:scatter](x, iris, label="file 1") # Histogram
    grid("on")
    xlabel("ًReq #")
    ylabel("Latency (us)")
    title("Latency Scatter")
    if dual != nothing
        x2 = collect(1:length(dual))
        plt[:scatter](x2, dual, label="file 2") # Histogram
        plt[:legend]()
    end

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

function plot_ecdf(input, dual=nothing)
    x, y = calc_ecdf(input)
    fig = figure("pyplot_ECDF") # Not strictly required
    ax = axes() # Not strictly required
    # plt[:bar](x, y, color="red",align="center",linewidth=10.0) # Histogram
    # bar(x, y, color="red",align="center",linewidth=10.0) # Histogram
    plot(y, x, label="First file") # Histogram
    grid("on")
    xlabel("Latency (us)")
    ylabel("Percentile")
    title("ECDF")
    x2 = []
    y2 = []
    if dual != nothing
        x2, y2 = calc_ecdf(dual)
        plot(y2, x2, label="Second file")
        plt[:legend]()
    end
    savefig("test.png")
    plt[:show]()
end

function main(args)
    s = ArgParseSettings(description = "Data parsing utility")

    @add_arg_table s begin
        "--nictonic" , "-n"
            action = :store_true
        "--histogram"
            action = :store_true
        "file1"
            required = true
        "--start" , "-s"
            default = 1000
        "--lines" , "-l"
            default = 1000000
        "--compare", "-c"
        "--scatter"
            action = :store_true
    end

    parsed_args = parse_args(s)
    iris = []
    iris2 = []
    for (key,val) in parsed_args
        println("  $key  =>  $(repr(val))")
    end
    if parsed_args["nictonic"]
        iris, iris2 = input_data_nictonic(parsed_args)
    else
        iris, iris2 = input_data_rtt(parsed_args)
    end
    print_statistics(iris, iris2)
    #plotter(iris)
    if parsed_args["compare"] != nothing
        if parsed_args["histogram"]
            plot_histogram(iris[1], iris2[1])
            return
        elseif parsed_args["scatter"]
            plot_scatter(iris[1], iris2[1])
            return
        end
        plot_ecdf(iris[1], iris2[1])
    else
        if parsed_args["histogram"]
            plot_histogram(iris[1])
            return
        elseif parsed_args["scatter"]
            plot_scatter(iris[1])
            return
        end
        plot_ecdf(iris[1])
    end
end

main(ARGS)
