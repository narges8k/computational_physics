p=1/2
q=1-p
TotData=[[1.0]]
steps=10
for step in 2:steps
    R=[TotData[step-1][1]*q] #first element
    for i in 2:(2*step-2)
        println(i)
        if i%2==0
            push!(R,0.0)
        else
            push!(R, TotData[step-1][i]*q+TotData[step-1][i-2]*p)
        end
    end
    push!(R,TotData[step-1][end]*p) #last element
    push!(TotData,R)
end
TotData
