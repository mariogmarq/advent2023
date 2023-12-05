using DataStructures

input = read("data/day07.txt", String)

function parse_input(input)
    lines = split(input, '\n')
    lines = map(line -> split(line, ' '), lines)
    return map(line -> (line[1], parse(Int, line[2])), lines)
end

function gethandtype(a)
    c = counter(collect(a))
    letters = keys(c)
    ocurrences = values(c)
    if length(letters) == 1
        return 7 # Five of a kind
    end 
    if length(letters) == 2
        if 4 in ocurrences
            return 6 # Four of a kind
        else
            return 5 # Full house
        end
    end
    if length(letters) == 3
        if 3 in ocurrences
            return 4 # Three of a kind
        else
            return 3 # Two pairs
        end
    end
    if length(letters) == 4
        return 2 # One pair
    end
    return 1 # High card
end

letter_order = "23456789TJQKA"

function compare_cards(a, b) # works as is less
    for (f, l) in zip(a, b)
        if f == l
            continue
        end

        return findfirst(==(f), letter_order) < findfirst(==(l), letter_order)
    end
end

function handissmaller((a, _), (b, _); handtype=gethandtype)
    handtype_a = handtype(a)
    handtype_b = handtype(b)
    if handtype_a != handtype_b
        return handtype_a < handtype_b
    end
    return compare_cards(a, b)
end

input = parse_input(input)
sorted = sort(input, lt=handissmaller)
enumerate(sorted) |> x -> map(y -> y[1] * y[2][2], x) |> sum |> println

# Part 2
letter_order = "J23456789TQKA"

function new_gethandtype(a)
    c = counter(collect(a))
    letters = keys(c) |> collect
    ocurrences = values(c) |> collect

    if !('J' in letters)
        return gethandtype(a)
    end

    number_of_jacks = c['J']

    if number_of_jacks == 5 
        return 7 # Five of a kind
    end

    sorted = sort(zip(letters, ocurrences) |> collect, lt=(a, b) -> a[2] > b[2])
    highest_non_jack = findfirst(x -> x[1] != 'J', sorted) |> x -> sorted[x]

    replace(a, 'J' => highest_non_jack[1]) |> gethandtype
end

sorted = sort(input, lt=(a, b) -> handissmaller(a, b, handtype=new_gethandtype))
enumerate(sorted) |> x -> map(y -> y[1] * y[2][2], x) |> sum |> println