input = """Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"""

input = split(input, "\n")

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
    new_input = collect(enumerate(input))
    count = 0
    for (index, (winning, actual)) in new_input
        count += 1
        ammount_of_winning = sum(actual .∈ Ref(winning))
        if ammount_of_winning > 0
            push!.(Ref(new_input), new_input[index+1:index+ammount_of_winning])
        end
    end
    count
end

part2(input) |> println