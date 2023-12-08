using Base.Iterators

input = read("data/day08.txt", String)

function parse_input(input)
    instructions, node_list = split(input, "\n\n")
    node_list = split(node_list, "\n")
    nodes = Dict()
    
    for node in node_list
        value, pair = split(node, " = ")
        pair = split(pair[begin+1:end-1], ", ")
        nodes[value] = pair
    end

    (instructions, nodes)
end

function get_to_end(instructions, nodes, initial_value="AAA", is_final_value=x -> x == "ZZZ")
    direction_to_index = Dict('R' => 2, 'L' => 1)
    current_value = initial_value

    for (i, v) in enumerate(cycle(instructions))
        if is_final_value(current_value) && i != 1
            return i - 1, current_value
        end

        current_value = nodes[current_value][direction_to_index[v]]
    end  
end

get_to_end(parse_input(input)...) |> println


# Part 2
function get_steps(instructions, nodes)
    initial_positions = keys(nodes) |> x -> filter(x -> x[3]=='A', x) |> collect
    is_final = x -> x[3] == 'Z'
    distances_start_to_final = Dict(pos => get_to_end(instructions, nodes, pos, is_final)[1] for pos in initial_positions)
    distances_start_to_final |> values |> x->lcm(x...)
end

get_steps(parse_input(input)...)