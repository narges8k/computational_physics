using Plots,Statistics,LaTeXStrings,JLD,LsqFit
function NeighborReturner(network_, i, j)
    neighbors=[]
    if j!=1 && network_[i,j-1]!=0
        push!(neighbors, network_[i,j-1]) # the left neighbor--> neighbor[1]
    end
    if i!=1 && network_[i-1,j]!=0 #if true --> the neighbors[2] is the upper neighbor
        push!(neighbors,network_[i-1,j])
    end
    return neighbors
end
function LabelFinder(a, L)
    while L[a] != L[L[a]]
        a = L[a]
    end
    return L[a]
end
function percolation_check(network_,L,dim)
    first_col=[]
    last_col=[]
    for i in 1:dim
        if network_[i,1]!=0
            push!(first_col,LabelFinder(network_[i,1],L))
        end
    end
    for i in 1:dim
        if network_[i,dim]!=0
            push!(last_col,LabelFinder(network_[i,dim],L))
        end
    end
    return intersect(first_col,last_col)
end
function percolation(dim,p)
    network_=zeros(Int, dim, dim)
    L=[]
    S=[]
    counter=1
    for col in 1:dim
        for row in 1:dim
            if p>rand()
                neighbors=NeighborReturner(network_, row, col)
                if length(neighbors)==0
                    network_[row,col]=counter
                    push!(L, counter)
                    push!(S, 1)
                    #println(S)
                    counter+=1
                elseif length(neighbors)==1
                    network_[row,col]=LabelFinder(neighbors[1], L)
                    S[LabelFinder(neighbors[1], L)]+=1
                elseif length(neighbors)==2 && LabelFinder(neighbors[1],L)==LabelFinder(neighbors[2],L)
                    network_[row,col]=LabelFinder(neighbors[1], L)
                    S[LabelFinder(neighbors[1], L)]+=1
                else
                    S[LabelFinder(neighbors[1], L)]+=1+S[LabelFinder(neighbors[2], L)]
                    S[LabelFinder(neighbors[2], L)]=0
                    network_[row,col]=LabelFinder(neighbors[1], L)
                    L[neighbors[2]]=LabelFinder(neighbors[1], L)
                end
            end
        end
    end
    return network_,L,S
end
function RadiusOfGyration(network_,L,S,dim)
    if length(Set(S)) < 3
        return 0.0
    end
    if findall(x->x==maximum(S),S)[1] ∈ percolation_check(network_,L,dim)
        S[findall(x->x==maximum(S),S)[1]]=0 #the infinit cluster is omitted from S in this way.
    end
    cluster_size=maximum(S)
    S_max=findall(x->x==maximum(S),S)[1]
    numerator=0
    i_nums=[]
    j_nums=[]
    for coordinate_num in findall(x->x==S_max,network_)
        push!(i_nums, coordinate_num[1])
        push!(j_nums, coordinate_num[2])
    end
    i_com=mean(i_nums)
    j_com=mean(j_nums)
    TheFraction_list=[]
    for i in 1:dim
        for j in 1:dim
             if network_[i, j]==S_max
                push!(TheFraction_list,((i-i_com)^2 + (j-j_com)^2))
            end
        end
    end
    RadiusOfGyration=sqrt(mean(TheFraction_list))
    return RadiusOfGyration
end
dim_list=[10,20,40,80,160]
SavedData_std=[]
SavedData_mean=[]
for n in 1:5
    dim=dim_list[n]
    Meanlist = []
    STDlist = []
    probability=[hcat(0:0.03:0.25)...,hcat(0.25:0.02:0.75)...,hcat(0.75:0.03:1)...]
    for p in probability
        xi=[]
        for run_num in 1:1000
            network_,L,S=percolation(dim,p)
            push!(xi,RadiusOfGyration(network_,L,S,dim))
        end
        push!(STDlist, std(xi))
        push!(Meanlist, mean(xi))
    end
    push!(SavedData_std, STDlist)
    push!(SavedData_mean, Meanlist)
end
save("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter4\\4.5\\AllData_ClusterGrowth.jld",
"std_data", SavedData_std,
"mean_data", SavedData_mean)

#creating the figures:
load("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter4\\4.5\\AllData_ClusterGrowth.jld")
#plot withough error bars:
plot(dpi=400)
for i in 1:5
    dim=dim_list[i]
    scatter!(probability, SavedData_mean[i][1:43],label=nothing,markersize=3,c=:black,alpha=0.3)
    plot!(probability, SavedData_mean[i][1:43],label=L"L=%$dim")

end
scatter!(xlabel="P", ylabel=L"\xi", title=L"\xi\_ P")
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter4\\Fig\\4.5_plot.png")
#scatter plot including error bars:
plot(dpi=400)
for i in 1:5
    dim=dim_list[i]
    scatter!(probability, SavedData_mean[i][1:43],yerr=SavedData_std[i][1:43],markersize=3,
    alpha=0.7,label=L"L=%$dim")

end
scatter!(xlabel="P", ylabel=L"\xi", title=L"\xi\_ P")
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter4\\Fig\\4.5_scatter.png")
#getting Pc(∞) and ν:
xdata=[]
ydata=dim_list
for i in 1:5
    Pc_L= probability[findall(x->x==maximum(SavedData_mean[i]),SavedData_mean[i])[1]]
    push!(xdata, Pc_L)

end
println(xdata)
println(ydata)
@.model(x,p)=abs(x-p[1])^(-p[2])
p0=[1.3, 0.59]
fit=curve_fit(model, xdata, ydata, p0)
#result: ν-->0.61 , Pc(∞)-->1.02
