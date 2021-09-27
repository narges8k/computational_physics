using Plots
using StatsBase
f1(point)=[0.00 0.00 ; 0.00 0.16]*point
f2(point)=[0.85 0.04 ; -0.04 0.85]*point + [0.00 ; 1.60]
f3(point)=[0.20 -0.26 ; 0.23 0.22]*point + [0.00 ; 1.60]
f4(point)=[-0.15 0.28 ; 0.26 0.24]*point + [0.00 ; 0.44]

f_list=[f1, f2, f3, f4]


p=100
num=500000
finalPoints=[]

for number_of_points in 1:num
    (number_of_points==1) ? (point=point=[0.0; 0.0]) : (point=[rand();rand()])
    for number_of_iteration in 1:p
        weights=[0.01,0.85,0.07,0.07]
        items=[f1, f2, f3, f4]
        point=sample(items, Weights(weights))(point)
    end
    push!(finalPoints, point)
end
scatter(hcat(finalPoints...)[1,:], hcat(finalPoints...)[2,:],markersize=0.7, color=:green, xlabel="x", ylabel="y", legend=false)
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter2\\report\\RandomBarnsleyFern.png")
