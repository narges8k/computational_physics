p=1/2
q=1-p
TotData=[[1.0]]

step_=2
while step_<10
    R=[TotData[step_-1][1]*q] #first element
    for i in 2:(2*step_-2)
        println(i)
        if i%2==0
            push!(R,0.0)
        else
            push!(R, TotData[step_-1][i]*q+TotData[step_-1][i-2]*p)
        end
    end
    push!(R,TotData[step_-1][end]*p) #last element
    push!(TotData,R)
    step_+=1
end
TotData
