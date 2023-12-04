input = """seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4"""

# input = read("data/day05.txt", String)



struct SourceDest
    source::UnitRange{Int64}
    dest::UnitRange{Int64}
end

function parse_map(to_map)
    m = split(to_map, "\n")
    name = split(m[1], " ")[1]
    sources_dest = map(m[2:end]) do line
        source, dest, step = parse.(Int, split(line, " "))
        return SourceDest(dest:dest+step-1, source:source+step-1)
    end

    (name, sources_dest)
end

function parse_input(input)
    maps = Dict{String, Vector{SourceDest}}()
    parsed_input = split(input, "\n\n")
    seeds = first(parsed_input) |> x -> split(x, " ")[2:end] |> x -> map(x -> parse(Int, x), x)
    map(parse_map, parsed_input[2:end]) |> x -> map(y -> maps[y[1]] = y[2], x)
    (seeds, maps)
end

seeds, maps = parse_input(input)
maps = collect(maps)
maps = map(x -> split(x[1], "-to-") => x[2], maps)

function seed_to_loc(seed, maps)
    index = findfirst(x -> "seed" == x[1][1], maps)
    current_step, next_step = maps[index][1]
    val = seed
    while current_step != "location"
        ranges::Vector{SourceDest} = maps[index][2]
        seed_index = findfirst(x -> val in x.source, ranges)
        if seed_index !== nothing
            i = findfirst(==(val), ranges[seed_index].source)
            val = ranges[seed_index].dest[i]
        end


        current_step = next_step
        index = findfirst(x -> current_step == x[1][1], maps)
        if index === nothing
            return val
        end

        next_step = maps[index][1][2]
    end
end

seed_to_loc.(seeds, Ref(maps)) |> minimum |> println

# Part 2
seeds = [seeds[i]:seeds[i]+seeds[i+1]-1 for i in 1:2:length(seeds)-1]

rv = Inf
for seed_range in seeds
    rv = min(rv, seed_to_loc.(collect(seed_range, Ref(maps))) |> minimum)
end

println(rv)