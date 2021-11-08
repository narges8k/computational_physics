using Plots, Statistics, JLD, LaTeXStrings, StatsBase
function movement(first_pos, step_num)
    directions=[[0,1],[0,-1],[1,0],[-1,0]]
    walking=rand(directions, step_num)
    return first_pos .+ cumsum(hcat(walking),dims=1)[step_num]
end
function Rg(data)
    COM=(mean(data, dims=1))
    return sqrt(mean((data[:,1] .- COM[1]) .^2 + (data[:,2] .- COM[2]) .^2))
end

step_num_list=[i for i in 100:100:1000]
first_pos=[0,0]
run_num=100000
AllData=[]
MeanSquaredDistance=[]
RgData=[]
for step_num in step_num_list
    final_destinations=zeros(Int, run_num, 2)
    squared_distance=[]
    for i in 1:run_num
        final_destinations[i,:]=movement(first_pos, step_num)
        push!(squared_distance, (final_destinations[i,1]^2 + final_destinations[i,2]^2))
    end
    push!(SavedData, final_destinations)
    push!(MeanSquaredDistance, mean(squared_distance))
    push!(RgData, Rg(final_destinations))
end
#Radius of Gyration plot:
scatter(log.(RgData), log.(step_num_list), legend=false, xlabel="log(Time)", ylabel="log(Rg)",
    title="Logarithm of Radious of Gyration over the Logarithm of Time", dpi=400, titlefontsize=9)
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter5\\4.5\\Figs\\Rg_Time.png")
# mean(r^2) plot:
scatter(MeanSquaredDistance, step_num_list, ylabel=L"<r^2>", xlabel="Time",
    title="Mean Squared Distance over Time", legend=false, dpi=400)
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter5\\4.5\\Figs\\MeanSquare(r)_Time.png")

save("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter5\\4.5\\2DWalker.jld",
    "data", AllData, "MeanSquaredDistanceData",MeanSquaredDistance, "RgData",RgData )
