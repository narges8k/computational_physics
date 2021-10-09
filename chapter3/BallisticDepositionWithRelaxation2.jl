using Plots
using DataStructures
using Statistics
L=200
color=1

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
function std_calculater(arr,stdList)
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
    std_num=std(hight)
    push!(stdList, std_num)
    return stdList
end
t_interval=ceil.(Int, exp.(1:0.5:10))
arr=zeros((L,L))
stdList=[]
for i in 1:18
    n=t_interval[i+1]-t_interval[i]
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
    end
    stdList=std_calculater(arr,stdList)
end

BigStdList=[]
run_number=100
for num in 1:run_number
    arr=zeros((L,L))
    stdList=[]
    for i in 1:18
        n=t_interval[i+1]-t_interval[i]
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
        end
        stdList=std_calculater(arr,stdList)
    end
    push!(BigStdList, stdList)
end
BigStdList
BiggerMeanList=[]
BiggerStdList=[]
for i in 1:18
    tempvalue=[]
    for j in 1:100
        push!(tempvalue,BigStdList[j][i])
    end
    push!(BiggerStdList, std(tempvalue))
    push!(BiggerMeanList, mean(tempvalue))
end
plot(log.(1:0.5:10)[1:18], log.(BiggerMeanList),yerr=BiggerStdList, xlabel="t_interval", ylabel="w")
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter3\\Fig\\RandomBallisticDepositionWithRelaxation3.png")
