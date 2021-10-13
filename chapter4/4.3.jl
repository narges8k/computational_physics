using Plots
function LimitControl(arr, i, j)
    neighbors=[]
    push!(neighbors, arr[i,j-1]) # the left neighbor--> neighbor[1]
    if i!=1 # if true --> the neighbors[2] is the upper neighbor
        push!(neighbors,arr[i-1,j])
    elseif i==1
        push!(neighbors, 0) #if no upper neigbhor--> consider it as an off neighbor
    end
    return neighbors
end
function index_returner(L,attribute)
    println("attribute",attribute)
    for i in 1:length(L)
        println("L[i]",L[i])
        if L[i]==attribute
            return i
            break
        end
    end
end
function new_attribute(a, L) #Ich habe das endlich gefunden.
    for i in length(L)
        if a==L[a]
        return a
        else
            a=new_attribute(L[a], L) #Ich weiß nicht, dass hier ich (a) zuruckzugeben soll, oder nicht!
        end
    end
end
function one_neighbor_on(network_, neighbor, S, L, row, col)
    network_[row,col]=neighbor
    index_num=index_returner(L, neighbor)
    println("indexnum",index_num)
    S[index_num]=S[index_num]+1
    return network_,S,L
end
function both_neighbors_on(network_, neighbors, S, L,row , col)
    label=new_attribute(neighbors[1], L)
    network_[row,col]=label #ich bin nicht sicher was ich hier stelle muss!
    neighbors[2]=label #ich bin nicht sicher was ich hier stelle muss!
    index_num=index_returner(L, neighbors[2])
    S[index_num]=0
end
function Perculation(dim, p)
    network_=zeros((dim,dim))
    L=[1.0] #list of maps
    S=[dim] #list of the size of clusters
    for i in 1:dim
        network_[i,1]=1
    end
    counter=1
    for col in 2:dim
        for row in 1:dim
            if p>rand()
                network_[row,col]=1
                neighbors=LimitControl(network_,row,col) #it checks the boundaries and returns the list of two neighbors
                if neighbors[1]==0 && neighbors[2]==0
                    network_[row,col]=counter
                    L[counter]=counter
                    S[counter]=S[counter]+1
                    counter+=1
                    break
                end
                println(neighbors)
                if neighbors[1]!=0 && neighbors[2]==0
                    network_,S,L=one_neighbor_on(network_, neighbors[1], S, L,row, col)
                    break
                elseif neighbors[2]!=0 && neighbors[1]==0
                    network,S,L=one_neighbor_on(network_, neighbors[2], S, L,row, col)
                    break
                end
                if n[1]!=0 && n[2]!=0
                    both_neighbors_on(network_, neighbors, S, L, row , col)
                end
            end
        end
    end
    return network_
end
p=0.3
dim=10
network_=Perculation(dim, p)
