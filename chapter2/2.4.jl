using Plots

numberslist=[[1],[1,1]]
#positions=[]
#positions[1]=[0;0]
for step in 3:6
    R=[1]
    for n in 2:(step-1)
        number=numberslist[step-1][n-1]+numberslist[step-1][n]
        push!(R, number)
    end
    push!(R, 1)
    push!(numberslist,R)

end
println(numberslist)
#println(numberslist)
