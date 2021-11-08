using Plots, Statistics, JLD, LaTeXStrings
function Boundary(i,L)
    if i[2]>L
        return i[i[1],i[2]-L]
    elseif i[2]<1
        return i[i[1],L+i[2]]
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

function Collision(Network_, L, Pos)
end

function RandomWalk(Network_, L, FirstPos, DirectionList, seperation)
    NextPos=First_pos
    while true
        CurrentPos .+=rand(DirectionList)
        CurrentPos=Boundary(NextPos,L)
        if CurrentPos[1]> (FirstPos[1]+seperation)
            return 0
        elseif CurrentPos[1]==1
            return CurrentPos
        elseif Collision(Network_, L, CurrentPos)==true
            return CurrentPos
        else
            continue
        end
    end
end
