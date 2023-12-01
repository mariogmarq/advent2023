input = readlines("data/day02.txt")

# Part 1
in_bag = Dict{String, Int}("red" => 12, "green" => 13, "blue" => 14)

struct Game
    id
    sets
end

function parse_line(line)
    id, sets = split(line, ": ")
    id = parse(Int, split(id, " ")[2])

    sets = split(sets, "; ")

    Game(id, sets)
end

function part_1(game::Game)
    # Returns the id of the game if the bag is valid, 0 otherwise
    for set in game.sets
        cubes = split(set, ", ")
        for cube in cubes
            count, color = split(cube, " ")
            count = parse(Int, count)
            if in_bag[color] < count
                return 0
            end
        end
    end

    return game.id
end

parse_line.(input) |> x -> part_1.(x) |> sum |> println

# Part 2
function part_2(game::Game)
    red, blue, green = 0, 0, 0

    for set in game.sets
        cubes = split(set, ", ")
        for cube in cubes
            count, color = split(cube, " ")
            count = parse(Int, count)
            if color == "red"
                red = max(red, count)
            elseif color == "blue"
                blue = max(blue, count)
            else
                green = max(green, count)
            end
        end
    end

    return red * green * blue
end

parse_line.(input) |> x -> part_2.(x) |> sum |> println