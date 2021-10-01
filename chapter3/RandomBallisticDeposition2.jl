using Plots
using Statistics

function each_p_placer(arr,particles,L,t )
    if t==1
        count=1
    end
    for p in particles
        column=rand(1:L)
        row=1
        for j in 1:L
            if arr[row, column]== 0.0
                arr[row, column]= count
                break
            else
                row+=1
            end
        end
        if t%(10*L*count)==0
            count+=1
        end
    end
    return arr
end

function std_calculater(arr,)
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
    return stdlist
end
L=200
arr=zeros((L,L))
totParticles=1000
particles=10
count=1
stdList=[]

for i in 1::n
    while particles<totParticles
        arr=each_p_placer(arr,particles,200,t)
    end
    stdList=std_calculater(arr)
end

plot(stdList, time)
