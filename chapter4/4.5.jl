using Plots,Statistics,LaTeXStrings
dim=100
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
    x_sum=0
    y_sum=0
    numerator=0
    for x in 1:dim
        for y in 1:dim
             if network_[x, y]==S_max
                y_sum+=y
                x_sum+=x
            end
        end
    end
    y_com=y_sum/cluster_size
    x_com=x_sum/cluster_size
    for x in 1:dim
        for y in 1:dim
             if network_[x, y]==S_max
                numerator+=(x-x_com)^2 + (y-y_com)^2
            end
        end
    end
    RadiusOfGyration=sqrt(numerator/cluster_size)
    return RadiusOfGyration
end
probability=[hcat(0:0.03:0.25)...,hcat(0.25:0.02:0.75)...,hcat(0.75:0.03:1)...]
Meanlist = []
STDlist = []
for p in probability
    xi=[]
    for run_num in 1:100
        network_,L,S=percolation(dim,p)
        push!(xi,RadiusOfGyration(network_,L,S,dim))
    end
    push!(STDlist, std(xi))
    push!(Meanlist, mean(xi))
end
scatter(probability, Meanlist, yerr=STDlist, xlabel="P", ylabel=L"\xi", title=L"\xi\_ P\ (L=100)",legend=false)
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter4\\Fig\\4.5_L=80.png")
