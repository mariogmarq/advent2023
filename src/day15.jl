function my_hash(s::AbstractString)
    current_value = 0
    
    for c in s
        current_value += Int(c)
        current_value *= 17
        current_value = rem(current_value, 256)
    end

    return current_value
end

input = read("data/day15.txt", String)

split(input, ',') .|> my_hash |> sum |> println

# part 2
boxes = Dict(i => [] for i in 0:255)
function run_instruction!(boxes::Dict, ins)
    box = my_hash(ins)

    if '=' in ins
        ins = split(ins, '=')
        lens = ins[1]
        value = parse(Int, ins[2])
        box = my_hash(lens)
        content = boxes[box]
        pos = findfirst(x -> x[1] == lens, content)
        if pos !== nothing
            boxes[box][pos][2] = value
        else
            push!(boxes[box], [lens, value])
        end
    else
        ins = split(ins, '-')[1]
        box = my_hash(ins)
        content = boxes[box]
        pos = findfirst(x -> x[1] == ins, content)
        if pos !== nothing
            boxes[box] = deleteat!(content, pos)
        end
    end
end

for ins in split(input, ',')
    run_instruction!(boxes, ins)
end

aux = 0 
for (k, v) in boxes
    for (i, l) in enumerate(v)
        aux += (k+1) * i * l[2]
    end
end

aux