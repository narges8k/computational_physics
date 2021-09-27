using Plots

rotation(x,y, theta)= [cos(theta) -sin(theta); sin(theta) cos(theta)]*[x;y]
points=[[0.0;0.0],[1.0;0.0]]
for step in 1:10
    i=1
    while points[i]!=points[end]
        insert!(points,i+1,(points[i+1]-points[i])/3 + points[i])
        tempo=((points[i+2]-points[i])*(2/3)+points[i])-points[i+1]
        point=rotation(tempo[1], tempo[2], pi/3)+points[i+1]
        insert!(points,i+2,point)
        insert!(points,i+3,tempo+points[i+1])
        i+=4
    end
end


plot(hcat(points...)[1,:] , hcat(points...)[2,:],xlabel="x", ylabel="y")
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter2\\report\\Fig\\Koch.png")
