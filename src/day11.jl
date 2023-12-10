input = read("data/day11.txt", String)

function parse_input(input)
    # To Matrix{Char}
    base = split(input, '\n') .|> collect
    m = base |> x -> permutedims(hcat(x...))
    
    # Rows with no galaxies
    rows = [i for (i, x) in enumerate(eachrow(m)) if all(x .== '.')]
    cols = [i for (i, x) in enumerate(eachcol(m)) if all(x .== '.')]


    for (i, row) in enumerate(rows)
        row_l = length(base[1])
        insert!(base, row, ['.' for _ in 1:row_l])
        rows[i:end] .+= 1
    end

    for row in base
        copy_cols = copy(cols)
        for col in copy_cols
            insert!(row, col, '.')
            copy_cols .+= 1
        end
    end

    permutedims(hcat(base...))
end

function part1(parsed_input)
    galaxies = findall(x -> x == '#', parsed_input) 
    total = 0
    for (i, galaxy) in enumerate(galaxies)
        distances = galaxies[i:end] .- Ref(galaxy)
        distances = map(x -> [x[1], x[2]], distances) .|> x -> map(abs, x) |> x -> map(sum, x)
        distances = distances .|> sum
        total += sum(distances)
    end

    total
end

parse_input(input) |> part1

# Part 2

function part_2(input)
    # To Matrix{Char}
    base = split(input, '\n') .|> collect
    m = base |> x -> permutedims(hcat(x...))
    
    # Rows with no galaxies
    rows = [i for (i, x) in enumerate(eachrow(m)) if all(x .== '.')]
    cols = [i for (i, x) in enumerate(eachcol(m)) if all(x .== '.')]

    galaxies = findall(x -> x == '#', m) 
    total = 0
    for (i, galaxy) in enumerate(galaxies)
        distances = galaxies[i:end] .- Ref(galaxy)
        distances = map(x -> [x[1], x[2]], distances) .|> x -> map(abs, x) |> x -> map(sum, x)
        distances_sum = distances .|> sum

        for (j, pos) in enumerate(galaxies[i:end])
            if galaxy[1] != pos[1]
                x_range = galaxy[1]:sign(pos[1] - galaxy[1]):pos[1]
                distances_sum[j] += length(intersect(x_range, rows)) * 999_999
            end

            if galaxy[2] != pos[2]
                y_range = galaxy[2]:sign(pos[2] - galaxy[2]):pos[2]
                distances_sum[j] += length(intersect(y_range, cols)) * 999_999
            end
        end
        
        total += sum(distances_sum)
    end

    total
end

part_2(input)