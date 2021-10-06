using Plots
using DataStructures
using Statistics
n=30000
L=200
color=1
stdList=[]
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
for i in 1:18
    falling_n=t_interval[i+1]-t_interval[i]
    for each in 1:falling_n
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
        if i%(10*200*color)==0
            color+=1
        end
    end
    stdList=std_calculater(arr,stdList)
end
BigStdList=[]
run_number=100
for run in run_number
    n=30000
    L=200
    color=1
    stdList=[]
    arr=zeros((L,L))
    for i in 1:18
        falling_n=t_interval[i+1]-t_interval[i]
        for each in 1:falling_n
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
            if i%(10*200*color)==0
                color+=1
            end
        end
        stdList=std_calculater(arr,stdList)
    end
    push!(BigStdList, stdList)
end
BiggerMeanList=[]
BiggerStdList=[]
for i in 1:19
    tempvalue=[]
    for j in 1:100
        push!(tempvalue,BigStdList[j][i])
    end
    push!(BiggerStdList, std(tempvalue))
    push!(BiggerMeanList, mean(tempvalue))
end
plot(log.(t_interval), log.(BiggerMeanList),yerr=BiggerStdList, xlabel="time", ylabel="w")
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter3\\Fig\\RandomBallisticDepositionWithRelaxation3.png")
