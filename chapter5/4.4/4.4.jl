using Plots,JLD
function randomWalk(starting_position,L)
    mean_life_span=0
    TotData=[[0.0 for i in 1:L]]
    TotData[1][starting_position]=1
    death_p_sum=(TotData[1][1]+TotData[1][end])
    if death_p_sum>=0.9 && death_p_sum<=1
        return 0
    end
    step=2
    while true

        death_p_sum=0
        R=[0.0 for e in 1:L]
        for i in 2:(L-1)
            R[i-1:2:i+1].+=TotData[step-1][i]/2
        end
        R[1]+=TotData[step-1][1]
        R[end]+=TotData[step-1][end]
        push!(TotData, R)

        death_p_sum+=(R[1]+R[end])
        #println(R)
        # println(step)
        # println(R[1])
        # println(R[end])
        mean_life_span+=sum(R[2:19])
        if death_p_sum>=0.99999999
            break
        end
        step+=1
    end
    return mean_life_span
end

#time_=randomWalk(2,20)
MeanLifeSpan=[]
StartingPosList=[i for i in 1:20]
for StartingPos in StartingPosList
    println(StartingPos)
    push!(MeanLifeSpan,randomWalk(StartingPos,20))
end
save("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter5\\4.4\\MeanLifeSpan_startpos_deterministic_data.jld",
 "data", MeanLifeSpan)
scatter(StartingPosList, MeanLifeSpan,legends=false, color=:black, alpha=0.5,dpi=400)
plot!(StartingPosList, MeanLifeSpan,guidefontsize=9, color=:pink2,
 xlabel="the Starting Position",ylabel="Mean Life-Span",
 title="Mean Life-Span Over the Starting Position Using the Deterministic Algorithm", titlefontsize=9)
 savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter5\\4.4\\Figs\\MeanLifeSpan_startpos_deterministic.png")
