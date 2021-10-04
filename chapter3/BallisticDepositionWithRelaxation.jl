using Plots
using CircularArrays
n=30000
L=200
CircularCols=CircularArray(zeros(200))
MainArray=[CircularCols for i in 1:200]
function particle_falling(MainArray,col,count)
    row=1
    for j in 1:L
        if MainArray[j][col]==0.0
            MainArray[j][col]=count
            break
        else
            row+=1
        end
    end
    if i%(10*200*count)==0
        count+=1
    end
    return MainArray
end
function hight_calculater(MainArray, col) #This function calculates the hight of the three columns we must know.
    for i in MainArray
        hight=[]
        for j in i
            count=0
            if i==(col-1)
                for element in i
                    if element!=0.0
                        count+=1
                    end
                end
                push!(hight, count)
            end
            count=0
            if i==col
                for element in i
                    if element!=0.0
                        count+=1
                    end
                end
                push!(hight, count)
            end
            count=0
            if i==(col+1)
                for element in i
                    if element!=0.0
                        count+=1
                    end
                end
                push!(hight, count)
            end
        end
    end
    return hight #hight is a list of the hights[col-1, col, col+1]
end

function hight_checker(MainArray, col)
    hight=hight_calculater(MainArray, col)
    if hight[2]<hight[1] && hight[2]<hight[3]
        MainArray=particle_falling(MainArray, hight[2],1)
    end
    if hight[2]> hight[1] || hight[2]>hight[1]
        if hight[1]!= hight[3]
            MainArray=particle_falling(MainArray, min(hight[1],hight[3]),1)
        end
        if hight[1]== hight[3]
            MainArray=particle_falling(MainArray, rand(hight[1], hight[3]),1)
        end
    end
    return MainArray
end
for i in 1:n
    column=rand(1:L)
    MainArray=hight_checker(MainArray, column) #first we check which column is best to fall into, then which row, and then we have our new MainArray after each fall.
end


# println(B[1][6])
# println(B[2][7])
# for i in B
#     for j in i
#         B[j][6]=10
#         println(B[j][6])
#     end
# end
