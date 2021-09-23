using Plots
result_triangles=[[[0.0;0.0], [0.5;sqrt(3)/2],[1.0;0.0],[0.0;0.0]]]
first_triangle=[]
second_triangle=[]
third_triangle=[]
for i in 1:4
    vertix=(result_triangles[1][i]-result_triangles[1][1])/2+result_triangles[1][1]
    push!(first_triangle, vertix)
end
for i in 1:4
    push!(second_triangle, first_triangle[i]+(first_triangle[2]-first_triangle[1]))
    push!(third_triangle, first_triangle[i]+(first_triangle[3]-first_triangle[1]))
end
insert!(result_triangles, 2, first_triangle)
insert!(result_triangles, 3, second_triangle)
insert!(result_triangles, 4, third_triangle)
println(result_triangles)
plot()
for little_triangles in result_triangles
    #println(little_triangles)
    plot!(hcat(little_triangles...)[1,:] , hcat(little_triangles...)[2,:])
end
plot!()
# plot(hcat(first_triangle...)[1,:],hcat(first_triangle...)[2,:])
# plot!(hcat(second_triangle...)[1,:],hcat(second_triangle...)[2,:])
# plot!(hcat(third_triangle...)[1,:],hcat(third_triangle...)[2,:])
