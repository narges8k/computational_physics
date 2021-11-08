using Plots, Statistics, JLD
function movement(first_pos, step_num)
    directions=[[0,1],[0,-1],[1,0],[-1,0]]
    walking=rand(directions, step_num)
    return first_pos .+ cumsum(hcat(walking),dims=1)[step_num]
end
step_num_list=[10,100,1000]
first_pos=[0,0]
run_num=1000
SavedData=[]
for step_num in step_num_list
    final_destinations=zeros(Int, run_num, 2)
    for i in 1:run_num
        final_destinations[i,:]=movement(first_pos, step_num)
    end
    push!(SavedData, final_destinations)
end
save("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter5\\4.5\\2DWalker.jld", "data", SavedData)
