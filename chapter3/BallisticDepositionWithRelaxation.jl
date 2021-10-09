using Plots
using DataStructures
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
function mean_calculater(arr,L)
    h=[]
    for i in 1:L
        i=BoundaryCondition(i)
        height= height_cal(i,arr)
        push!(h, height)
    end
    return mean(h)
end
function deposing(L,n)
    color=1
    meanList=[]
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
        meanNum=mean_calculater(arr,L)
        push!(meanList, meanNum)
    end
    return arr, meanList
end
arr,meanList=deposing(L,30000) #for plotting the dynamics and mean: n=30000
heatmap(hcat(arr), c=cgrad(:roma, 10, categorical = true, scale = :exp), xlabel="L")
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter3\\Fig\\RandomBallisticDepositionWithRelaxation.png")
scatter(1:30000,meanList, xlabel="time", ylabel="mean height of the layer")
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter3\\Fig\\RandomBallisticDepositionWithRelaxation2.png")
