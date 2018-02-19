using ArgParse;


function main(args)

    # initialize the settings (the description is for the help screen)
    s = ArgParseSettings(description = "Example 1 for argparse.jl: minimal usage.")

    @add_arg_table s begin
        "--nictonic" , "-n"
            action = :store_true
        "arg1"
            required = true
        "--start" , "-s"
            default = 1000
        "--lines" , "-l"
            default = 1000000
        "--compare", "-c"
            default = false
    end

    parsed_args = parse_args(s) # the result is a Dict{String,Any}
    println("Parsed args:")
    for (key,val) in parsed_args
        println("  $key  =>  $(repr(val))")
    end
    if parsed_args["compare"]
        println("nothing")
    end
end

main(ARGS)
