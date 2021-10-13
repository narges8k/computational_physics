using Plots,Statistics
dim=10

function NeighborReturner(network_, i, j)
    neighbors=[]
    if network_[i,j-1]!=0
        push!(neighbors, network_[i,j-1]) # the left neighbor--> neighbor[1]
    end
    if i!=1 && network_[i-1,j]!=0 #if true --> the neighbors[2] is the upper neighbor
        push!(neighbors,network_[i-1,j])
    end
    return neighbors
end
function InitialLabelFinder(a, L)
    while L[a] != L[L[a]]
        a = L[a]
    end
    return L[a]
end
function percolation(dim,p)
    network_=zeros(Int, dim, dim)
    L=[1]
    S=[dim]
    counter=2
    for i in 1:dim
        network_[i,1]=1
    end
    for col in 2:dim
        for row in 1:dim
            if p>rand()
                neighbors=NeighborReturner(network_, row, col)
                #println(row, col,neighbors)
                if length(neighbors)==0
                    network_[row,col]=counter
                    push!(L, counter)
                    push!(S, 1)
                    counter+=1
                elseif length(neighbors)==1
                    network_[row,col]=InitialLabelFinder(neighbors[1], L)
                    S[InitialLabelFinder(neighbors[1], L)]+=1
                elseif length(neighbors)!=0 && InitialLabelFinder(neighbors[1],L)==InitialLabelFinder(neighbors[2],L)
                    network_[row,col]=InitialLabelFinder(neighbors[1], L)
                    S[InitialLabelFinder(neighbors[1], L)]+=1
                else
                    network_[row,col]=InitialLabelFinder(neighbors[1], L)
                    L[InitialLabelFinder(neighbors[2], L)]=InitialLabelFinder(neighbors[1], L)
                    S[InitialLabelFinder(neighbors[1], L)]+=1+S[InitialLabelFinder(neighbors[2], L)]
                    S[InitialLabelFinder(neighbors[2], L)]=0

                end
            end
        end
    end
    return network_,L
end
function percolation_check(network_,L,dim)
    first_col=[]
    last_col=[]
    for i in 1:dim
        if network_[i,1]!=0
            push!(first_col,InitialLabelFinder(network_[i,1],L))
        end
    end
    for i in 1:dim
        if network_[i,dim]!=0
            push!(last_col,InitialLabelFinder(network_[i,dim],L))
        end
    end
    col=rand(1:dim) #choosing a random entry of the matrix
    row=rand(1:dim)
    if network_[row,col]!=0 && InitialLabelFinder(network_[row,col],L) in intersect(first_col,last_col)
        return 1
    else
        return 0
    end
end
#network_=percolation(dim, p)
Meanlist = []
STDlist = []
for p in 0.25:0.01:1
    check=[]
    for run_num in 1:1000
        network_,L=percolation(dim,p)
        push!(check,percolation_check(network_,L,dim))
    end
    push!(STDlist, std(check))
    push!(Meanlist, mean(check))
end
Meanlist
scatter(0.25:0.01:1, Meanlist, yerr=STDlist, xlabel="P", ylabel="Average infinite Q", legend=false)
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter4\\Fig\\4.4_L=10.png")
