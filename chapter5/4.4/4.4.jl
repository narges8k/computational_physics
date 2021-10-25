
starting_position=7; L=20
TotData=[[0.0 for i in 1:L]]
TotData[1][starting_position]=1
step=2
death_p_sum=0
while true
    R=[0.0 for e in 1:L]
    for i in 2:(L-1)
        R[i-1:2:i+1].+=TotData[step-1][i]/2
    end
    R[1]+=TotData[step-1][1]
    R[end]+=TotData[step-1][end]
    push!(TotData, R)
    step+=1
    death_p_sum+=R[1]
    death_p_sum+=R[end]
    if death_p_sum>=0.99
        break
    end
    println(R)
end
