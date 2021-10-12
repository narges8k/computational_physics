using Plots
function LimitControl(arr, i, j)
    neighbors=[]
    push!(neighbors, arr[i,j-1]) #the neibors[1] is the left neighbor
    if i+1!=0 # if true, the neighbors[2] is the right neighbor
        push!(neighbors,arr[i+1,j])
    end
    return neighbors
end
function index_returner(L,attribute)
    for i in L
        if L[i]==attribute
            break
            return i
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
function Perculation(dim, p)
    network_=zeros((dim,dim))
    L=[] #list of maps
    S=[] #list of the size of clusters
    for i in 1:L
        network_[i,1]=1
    end
    for col in 2:L
        counter=1
        for row in 1:L
            if p>rand()
                network_[row,col]=1
                neighbors=LimitControl(network_,row,col) #it checks the boundaries and returns the list of two neighbors
                if neighbors[1]==0 && neighbors[2]==0
                    network_[row,col]=counter
                    L[counter]=counter
                    S[counter]=S[counter]+1
                    count+=1
                    break
                end
                if neighbors[1]!=0 && neighbors[2]==0
                    network_[row,col]=n[1]
                    index_num=index_returner(L, neighbors[1])
                    S[index_num]=s[index_num]+1
                    break
                elseif neighbors[2]!=0 && neighbors[1]==0
                    network_[row,col]=neighbors[2]
                    index_num=index_returner(L, neighbors[2])
                    S[index_num]=s[index_num]+1
                    break
                end
                if n[1]!=0 && n[2]!=0
                    label=new_attribute(n[1], L)
                    network_[row,col]=label #ich bin nicht sicher was ich hier stelle muss!
                    neighbors[2]=label #ich bin nicht sicher was ich hier stelle muss!
                    index_num=index_returner(L, neighbors[2])
                    S[index_num]=0

        end
    end
end
