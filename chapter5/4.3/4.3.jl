using Plots, LaTeXStrings, JLD, Statistics,Gadfly
function RandomWalk(p,first_step)
    arr=[first_step]
    PosPerTime=[first_step]
    #condition=true
    while true
        if p>rand()
            push!(arr, 1)
        else
            push!(arr, -1)
        end
        PosPerTime=cumsum(arr,dims=1)
        if (10 ∈ PosPerTime) || (-10 ∈ PosPerTime)
            break
        end
    end
    return PosPerTime
end
# PosPerTime=RandomWalk(0.5,-1)
run_num=100000
StartingPosList=[i for i in -10:10]
AvgSteps=[]
for first_step in StartingPosList
    steps=[]
    for n in 1:run_num
        PosPerTime=RandomWalk(0.5,first_step)
        push!(steps, length(PosPerTime))
    end
    push!(AvgSteps, mean(steps))
end
save("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter5\\4.3\\chapter5_4.3_AvgSteps_p=0.5.jld",
 "data", AvgSteps)
scatter(StartingPosList, AvgSteps,legends=false, color=:black, alpha=0.5)
plot!(StartingPosList, AvgSteps,guidefontsize=9, color=:mediumpurple3,
legends=false, ylabel="Average Steps Before Reaching the Boundaries", xlabel="the Starting Position",
title="Dependance of the Random Walker's Average Lifetime to It's Starting Position",titlefontsize=9)
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter5\\4.3\\Figs\\avgstep_startpos_p=0.5.png")
# #plot!(x=StartingPosList[1:end], y=AvgSteps[1:end],guidefontsize=9, color=:mediumpurple3,
# Geom.point, Geom.smooth(method=:loess,smoothing=0.9),
# legends=false, ylabel="Average Steps Before Reaching the Boundaries", xlabel="the Starting Position",
# title="Dependance of the Random Walker's Average Lifetime to It's Starting Position",titlefontsize=9)
