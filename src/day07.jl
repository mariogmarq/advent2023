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

letter_order = Dict('A' => 5, 'T' => 1, 'J' => 2, 'Q' => 3, 'K' => 4)

function compare_cards(a, b) # works as is less
    for (f, l) in zip(a, b)
        if f == l
            continue
        end

        if isdigit(f) && isdigit(l)
            return f < l           
        end

        if isdigit(f)
            return true
        end

        if isdigit(l)
            return false
        end

        return letter_order[f] < letter_order[l]
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
letter_order = Dict('A' => 5, 'T' => 2, 'Q' => 3, 'K' => 4)

function compare_cards(a, b) # works as is less
    for (f, l) in zip(a, b)
        if f == l
            continue
        end

        if f == 'J'
            return true
        end

        if l == 'J'
            return false
        end

        if isdigit(f) && isdigit(l)
            return f < l           
        end

        if isdigit(f)
            return true
        end

        if isdigit(l)
            return false
        end

        return letter_order[f] < letter_order[l]
    end
end
function new_gethandtype(a)
    c = counter(collect(a))
    letters = keys(c)
    ocurrences = values(c)
    if !('J' in letters)
        return gethandtype(a)
    end
    
    number_of_jacks = c['J']

    if number_of_jacks == 5 || number_of_jacks == 4
        return 7 # Five of a kind
    end

    if number_of_jacks == 3
        if 2 in ocurrences
            return 7 # Five of a kind
        else
            return 6 # Four of a kind
        end
    end

    if number_of_jacks == 2
        if 3 in ocurrences
            return 7 # Five of a kind
        elseif count(==(2), ocurrences) == 2
            return 6 # Four of a kind
        else
            return 5 # Three of a kind
        end
    end

    if 4 in ocurrences
        return 7
    end
    if 3 in ocurrences
        return 6
    end
    if 2 in ocurrences
        return 5
    end
    return 2
end

sorted = sort(input, lt=(a, b) -> handissmaller(a, b, handtype=new_gethandtype))
enumerate(sorted) |> x -> map(y -> y[1] * y[2][2], x) |> sum |> println