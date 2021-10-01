using Plots
arr=zeros((200,200))
n=30000
count=1
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
end
heatmap(hcat(arr), c=cgrad(:roma, 10, categorical = true, scale = :exp), xlabel="L")
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter3\\Fig\\RandomBallisticDeposition1.png")
