using Plots
using CircularArrays
n=300 #the number of particles
L=50 #Length of the line
color=1 #used for color-change
MainArray=zeros((L,L))

function particle_falling(MainArray, col, L, color) #this function operates falling of the particle
    row=height_checker(MainArray, col) #the particle stops at this height(row)
    if row!=L
        MainArray[row+1][col]=color
    end
    return MainArray
end


function height_checker(MainArray, col) #comparing the  of the column the particle exists in, with its neighbors
    height=height_calculater(MainArray, col-1, [],L)
    if height[2]<height[1] || height[2]<height[3] #the other two neighbors' heights are higher.
        if height[1]==height[3]
            the_row_num=rand((height[1], height[3]))
        end
        if height[1]!=height[3]
            the_row_num=max(height[1], height[3]) #if the two neighbors have equall heights, then the maximum height will be chosen.
        end
    else
        the_row_num=height[2]
    end
    return the_row_num
end

function boundary_conditions(MainArray, c_index)
    if MainArray
        (c_index+2)=1
    end
    if (c_index+1)==1
        c_index=L
    end
end
function height_calculater(MainArray, c_index, height,L) #This function calculates the height of the three columns we must know.
    for column in eachcol(MainArray)
        while indexCounter<=3
            if column==c_index
                indexCounter=1
                count=0
                for element in column
                    if element!=0.0
                        count+=1
                    end
                end
                push!(height, count)
            end
            c_index+=1
            indexCounter+=1
        end
    end
    #println(height)
    return height # is a list of the heights[col-1, col, col+1]
end

for i in 1:n
    column= rand(1:L)
    MainArray=particle_falling(MainArray,column, L,color)
    if i%(10*200*color)==0
        color+=1
    end
end

heatmap(hcat(arr), c=cgrad(:roma, 10, categorical = true, scale = :exp), xlabel="L")
