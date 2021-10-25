function randomWalk(starting_position,L)
    TotData=[[0.0 for i in 1:L]]
    TotData[1][starting_position]=1
    death_p_sum=(TotData[1][1]+TotData[1][end])
    if death_p_sum>=0.9 && death_p_sum<=1
        return 0
    end
    step=2
    while true
        R=[0.0 for e in 1:L]
        for i in 2:(L-1)
            R[i-1:2:i+1].+=TotData[step-1][i]/2
        end
        R[1]+=TotData[step-1][1]
        R[end]+=TotData[step-1][end]
        push!(TotData, R)

        death_p_sum+=(R[1]+R[end])
        # println(R)
        # println(step)
        # println(R[1])
        # println(R[end])
        if death_p_sum>=0.9 && death_p_sum<=1
            break
        end
        step+=1
    end
    return step-1
end

time_=randomWalk(4,20)
MeanLifeSpan=[]
StartingPosList=[i for i in 1:20]
for StartingPos in StartingPosList
    println(StartingPos)
    push!(MeanLifeSpan,randomWalk(StartingPos,20))
end
