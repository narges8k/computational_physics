using Plots
using CircularArrays
n=30000 #the number of particles
L=200 #Length of the line
color=1 #used for color-change
CircularCols=CircularArray(zeros(200)) #it makes a circular array for the columns
MainArray=[CircularCols for i in 1:200] #it makes the whole systems scheme
function particle_falling(MainArray, col, color) #this function operates falling of the particle
    row=height_checker(MainArray, col)+1
    MainArray[row][col]=count
    return MainArray
end
function height_checker(MainArray, col) #comparing the hight of the column the particle exists in, with its neighbors
    hight=height_calculater(MainArray, col)
    if height[1]<height[2] && height[3]<height[2] #if it's own column is higher than others, there will be no holes.
        the_row_num=hight[2]
    end
    if height[2]<height[1] || height[2]<height[3] #the other two neighbors' hights are higher.
        if height[1]==height[3]
            the_row_num=rand(height[1], height[3])
        end
        if height[1]!=height[3]
            the_row_num=max(height[1], height[3]) #if the two neighbors have equall hights, then the maximum hight will be chosen.
        end
    end
    return the_row_num
end

function height_calculater(MainArray, col) #This function calculates the hight of the three columns we must know.
    height=[]
    for i in MainArray
        for j in i
            count=0
            if i==(col-1)
                for element in i
                    if element!=0.0
                        count+=1
                    end
                end
                push!(height, count)
            end
            count=0
            if i==col
                for element in i
                    if element!=0.0
                        count+=1
                    end
                end
                push!(height, count)
            end
            count=0
            if i==(col+1)
                for element in i
                    if element!=0.0
                        count+=1
                    end
                end
                push!(height, count)
            end
        end
    end
    return height #hight is a list of the hights[col-1, col, col+1]
end

for i in 1:n
    column= rand(1:L)
    MainArray=particle_falling(MainArray,column,color)
    if i%(10*200*color)==0
        color+=1
    end
end
