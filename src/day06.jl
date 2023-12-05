input = read("data/day06.txt", String)

function parse_input(input)
    lines = split(input, '\n')
    times = split(lines[1], ' ')[2:end] |> x -> filter(x -> x != "", x) |> x -> parse.(Int, x)
    distances = split(lines[2], ' ')[2:end] |> x -> filter(x -> x != "", x) |> x -> parse.(Int, x)

    return zip(times, distances)
end

function solvequadratic(a, b, c)
    d = sqrt(b^2 - 4a*c)
    (-b - d) / 2a, (-b + d) / 2a
end

function get_number_of_winning_combinations((time, distance))
    # In time - 1 we travel (time - 1) distance
    # In time - 2 we travel (time - 2) * 2 distance
    # In time - 3 we travel (time - 3) * 3 distance
    # In time - n we travel (time - n) * n = n*time - n^2 distance
    # We want to find n such that n*time - n^2 > distance iff n^2 - n*time + distance <= 0
    lowersol, uppersol = solvequadratic(1, -time, distance)
    # Reorder the interval
    lowersol, uppersol = min(lowersol, uppersol), max(lowersol, uppersol)

    # Round the interval
    lowersol_int, uppersol_int = ceil(lowersol |> nextfloat), floor(uppersol |> prevfloat)

    length_of_interval = length(lowersol_int:uppersol_int)
    
    length_of_interval
end

get_number_of_winning_combinations.(parse_input(input)) |> x -> reduce(*, x) |> println

# Part 2
function parse_input_part2(input)
    lines = split(input, '\n')
    time = split(lines[1], ' ')[2:end] |> x -> filter(x -> x != "", x) |> x-> reduce(*, x) |> x -> parse(Int, x)
    distance = split(lines[2], ' ')[2:end] |> x -> filter(x -> x != "", x) |> x-> reduce(*, x) |> x -> parse(Int, x)

    return time, distance
end

get_number_of_winning_combinations(parse_input_part2(input)) |> println