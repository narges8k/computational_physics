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

arr=zeros((200, 200))
stdList=[]
color=1
t_interval=ceil.(Int, exp.(1:0.5:14))
for i in 1:26
    n=t_interval[i+1]-t_interval[i]
    finalP=n
    for particle in 1:n
        col=rand(1:L)
        height=neighbor_checking(arr, col)
        if height>=L
            finalP=particle
            break
        end
        arr[height, col]=color
    end
    stdList=std_calculater(arr,stdList)
end

BigStdList=[]
run_number=100
for num in 1:run_number
    arr=zeros((L,L))
    stdList=[]
    for i in 1:26
        n=t_interval[i+1]-t_interval[i]
        finalP=n
        for particle in 1:n
            col=rand(1:L)
            height=neighbor_checking(arr, col)
            if height>=L
                finalP=particle
                break
            end
            arr[height, col]=color
        end
        stdList=std_calculater(arr,stdList)
    end
    push!(BigStdList, stdList)
end
BigStdList
BiggerMeanList=[]
BiggerStdList=[]
for i in 1:26
    tempvalue=[]
    for j in 1:100
        push!(tempvalue,BigStdList[j][i])
    end
    push!(BiggerStdList, std(tempvalue))
    push!(BiggerMeanList, mean(tempvalue))
end
BiggerMeanList
plot(hcat(1:0.5:14)[1:26], log.(BiggerMeanList),yerr=BiggerStdList, xlabel="t_interval", ylabel="w")
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter3\\Fig\\3.3_3.png")
