using Plots
using DataStructures
using Statistics
n=30000
L=200
color=1
meanList=[]
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
function hight_cal(i,arr)
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
function ColumnChoosing(arr, col)
    h_dict=DataStructures.OrderedDict() #an ordered dictionary for the hights and columns
    for i in (col-1):1:(col+1)
        i=BoundaryCondition(i)
        height= hight_cal(i,arr)
        h_dict[height]=i
        #setindex!(h_dict,i,height)
    end
    #println(h_dict)
    hArr=collect(keys(h_dict)) #having all the heights in an array
    return get(h_dict,min(hArr...), "ERROR")
end
function mean_calculater(arr,meanList)
    hight=[]
    for col in eachcol(arr)
        count=0
        for element in col
            if element!=0
                count+=1
            end
        end
        push!(hight, count)
    end
    mean_num=mean(hight)
    push!(meanList, mean_num)
    return meanList
end
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
    meanList=mean_calculater(arr,meanList)
end
heatmap(hcat(arr), c=cgrad(:roma, 10, categorical = true, scale = :exp), xlabel="L")
scatter!(1:n,meanList, xlabel="time", ylabel="mean hight of the layer")
