using Plots
using Statistics
arr=zeros((200,200))
n=30000
count=1
meanList=[]
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

for i in 1:n
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
    meanList=mean_calculater(arr,meanList)
end
heatmap(hcat(arr), c=cgrad(:roma, 10, categorical = true, scale = :exp), xlabel="L")
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter3\\Fig\\RandomBallisticDeposition1.png")
scatter!(1:n,meanList)
