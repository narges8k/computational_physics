using Plots
L=100
p=0.3
arr=zeros((L,L))
int_max=1000
for i in 1:L
    arr[i,1]=1
    arr[i,L]=int_max
end
entry=0
color_=2
function change(arr, neighbor,color_min, row, col, color_change_list)
    arr[row,col]=color_min
    for i in neighbors
        push!(i, color_change_list)
    end
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
function neighbor_checking(arr, row, col,neighbors, color_change_list)
    color_min=minimum(neighbors)
    count=0
    for i in neighbors
        if i==0
            return arr
            break
        end
        if i!=0
            count+=1
        end
    end
    if count==1
        arr[row, col]=neighbor
        return arr
    end
    if count>1
        arr=change(arr, neighbor,color_min, row, col, color_change_list)
    end
        return arr
    end
end

for i in 1:L
    for j in 1:L
        neighbors=[arr[i+1,j], arr[i-1,j], arr[i, j+1], arr[i, j-1]]
        if p>rand(0:1)
            arr[i,j]=color_
            color_+=1
        end
        arr=neighbor_checking(arr, i, j,neighbors,color_change_list)
    end
    end
    entry+=1
    if entry=L^2
        break
end
