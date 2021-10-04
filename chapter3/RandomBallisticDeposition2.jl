using Plots
using Statistics
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
totParticles=1000
particles=10
count=1
stdList=[]
time=ceil.(Int, exp.(1:0.5:10))
for i in 1:20
    falling_n=time[i+1]-time[i]
    for each in 1:falling_n
        column=rand(1:200)
        row=1
        for j in 1:200
            if arr[row, column]== 0.0
                arr[row, column]= count
                break
            else
                row+=1
            end
        end
        if i%(10*200*count)==0
            count+=1
        end
    end
    stdList=std_calculater(arr,stdList)
end

#plot(log.(time), log.(stdList))


time=ceil.(Int, exp.(1:0.5:10))
BigStdList=[]
run_number=100
for num in 1:run_number
    L=200
    arr=zeros((L,L))
    totParticles=1000
    particles=10
    count=1
    stdList=[]
    time=ceil.(Int, exp.(0:0.5:10))
    for i in 1:20
        falling_n=time[i+1]-time[i]
        for each in 1:falling_n
            column=rand(1:200)
            row=1
            for j in 1:200
                if arr[row, column]== 0.0
                    arr[row, column]= count
                    break
                else
                    row+=1
                end
            end
            if i%(10*200*count)==0
                count+=1
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
plot(log.(time), log.(BiggerMeanList),yerr=BiggerStdList, xlabel="time", ylabel="w")
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter3\\Fig\\RandomBallisticDeposition3.png")
