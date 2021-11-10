using ProgressBars,Plots, Statistics, JLD, LaTeXStrings
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

function RandomWalk(Network_, L, FirstPos, t_limit, DirectionList)
    CurrentPos=FirstPos
    #println("firstPos:", FirstPos)
    while true
        temp=CurrentPos .+ rand(DirectionList)
        temp= [temp[1],Boundary(temp[2],L)]
        if Network_[temp...]<=0
            CurrentPos=temp
            if CurrentPos[1]==1
                Network_[CurrentPos...]-=1
                return Network_, CurrentPos
            elseif CurrentPos[1]> t_limit
                return Network_, 0
            elseif length(findall(x->x>0,vcat(Network_[CurrentPos[1]-1:2:CurrentPos[1]+1,CurrentPos[2]],
                            Network_[CurrentPos[1], Boundary(CurrentPos[2]-1,L):2:Boundary(CurrentPos[2]+1,L)]...)))>0
                    Network_[CurrentPos...]-=1
                return Network_,CurrentPos
            else
                continue
            end
        else
            return Network_,CurrentPos
        end
    end
end
direction_list=[[0,1],[0,-1],[1,0],[-1,0]]
L=200
Network_=zeros(Int,L,L)
N=80000
color=1
seperation=5
for particle in ProgressBar(1:N)
    b_limit=height_cal(Network_) + 3
    t_limit= b_limit+seperation
    if t_limit<L
        Network_,FinalPos=RandomWalk(Network_, L, [b_limit, rand(1:L)], t_limit, direction_list)
        if FinalPos==0
            continue
        elseif Network_[FinalPos...]==-3
            Network_[FinalPos...]=color
        end
        if particle%(10*L*color)==0
            color+=1
        end
    else
        break
    end
end
Network_[findall(x->x<0, Network_)].=0
heatmap(Network_, dpi=400)
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter5\\4.6\\Figs\\4.6_strange.png")
