using Plots
using Statistics
L=201
color=1
meanList=[]
stdList=[]
BigStdList=[]
arr=zeros((L,L))
function BoundaryCondition(i)
    if i==L+1
        return 1
    elseif i==0
        return L
    else
        return i
    end
end
function height_cal(i,arr) #calculating the height of the layer in a column
    i=BoundaryCondition(i)
    row=L #starting from the top layer
    height=L
    for j in 1:L
        if arr[row,i]==-1 #when the entry is empty
            height-=1 #decreasing height by one
            row-=1
        else
            break #exit the loop for the next column
        end
    end
    return height
end
function neighbor_checking(arr, col)
    h=[]
    for i in (col-1):1:(col+1)
        height= height_cal(i,arr)
        if i==col
            push!(h, (height+1))
        else
            push!(h, height)
        end
    end
    return maximum(h)
end
function mean_and_std_calculater(arr,meanList,stdList,L)
    h=[]
    for i in 1:L
        height= height_cal(i,arr)
        push!(h, height)
    end
    mean_num=mean(h)
    push!(meanList, mean_num)
    std_num=std(h)
    push!(stdList, std_num)
    return meanList,stdList
end
function deposing(arr,L,n, color,meanList, stdList)
    AvailableCols=[ceil(Int, L/2)]
    for i in 1:L
        arr[i, ceil(Int, L/2)]=-1
    end
    for particle in 1:n
        col=rand(1:L)
        if col in AvailableCols
            height=neighbor_checking(arr, col)
            if height>=L
                break
            end
            arr[height, col]=color
            if particle%(10*200*color)==0
                color+=1
            end
            for i in col-1:1:col+1
                for j in height+1:L
                    arr[j, i]=-1
                    push!(AvailableCols, i)
                end
            end
        end
        #meanList, stdList=mean_and_std_calculater(arr,meanList,stdList,L)
    end
    return arr, meanList, stdList
end
arr,meanList, stdList=deposing(arr,L,30000, 1 ,meanList, stdList)
heatmap(hcat(arr), c=cgrad(:roma, 10, categorical = true, scale = :exp), xlabel="L")
