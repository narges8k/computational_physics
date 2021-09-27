using Plots

numberslist=[[1],[1,1]]

for step in 3:100
    R=[1]
    for n in 2:(step-1)
        number=numberslist[step-1][n-1]+numberslist[step-1][n]
        push!(R, number)
    end
    push!(R, 1)
    push!(numberslist,R)

end
#println(numberslist)
odd_num_pos=[]
even_num_pos=[]
y=0.0
x=0.0
for row in numberslist
    x=y/2
    for number in row
        (number%2==0) ? (push!(even_num_pos, [x;y])) : (push!(odd_num_pos, [x;y]))
        x+=1
    end
    y-=1
end

scatter(hcat(odd_num_pos...)[1,:], hcat(odd_num_pos...)[2,:], color=:darkgreen, xlabel="x", ylabel="y",markersize=0.7,legend=false)
scatter!(hcat(even_num_pos...)[1,:], hcat(even_num_pos...)[2,:], color=:lightsalmon, xlabel="x", ylabel="y", markersize=0.7,legend=false)
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter2\\report\\KhayyamTriangle.png")
