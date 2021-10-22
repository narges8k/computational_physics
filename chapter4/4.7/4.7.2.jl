using Plots,Statistics, LaTeXStrings,JLD
dim=100
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
function on_or_blocked(network_,dim,i,j,p,S)
    if p>rand()
        network_[i,j]=1
        S+=1
    else
        network_[i,j]=-1
    end
    return network_,S
end

function operation(dim,p)
    network_=zeros(Int,dim,dim)
    network_[rand(1:dim),rand(1:dim)]=1 #the first entry
    S=1
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
                network_,S=on_or_blocked(network_,dim,i[1],i[2],p,S)
            end
        elseif length(operation_list)==0
            break
        end
    end
    return network_,S
end
function RadiusOfGyration(network_,dim)
    i_list=[]
    j_list=[]
    for index in findall(x->x==1, network_)
        push!(i_list, index[1])
        push!(j_list, index[2])
    end
    i_com=mean(i_list)
    j_com=mean(j_list)
    fraction_list=[]
    for i in 1:dim
        for j in 1:dim
            if network_[i,j]==1
                push!(fraction_list, ((i-i_com)^2 + (j-j_com)^2))
            end
        end
    end
    RadiusOfGyration=sqrt(mean(fraction_list))
    return RadiusOfGyration
end
# probability=[0.5, 0.55,0.59]
SavedData_xi=[]
SavedData_S=[]
xi=[]
S_list=[]
for run_num in 1:100
    network_,S=operation(dim,0.59)
    push!(S_list,S)
    push!(xi,RadiusOfGyration(network_,dim))
end
push!(SavedData_xi, xi)
push!(SavedData_S, S_list)
save("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter4\\4.7\\ClusterGrowth_p=0.59_xi.jld","data_xi", SavedData_xi, "data_S", SavedData_S)
