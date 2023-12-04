input = readlines("data/day04.txt")

function parse_line(line)
    line = split(line, ": ")[2]
    winning, actual = split(line, " | ")
    winning = parse.(Int, split(winning))
    actual = parse.(Int, split(actual))

    (winning, actual)
end



function count_points(parsed_line)
    winning, actual = parsed_line

    number_of_matches = sum(actual .∈ Ref(winning))
    if number_of_matches == 0
        return 0
    end

    2^(number_of_matches - 1)
end

input = parse_line.(input)
count_points.(input) |> sum |> println

# Part 2
function part2(input)
    new_input = map(x -> sum(x[2] .∈ Ref(x[1])), input) |> enumerate |> collect
    count = 0
    for (index, ammount_of_winning) in new_input
        count += 1
        if ammount_of_winning > 0
            push!.(Ref(new_input), new_input[index+1:index+ammount_of_winning])
        end
    end
    count
end

part2(input) |> println