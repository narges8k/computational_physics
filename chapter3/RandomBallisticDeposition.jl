using Plots
using Statistics
using ProgressBars
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
anim = Animation()
for i in ProgressBar(1:n)
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
    p = heatmap(hcat(arr), c=cgrad(:roma, 10, categorical = true, scale = :exp), xlabel="L")
    frame(anim, p)
    #meanList=mean_calculater(arr,meanList)
end
gif(anim,"C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter3\\Fig\\RBD.gif",fps=50)
heatmap(hcat(arr), c=cgrad(:roma, 10, categorical = true, scale = :exp), xlabel="L")
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter3\\Fig\\RandomBallisticDeposition1.png")
scatter!(1:n,meanList, xlabel="time", ylabel="mean hight of the layer")
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter3\\Fig\\RandomBallisticDeposition2.png")
