using Plots

rotation(x,y,theta)= [cos(theta) -sin(theta); sin(theta) cos(theta)]*[x;y]
points=[[0.0;0.0],[1.0;0.0]]
tempo=(points[2]-points[1])/sqrt(2)
point=rotation(tempo[1], tempo[2], pi/4)+points[1]
insert!(points,2, point)

for step in 1:20
    i=1
    while points[i]!= points[end]
        temp=(points[i+1]-points[i])/sqrt(2)
        point1=rotation(temp[1], temp[2], pi/4)+points[i]
        insert!(points, i+1, point1)
        point2=rotation(temp[1], temp[2], -pi/4)+points[i+2]
        insert!(points,i+3, point2)
        i+=4
    end
end




plot(hcat(points...)[1,:] , hcat(points...)[2,:])
