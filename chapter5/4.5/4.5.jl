using Plots, Statistics, JLD, LaTeXStrings
function movement(first_pos, step_num)
    directions=[[0,1],[0,-1],[1,0],[-1,0]]
    walking=rand(directions, step_num)
    return first_pos .+ cumsum(hcat(walking),dims=1)[step_num]
end

step_num_list=[i for i in 100:100:1000]
first_pos=[0,0]
run_num=10000
AllData=[]
MeanSquaredDistance=[]
for step_num in step_num_list
    final_destinations=zeros(Int, run_num, 2)
    squared_distance=[]
    for i in 1:run_num
        final_destinations[i,:]=movement(first_pos, step_num)
        push!(squared_distance, (final_destinations[i,1]^2 + final_destinations[i,2]^2))
    end
    push!(SavedData, final_destinations)
    push!(MeanSquaredDistance, mean(squared_distance))
    end
SavedData
MeanSquaredDistance
scatter(MeanSquaredDistance, step_num_list, ylabel=L"<r^2>", xlabel="step",
    title="Mean Squared Distance over steps", legend=false, dpi=400)
save("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter5\\4.5\\2DWalker.jld",
    "data", AllData, "MeanSquaredDistanceData",MeanSquaredDistance )
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter5\\4.5\\Figs\\MeanSquare(r)_step.png")
