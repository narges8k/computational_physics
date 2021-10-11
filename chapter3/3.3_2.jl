using Plots
using Statistics
using LaTeXStrings
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
L=200
arr=zeros((L,L))
color=1
stdList=[]
t_interval=ceil.(Int, exp.(1:0.5:10))
for i in 1:18
    falling_n=t_interval[i+1]-t_interval[i]
    for each in 1:falling_n
        finalP=t_interval[18]
        col=rand(1:L)
        height=neighbor_checking(arr, col)
        if height>=L
            finalP=each
            break
        end
        arr[height, col]=color
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
            finalP=t_interval[18]
            col=rand(1:L)
            height=neighbor_checking(arr, col)
            if height>=L
                finalP=each
                break
            end
            arr[height, col]=color
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
    a=[hcat(log.(Time)) reshape(ones(19), 19, 1)]
    b=hcat(log.(Mean))
    line=(a\b)
    x = 1:10
    y = x .* line[1] .+ line[2]
    return x, y, line
end
X,Y,Line=LineFit(t_interval, BiggerMeanList)
plot(log.(t_interval), log.(BiggerMeanList),yerr=BiggerStdList, xlabel="time", ylabel="w(t)")
plot!(X,Y,c= :black,label = L"y = %$(round(Line[1],digits= 2))x + %$(round(Line[2],digits= 2))")
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter3\\Fig\\3.3_3.png")
