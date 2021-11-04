using Plots, Statistics, JLD
function BoundaryCondition(i,L)
    if i[2]==L
        i[2]=1
        return i
    elseif i[2]==1
        i[2]=L
        return i
    else
        return i
    end
end
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
        current_pos=BoundaryCondition(path[end],L)
        println(path)
        if current_pos[1]>(first_pos[1]+5) # if going out of the second boundary, neglect the particle
            return 0 #ZONE OUT
            break
        elseif current_pos[1]==1
            return current_pos
            break
        elseif length(findall(x->x ∉ -3:0,vcat(arr[current_pos[1]-1:2:current_pos[1]+1,current_pos[2]],
                        arr[current_pos[1],current_pos[2]-1:2:current_pos[2]+1]...)))>0
            arr[current_pos[1], current_pos[2]]-=1
             return current_pos #SUSCCESSFUL COLLISION, returning the final_destination
             break
        end
    end
end

direction_list=[[0,1],[0,-1],[1,0],[-1,0]]
L=20
arr=zeros((L,L))
N=10
color=1
for particle in 1:N
    println("particle:", particle)
    peak=height_cal(arr)
    f_d=RandomWalk(arr, L, direction_list,[peak+3, rand(1:L)])
    println("the final position:", f_d)
    if arr[f_d[1],f_d[2]]==-3
        arr[f_d[1],f_d[2]]=color
    end
    if particle%(10*200*color)==0
        color+=1
    end
end
