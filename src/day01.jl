input = readlines("data/day01.txt")

# Part 1
filter.(isdigit, input) |> x-> map(y -> y[begin] * y[end], x) |> x -> parse.(Int, x) |> sum|> println

# Part 2
valid_digits = Dict( 1=> "one", 2=> "two", 3=> "three", 4=> "four", 5=> "five", 6=> "six", 7=> "seven", 8=> "eight", 9=> "nine")

new_input = map(input) do line
    mutable_line = collect(line) # To vector{char} for setindex
    for item in valid_digits
        occurrences = findall(item[2], line)
        for range in occurrences
            f, l = first(range), last(range)
            mutable_line[f+1:l-1] .= string(item[1])[1] # Replace middle chars with number
        end
    end
    reduce(*, mutable_line) # Back to string again
end |> x -> filter.(isdigit, x) |> x-> map(y -> y[begin] * y[end], x) |> x -> parse.(Int, x) |> sum |> println