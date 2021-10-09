using Plots
using Statistics
L=200
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
        if arr[row,i]==0.0 #when the entry is empty
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
function mean_and_std_calculater(arr,L)
    h=[]
    for i in 1:L
        height= height_cal(i,arr)
        push!(h, height)
    end
    return mean(h),std(h)
end
function deposing(L,n)
    arr=zeros((200, 200))
    meanList=[]
    stdList=[]
    color=1
    finalP=n
    for particle in 1:n
        col=rand(1:L)
        height=neighbor_checking(arr, col)
        if height>=L
            finalP=particle
            break
        end
        arr[height, col]=color
        if particle%(10*200*color)==0
            color+=1
        end
        meanNum, stdNum=mean_and_std_calculater(arr,L)
        push!(meanList, meanNum)
        push!(stdList, stdNum)
    end
    return arr, meanList, stdList, finalP
end
arr,meanList, stdList, finalP=deposing(L,30000)
heatmap(hcat(arr), c=cgrad(:roma, 10, categorical = true, scale = :exp), xlabel="L")
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter3\\Fig\\3.3_1.png")
scatter(1:finalP-1,meanList, xlabel="time", ylabel="mean height of the layer")
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter3\\Fig\\3.3_2.png")
#plot(log.(t_interval), log.(BiggerMeanList),yerr=BiggerStdList, xlabel="time", ylabel="w")
#savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter3\\Fig\\3.3_3.png")
