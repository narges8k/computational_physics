using Plots, LaTeXStrings, JLD, Statistics
TotalTime=1000
probability=[0.25,0.5,0.75,0.95]
function RandomWalk(TotalTime, probability)
    arr=zeros((TotalTime,length(probability)))
    for j in 1:length(probability)
        for i in 1:TotalTime
            if probability[j]>rand()
                arr[i,j]=1
            else
                arr[i,j]=-1
            end
        end
    end
    return cumsum(arr,dims=1)
end
#TheMatrix=RandomWalk(TotalTime, probability)
run_num=10000
# a list cinsisting of lists to the number of probabilities,
#each list having lists of each position in each run number per time:
RandomWalkers=[[[] for j in 1:TotalTime] for i in 1:length(probability)]
for n in 1:run_num
    TheMatrix=RandomWalk(TotalTime, probability)
    for col in 1:length(probability)
        for i in 1:TotalTime
            push!(RandomWalkers[col][i],TheMatrix[i,col])
        end
    end
end
SavedData_mean=[[] for i in 1:length(probability)]
SavedData_var=[[] for i in 1:length(probability)]
for i in 1:length(RandomWalkers)
    for j in RandomWalkers[i]
        push!(SavedData_var[i],var(j))
        push!(SavedData_mean[i],mean(j))
    end
end
save("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter5\\4.2\\chapter5_4.2_MeanAndStdData.jld",
 "MeanData", SavedData_mean, "VarData", SavedData_var)
 #plots:
load("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter5\\4.2\\chapter5_4.2_MeanAndStdData.jld")
scatter(dpi=400)
for i in 1:length(probability)
    p=probability[i]
    scatter!(1:TotalTime, SavedData_mean[i],label=L"%$p",markersize=1,markerstrokewidth=0, alpha=0.7)
end
scatter!(title="<x> per time for different probabilities", xlabel="t", ylabel="<x>")
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter5\\4.2\\Figs\\MeanPlot.png")
scatter(dpi=400)
for i in 1:length(probability)
    p=probability[i]
    scatter!(1:TotalTime, SavedData_var[i],label=L"%$p",markersize=1,markerstrokewidth=0, alpha=0.7)
end
scatter!(title="Var[x] per time  for different probabilities", xlabel="t", ylabel="Var[x]")
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter5\\4.2\\Figs\\VarPlot.png")
