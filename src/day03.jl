input = readlines("data/day03.txt")

# Turn input into Matrix{Char}
input = collect.(input)
input = permutedims(hcat(input...))

# Find coordinates of all symbols
symbols = findall(x -> x != '.' && !isdigit(x), input)

function find_adjacent(index::CartesianIndex{2}, input::Matrix{Char})
    # Looks for digits adjacent to the given index
    directions = [(0, 1), (1, 0), (0, -1), (-1, 0), (1, 1), (-1, -1), (1, -1), (-1, 1)]

    sols = Set()

    for direction in directions
        new_pos = (index[1] + direction[1], index[2] + direction[2])
        x, y = new_pos
        # Bound check
        if x < 1 || y < 1 || x > size(input, 1) || y > size(input, 2)
            continue
        end

        if isdigit(input[x, y])
            push!(sols, new_pos)
        end
    end

    sols
end

function complete_number(index::Tuple, input::Matrix{Char})
    # Given an index of a digit, find the whole number and return the number and index of the first digit
    sol = [input[index...]]
    x, y = index[1], index[2]
    while y < size(input, 2) && isdigit(input[x, y + 1])
        push!(sol, input[x, y + 1])
        y += 1
    end
    
    y = index[2]
    
    while y > 1 && isdigit(input[x, y - 1])
        pushfirst!(sol, input[x, y - 1])
        y -= 1
    end

    ((x, y + 1), reduce(*, sol) |> x -> parse(Int, x))
end

find_adjacent.(symbols, Ref(input)) |> x -> reduce(union, x) |> x -> complete_number.(x, Ref(input)) |> unique |> x -> map(y -> y[2], x) |> sum |> println

# Part 2
gears = findall(x -> x == '*', input)

find_adjacent.(gears, Ref(input)) |> x -> map(y -> complete_number.(y, Ref(input)), x) |> x -> unique.(x)|>
    x -> map.(y -> y[2], x) |> x -> filter(y -> length(y) == 2, x) |>
    x -> map(y -> y[1] * y[2], x) |> sum |>
    println