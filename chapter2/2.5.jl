using Plots

function1(point)=point/2
function2(point)=point/2+[1;0]
function3(point)=point/2+[1/2;sqrt(3)/2]

num=50000
p=100
finalPoints=[]
for number_of_points in 1:num
    point=[rand();rand()]
    for number_of_iteration in 1:p
        point=rand((function1(point), function2(point), function3(point)))
    end
    push!(finalPoints, point)
end
scatter(hcat(finalPoints...)[1,:], hcat(finalPoints...)[2,:],markersize=0.7, color=:purple)
