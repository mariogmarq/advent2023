input = read("data/day10.txt", String)


function parse_input(input)
    input = split(input, "\n")
    collect.(input) |> x -> hcat(x...) |> permutedims
end

const Directions = Dict(
    '|' => ((-1, 0), (1, 0)),
    '-' => ((0, -1), (0, 1)),
    'L' => ((-1, 0), (0, 1)),
    'J' => ((-1, 0), (0, -1)),
    '7' => ((1, 0), (0, -1)),
    'F' => ((1, 0), (0, 1)),
    '.' => ((0, 0), (0, 0)),
)

const PosibleDirections = [(0, 1), (0, -1), (1, 0), (-1, 0)]

function path_follows(grid::Matrix{Char}, pos::Tuple{Int, Int}, neighbour::Tuple{Int, Int})
    if grid[neighbour...] == 'S'
        return true, (2, 0) # Final reached
    end

    direction = pos .- neighbour
    if direction in Directions[grid[neighbour...]]
        return true, Directions[grid[neighbour...]][findfirst(==(direction), Directions[grid[neighbour...]])]
    end

    return false, (0, 0)
end

function travel_loop(grid::Matrix{Char})
    first_pos = findfirst(==('S'), grid)
    first_pos = (first_pos[1], first_pos[2])

    current_pos = first_pos
    positions_traveled = []
    current_dir = (0, 0)
    
    # Find first neighbour
    for dir in PosibleDirections
        follows, dir = path_follows(grid, current_pos, current_pos .+ dir)
        if follows
            current_pos = current_pos .- dir
            current_dir = dir
            push!(positions_traveled, (current_pos, (-dir[1], -dir[2])))
            break
        end
    end

    while grid[current_pos...] != 'S'
        dir_to_follow = Directions[grid[current_pos...]][findfirst(!=(current_dir), Directions[grid[current_pos...]])]
        follows, dir = path_follows(grid, current_pos, current_pos .+ dir_to_follow)
        if !follows
            throw(ErrorException("Error"))
        end

        if dir == (2, 0) 
            break
        end

        current_pos = current_pos .- dir
        current_dir = dir
        push!(positions_traveled, (current_pos, (-dir[1], -dir[2])))
    end

    return positions_traveled
end
    

m = parse_input(input)
positions_traveled = travel_loop(m)
(length(positions_traveled) + 1) / 2 |> println

# Part 2
m
positions = [x[1] for x in positions_traveled]
dirs = [x[2] for x in positions_traveled]

area = [ dir[2]*pos[1] for (dir, pos) in zip(dirs, positions)] |> sum |> abs
area - div(length(positions_traveled) + 1, 2) - 1 |> println