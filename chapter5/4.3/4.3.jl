using Plots, LaTeXStrings, JLD, Statistics
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
    return PosPerTime,arr
end
PosPerTime,arr=RandomWalk(0.5,-1)
findall(x->x==10, PosPerTime)
#probability=[0.5]#,0.5,0.75,0.95
run_num=10
StartingPosList=[i for i in -10:10]
AvgSteps=[]
for first_step in StartingPosList
    # println("first_step:", first_step)
    steps=[]
    for n in 1:run_num
        println("run_num:",n, "first_step:", first_step)
        PosPerTime=RandomWalk(0.5,first_step)
        push!(steps, length(PosPerTime))
    end
    push!(AvgSteps, mean(steps))
end


scatter!(StartingPosList, AvgSteps)
