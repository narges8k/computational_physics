using Plots
using DataStructures
using Statistics
L=200
BigStdList=[]
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
    row=1
    height=0
    for j in 1:L
        if arr[row,i]!=0.0
            height+=1
            row+=1
        else
            break #exit the loop for the next column
        end
    end
    return height
end
function ColumnChoosing(arr, col) #choosing which column to fall into
    h_dict=DataStructures.OrderedDict() #an ordered dictionary : height=>column_num
    for i in (col-1):1:(col+1)
        i=BoundaryCondition(i)
        height= height_cal(i,arr)
        h_dict[height]=i
    end
    hArr=collect(keys(h_dict)) #having all the heights in an array
    return get(h_dict,min(hArr...), "ERROR") #returning the column respectively
end
function mean_and_std_calculater(arr,L)
    h=[]
    for i in 1:L
        i=BoundaryCondition(i)
        height= height_cal(i,arr)
        push!(h, height)
    end
    return mean(h), std(h)
end
function deposing(L,n)
    color=1
    meanList=[]
    stdList=[]
    arr=zeros((L,L))
    for particle in 1:n
        column=rand(1:L)
        col=ColumnChoosing(arr, column)
        row=1
        for j in 1:L
            if arr[row,col]==0.0
                arr[row,col]=color
                break
            else
                row+=1
            end
        end
        if particle%(10*200*color)==0
            color+=1
        end
        meanNum, stdNum=mean_and_std_calculater(arr,L)
        push!(meanList, meanNum)
        push!(stdList, stdNum)
    end
    return arr, meanList, stdList
end
arr,meanList, stdList=deposing(L,30000) #for plotting the dynamics and mean: n=30000
function LTMS_calculating(arr,L,meanList, stdList)
    t_interval=ceil.(Int, exp.(1:0.5:10))
    for i in 1:18
        n=t_interval[i+1]-t_interval[i]
        arr,meanList, stdList=deposing(L,n)
    end
    return stdList
end
for run in 1:10
    color=1
    meanList=[]
    stdList=[]
    arr=zeros((L,L))
    stdList=LTMS_calculating(arr, L,meanList, stdList)
    push!(BigStdList, stdList)
end
BiggerMeanList=[]
BiggerStdList=[]
for i in 1:19
    tempvalue=[]
    for j in 1:10
        push!(tempvalue,BigStdList[j][i])
    end
    push!(BiggerStdList, std(tempvalue))
    push!(BiggerMeanList, mean(tempvalue))
end
heatmap(hcat(arr), c=cgrad(:roma, 10, categorical = true, scale = :exp), xlabel="L")
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter3\\Fig\\RandomBallisticDepositionWithRelaxation.png")
scatter(1:30000,meanList, xlabel="time", ylabel="mean height of the layer")
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter3\\Fig\\RandomBallisticDepositionWithRelaxation2.png")
plot(log.(1:0.5:10), log.(BiggerMeanList),yerr=BiggerStdList, xlabel="time", ylabel="w")
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter3\\Fig\\RandomBallisticDepositionWithRelaxation3.png")