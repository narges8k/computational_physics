using Plots
using DataStructures
using Statistics
using LaTeXStrings
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
L=200
arr=zeros((L,L))
color=1
stdList=[]
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
for num in 1:run_number
    L=200
    arr=zeros((L,L))
    color=1
    stdList=[]
    time=ceil.(Int, exp.(0:0.5:10))
    for i in 1:20
        falling_n=time[i+1]-time[i]
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
function LineFit(Time, Mean)
    a=[hcat(log.(Time)) reshape(ones(13), 13, 1)]
    b=hcat(log.(Mean))
    line=(a\b)
    x = 1:10
    y = x .* line[1] .+ line[2]
    return x, y, line
end
BiggerMeanList[7:19]
X,Y,Line=LineFit(t_interval[7:19], BiggerMeanList[7:19])
plot(log.(t_interval), log.(BiggerMeanList),yerr=BiggerStdList, xlabel="time", ylabel="w(t)")
plot!(X,Y,c= :black,label = L"y = %$(round(Line[1],digits= 2))x + %$(round(Line[2],digits= 2))")
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter3\\Fig\\RandomBallisticDepositionWithRelaxation3.png")
