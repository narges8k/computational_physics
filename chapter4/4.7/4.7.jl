using Plots, LaTeXStrings,JLD
function neighbor_checking(network_,dim,i,j)
    neighbors_list=[]
    if i+1!=dim+1
        push!(neighbors_list,network_[i+1,j])
    end
    if i-1!=0
        push!(neighbors_list,network_[i-1,j])
    end
    if j+1!=dim+1
        push!(neighbors_list,network_[i,j+1])
    end
    if j-1!=0
        push!(neighbors_list, network_[i,j-1])
    end
    return neighbors_list
end
function on_or_blocked(network_,dim,i,j,p)
    if p>rand()
        network_[i,j]=1
    else
        network_[i,j]=-1
    end
    return network_
end
p=0.55
dim=50
network_=zeros(Int,dim,dim)
network_[rand(1:dim),rand(1:dim)]=1 #the first entry
for step in 1:(dim^2)
    operation_list=[]
    for i in 1:dim
        for j in 1:dim
            if network_[i,j]==0 && (1 in neighbor_checking(network_,dim,i,j))
                push!(operation_list,[i,j])
            end
        end
    end
    if length(operation_list)>0
        for i in operation_list
            network_=on_or_blocked(network_,dim,i[1],i[2],p)
        end
    elseif length(operation_list)==0
        break
    end
end
heatmap(network_)
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter4\\Fig\\4.7_p=0.5.png")
