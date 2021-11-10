using Plots, Statistics, JLD, LaTeXStrings
function Boundary(i,L)
    if i>L
        return i-L
    elseif i<1
        return L+i
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

function RandomWalk(Network_, L, FirstPos, seperation, DirectionList)
    CurrentPos=FirstPos
    #println("firstPos:", FirstPos)
    while true
        CurrentPos .+=rand(DirectionList)
        CurrentPos[2]=Boundary(CurrentPos[2],L)
        #println("currentpos:",CurrentPos)
        if CurrentPos[1]>L
            return Network_, -4
        elseif CurrentPos[1]> (FirstPos[1]+seperation)
            return Network_, 0
        elseif CurrentPos[1]==1
            Network_[CurrentPos[1],CurrentPos[2]]-=1
            return Network_, CurrentPos
        elseif CurrentPos[1]==L
            if length(findall(x->x ∉ -2:0,vcat(Network_[CurrentPos[1]-1,CurrentPos[2]],
                                Network_[CurrentPos[1], Boundary(CurrentPos[2]-1,L):2:Boundary(CurrentPos[2]+1,L)]...)))>0
                Network_[CurrentPos[1],CurrentPos[2]]-=1
                return Network_, CurrentPos
            else
                return Network_, 0
            end
        elseif length(findall(x->x>0,
                        vcat(Network_[CurrentPos[1]-1:2:CurrentPos[1]+1,CurrentPos[2]],
                                Network_[CurrentPos[1], Boundary(CurrentPos[2]-1,L):2:Boundary(CurrentPos[2]+1,L)]...)))>0
                Network_[CurrentPos[1],CurrentPos[2]]-=1
            return Network_,CurrentPos
        else
            continue
        end
    end
end
direction_list=[[0,1],[0,-1],[1,0],[-1,0]]
L=50
Network_=zeros(Int,L,L)
N=3000
color=1
separation=5
for particle in 1:N
    #println("particle:", particle)
    peak=height_cal(Network_)
    Network_,FinalPos=RandomWalk(Network_, L, [peak+3, rand(1:L)], separation, direction_list)
    #println("the final position:", f_d)
    if FinalPos==-4
        break
    elseif FinalPos==0
        continue
    elseif Network_[FinalPos[1],FinalPos[2]]==-3
        Network_[FinalPos[1],FinalPos[2]]=color
    end
    if particle%(10*20*color)==0
        color+=1
    end
end
Network_[findall(x->x<0, Network_)].=0
Network_
p1=heatmap(Network_)
p2=heatmap(Network_)
