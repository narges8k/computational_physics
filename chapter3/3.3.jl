using Plots
using Statistics
L=200
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
    row=L
    height=L
    for j in 1:L
        if arr[row,i]==0.0
            height-=1
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
    for particle in 1:n
        col=rand(1:L)
        height=neighbor_checking(arr, col)
        if height>=L
            break
        end
        arr[height, col]=color
        if particle%(10*200*color)==0
            color+=1
        end
        meanList, stdList=mean_and_std_calculater(arr,meanList,stdList,L)
    end
    return arr, meanList, stdList
end
arr,meanList, stdList=deposing(arr,L,30000, 1 ,meanList, stdList)
heatmap(hcat(arr), c=cgrad(:roma, 10, categorical = true, scale = :exp), xlabel="L")
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter3\\Fig\\3.3_1.png")
scatter(1:30000,meanList, xlabel="time", ylabel="mean height of the layer")
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter3\\Fig\\3.3_2.png")
plot(log.(t_interval), log.(BiggerMeanList),yerr=BiggerStdList, xlabel="time", ylabel="w")
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter3\\Fig\\3.3_3.png")
