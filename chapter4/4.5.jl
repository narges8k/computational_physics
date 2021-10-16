using Plots,Statistics,LaTeXStrings
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
            push!(first_col,InitialLabelFinder(network_[i,1],L))
        end
    end
    for i in 1:dim
        if network_[i,dim]!=0
            push!(last_col,InitialLabelFinder(network_[i,dim],L))
        end
    end
    if length(intersect(first_col,last_col)) > 0
        return intersect(first_col,last_col)
    end
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
function RadiusOfGyration(network_, S)
    for j in  percolation_check(network_,L,dim)
        S[j]=-1 # the infinit cluster is omitted from S in this way.
    end
    RadiusOfGyration_list=[]
    for  i in 1:length(S)
        x_sum=0
        y_sum=0
        numerator=0
        if S[i]!=0 && S[i]!=-1
            for x in 1:dim
                for y in 1:dim
                     if network_[x, y]==i
                        y_sum+=y
                        x_sum+=x
                    end
                end
            end
            y_com=y_sum/S[i]
            x_com=x_sum/S[i]
            for x in 1:dim
                for y in 1:dim
                     if network_[x, y]==i
                        numerator+=sqrt((x-x_com)^2 + (y-y_com)^2)
                    end
                end
            end

            push!(RadiusOfGyration_list,sqrt(numerator/S[i]))
        end
    end
    sum=0
    counter=0
    for i in RadiusOfGyration_list
        sum+=i
        counter+=1
    end
    return sum/counter
end


Meanlist = []
STDlist = []
for p in 0.5:0.05:1
    xi=[]
    for run_num in 1:100
        network_,L=percolation(dim,p)
        push!(xi,RadiusOfGyration(network_, S))
    end
    push!(STDlist, std(xi))
    push!(Meanlist, mean(xi))
end
scatter(0:0.05:1, Meanlist, yerr=STDlist, xlabel="P", ylabel=L"ξ", legend=false)
