using Plots, LaTeXStrings, JLD, Statistics
TotalTime=1000
probability=[0.25,0.5,0.75,0.95]
function RandomWalk(TotalTime, probability)
    arr=zeros((TotalTime,length(probability)))
    for i in 1:TotalTime
        for j in 1:length(probability)
            if p>rand()
                arr[i,j]=1
            else
                arr[i,j]=-1
            end
        end
    end
    return cumsum(arr,dims=1)
end
run_num=100
# a list cinsisting of lists to the number of probabilities,
#each list having lists of each position in each run number per time:
RandomWalkers=[[[] for j in 1:TotalTime] for i in 1:length(probability)]
for n in 1:run_num
    TheMatrix=RandomWalk(TotalTime, probability)
    col_num=1
    for col in eachcol(TheMatrix)
        for i in 1:length(col)
            push!(RandomWalkers[col_num][i],TheMatrix[i,col_num])
        end
        col_num+=1
    end
end
SavedData_mean=[[] for i in 1:length(probability)]
for i in 1:length(RandomWalkers)
    for j in RandomWalkers[i]
        push!(SavedData_std[i],std(j))
        push!(SavedData_mean[i],mean(j))
    end
end
save("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter5\\4.2\\chapter5_4.2_MeanAndStdData.jld",
 "MeanData", SavedData_mean, "StdData", SavedData_std)
 #plots:
load("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter5\\4.2\\chapter5_4.2_MeanAndStdData.jld")
for i in 1:length(probability)
    p=probability[i]
    scatter!(1:TotalTime, SavedData_mean[i],title="<x> per time for different probabilities", xlabel="t", ylabel="<x>",label=L"%$p")
end
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter5\\4.2\\Figs\\MeanPlot.png")
for i in 1:length(probability)
    p=probability[i]
    scatter!(1:TotalTime, SavedData_std[i],title="Var[x] per time  for different probabilities", xlabel="t", ylabel="<x>",label=L"%$p")
end
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter5\\4.2\\Figs\\VarPlot.png")
