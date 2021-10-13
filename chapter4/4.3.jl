using Plots
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
function InitialLabelFinder(a, L) #Ich habe das endlich gefunden.
    for i in length(L)
        if a==L[a]
        return a
        else
            a=InitialLabelFinder(L[a], L) #Ich weiß nicht, dass hier ich (a) zuruckzugeben soll, oder nicht!
        end
    end
end
function percolation(dim, p)
    network_=zeros((dim,dim))
    L=[]
    S=[]
    counter=1
    for i in 1:dim
        network_[i,1]=1
    end
    for col in 2:dim
        for row in 1:dim
            if p>rand()
                neighbors=NeighborReturner(network_, row, col)
                if length(neighbors)==0
                    network_[row,col]=counter
                    push!(L, counter)
                    push!(S, 1)####????!!!!!!!
                    counter+=1
                elseif length(neighbors)==1
                    network_[row,col]=InitialLabelFinder(Int(neighbors[1]), L)
                    S[InitialLabelFinder(neighbors[1], L)]+=1
                elseif length(neighbors)!=0 && InitialLabelFinder(neigbhors[1],L)==InitialLabelFinder(neighbors[2],L)
                    S[InitialLabelFinder(neighbors[1], L)]+=1
                else
                    network_[row,col]=InitialLabelFinder(neighbors[1], L)
                    L[neighbors[2]]=InitialLabelFinder(neighbors[1], L)
                    S[InitialLabelFinder(neighbors[2], L)]=0
                    S[InitialLabelFinder(neighbors[1], L)]+=1+S[InitialLabelFinder(neighbors[2], L)]
                end
            end
        end
    end
    return network_
end
dim=10
p=0.3
network_=percolation(dim, p)
