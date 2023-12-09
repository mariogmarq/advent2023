input = read("data/day09.txt", String)

parse_input(input) = [parse.(Int, split(x, " ")) for x in split(input, "\n")]


function part1(steps) 
    d = [copy(steps)]
    while !all(d[end] .== 0)
        push!(d, diff(d[end]))
    end

    push!(d[end], 0)

    for i in reverse(1:length(d)-1)
        current, prev = d[i][end], d[i+1][end]
        push!(d[i], current + prev)
    end

    d[1][end]
end

parse_input(input) |> x -> part1.(x) |> sum |> println


# Too lazy to refactor for common code
function part2(steps) 
    d = [copy(steps)]
    while !all(d[end] .== 0)
        push!(d, diff(d[end]))
    end

    pushfirst!(d[end], 0)

    for i in reverse(1:length(d)-1)
        current, prev = d[i][begin], d[i+1][begin]
        pushfirst!(d[i], current - prev)
    end

    d[1][begin]
end

parse_input(input) |> x -> part2.(x) |> sum |> println
