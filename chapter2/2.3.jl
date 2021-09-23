using Plots
result_triangles=[[[0.0;0.0], [0.5;sqrt(3)/2],[1.0;0.0],[0.0;0.0]]]
for step in 1:3
    first_triangle=[]
    second_triangle=[]
    third_triangle=[]
    newOnes=[]
    for triangle in result_triangles
        for i in 1:4
            vertix=(triangle[i]-triangle[1])/2+triangle[1]
            push!(first_triangle, vertix)
        end
        for i in 1:4
            push!(second_triangle, first_triangle[i]+(first_triangle[2]-first_triangle[1]))
            push!(third_triangle, first_triangle[i]+(first_triangle[3]-first_triangle[1]))
        end
        append!(newOnes, first_triangle)
        append!(newOnes, second_triangle)
        append!(newOnes, third_triangle)
        #println(result_triangles)
    end
    result_triangles=newOnes
end
plot()
for little_triangles in result_triangles
    #println(little_triangles)
    plot!(hcat(little_triangles...)[1,:] , hcat(little_triangles...)[2,:], fill=(0,0.5,"orange"))
end
plot!()
# plot(hcat(first_triangle...)[1,:],hcat(first_triangle...)[2,:])
# plot!(hcat(second_triangle...)[1,:],hcat(second_triangle...)[2,:])
# plot!(hcat(third_triangle...)[1,:],hcat(third_triangle...)[2,:])
