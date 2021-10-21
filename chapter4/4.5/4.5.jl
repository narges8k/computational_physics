using Plots,Statistics,LaTeXStrings,JLD
dim=10
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
probability=[hcat(0:0.03:0.30)...,hcat(0.30:0.02:0.70)...,hcat(0.70:0.03:1)...]
Meanlist = []
STDlist = []
SavedData=[]
for p in probability
    xi=[]
    for run_num in 1:100
        network_,L,S=percolation(dim,p)
        push!(xi,RadiusOfGyration(network_,L,S,dim))
    end
    push!(SavedData, xi)
    push!(STDlist, std(xi))
    push!(Meanlist, mean(xi))
end

scatter(probability, Meanlist, yerr=STDlist, xlabel="P", ylabel=L"\xi", title=L"\xi\_ P\ (L=10)",legend=false)
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter4\\Fig\\4.5_L=10.png")
