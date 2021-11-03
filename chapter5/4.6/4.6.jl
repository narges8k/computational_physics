using Plots, Statistics, JLD
function height_cal(arr)
    h=[]
    for col in eachcol(arr)
        height=0
        for element in col
            if element!=0
                height+=1
            end
        end
        push!(h, height)
    end
    return maximum(h)
end

function RandomWalk(arr, L, direction_list,first_pos)
    number_of_steps=rand()
    direction_choosing=[first_pos]
    path=[first_pos]
    while true
        push!(direction_choosing, rand(direction_list))
        path=cumsum(direction_choosing,dims=1)
        if path[end][1]>first_pos+5 # if going out of the second boundary, neglect the particle
            return 0 #ZONE OUT
            break
        elseif length(findall(x->x ∉ -3:0, arr[path[end][1]-1:2:path[end][1]+1, path[end][2]-1:2:path[end][2]+1]))>0
            path[end]-=1
            return path[end] #SUSCCESSFUL COLLISION, returning the current position
            break
        end
    end
end

direction_list=[[0,1],[0,-1],[1,0],[-1,0],[-1,1],[1,-1],[1,1],[-1,-1]]
