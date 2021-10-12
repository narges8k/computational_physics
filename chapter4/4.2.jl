using Plots
L=100
p=0.5
function LimitControl(arr, i, j)
    color_change_list=[]#this list includes the neighbors' attributes
    if i+1!=L+1
        push!(color_change_list,arr[i+1,j])
    end
    if i-1!=0
        push!(color_change_list,arr[i-1,j])
    end
    if j+1!=L+1
        push!(color_change_list,arr[i,j+1])
    end
    if j-1!=0
        push!(color_change_list, arr[i,j-1])
    end
    return color_change_list
end
function whole_color_change(arr,color_min, row, col, color_change_list)
    arr[row,col]=color_min
    for i in 1:L
        for j in 1:L
            for color in color_change_list
                if arr[i,j]==color
                    arr[i,j]=color_min
                end
            end
        end
    end
    return arr
end
function neighbor_checking(arr, row, col,color_change_list)
    color_min=minimum(color_change_list)
    count=0
    the_neighbor_color=0
    for i in color_change_list
        if i==0
            return arr
            break
        end
        if i!=0
            count+=1
            the_neighbor_color=i
        end
    end
    if count==1 #if true, the_neighbor_color is the color of that only neighbor.
        arr[row, col]=the_neighbor_color
        return  arr
    end
    if count>1
        arr=whole_color_change(arr,color_min, row, col, color_change_list)
    end
        return arr
end
function Percolation(L,p)
    tot=[]
    int_max=100000
    color_=2
    arr=zeros((L,L))
    for i in 1:L
        arr[i,1]=1
        arr[i,L]=int_max
    end
    for j in 2:L-1
        for i in 1:L
            color_change_list=LimitControl(arr, i , j)
            if p>rand()
                arr[i,j]=color_
                color_+=1
            end
            arr=neighbor_checking(arr, i, j,color_change_list) #color_change_list includes the neighbors' color, so we can use the list as the neighbors' attributes.
        end
        push!(tot, copy(arr))
    end
    return tot
end
tot=Percolation(L,p)

@gif for i in 1:1:length(tot)
    heatmap(tot[i][:,1:end-1], c = cgrad(:copper, 10), legend = false, border = :none, title = "Percolation for P = 0.1")
end
#gif(anim, "../../Fig/Percolation0.3.gif")
