using Plots

rotation(x,y,theta)= [cos(theta) -sin(theta); sin(theta) cos(theta)]*[x;y]
points=[[0.0;0.0],[1.0;0.0]]
tempo=(points[2]-points[1])/sqrt(2)
point=rotation(tempo[1], tempo[2], pi/4)+points[1]
insert!(points,2, point)

for step in 1:20

    i=1
    while points[i]!= points[end]
        temp1=(points[i+1]-points[i])/sqrt(2)
        point1=rotation(temp1[1], temp1[2], +pi/4)+points[i]
        insert!(points, i+1, point1)
        temp2=(points[i+3]-points[i+2])/sqrt(2)
        point2=rotation(temp2[1], temp2[2], -pi/4)+points[i+2]
        insert!(points,i+3, point2)
        i+=4
    end
end


plot(hcat(points...)[1,1:floor(Int,length(points)/2)] , hcat(points...)[2,1:floor(Int, length(points)/2)], color=:blue, border=:none)
plot!(hcat(points...)[1,floor(Int, length(points)/2):end], hcat(points...)[2,floor(Int, length(points)/2):end], color=:red, border=:none)
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter2\\report\\Fig\\DragonFractal.png")
