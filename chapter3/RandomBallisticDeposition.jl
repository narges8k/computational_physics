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


# x=[]
# y=[]
# for i in 1:200, j=1:200
#     #println(arr[i,j])
#     if arr[i,j]==1.0
#         push!(x, i)
#         push!(y, j)
#     end
# end

heatmap(hcat(arr), c=cgrad(:matter, 5, categorical = true), ylabel="L")
