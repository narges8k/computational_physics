using Plots
using Statistics
L=201
function BoundaryCondition(i)
    if i==L+1
        return 1
    elseif i==0
        return L
    else
        return i
    end
end
function height_cal(i,arr) #calculating the height of the layer in a column
    i=BoundaryCondition(i)
    row=L #starting from the top layer
    height=L
    for j in 1:L
        if arr[row,i]==0.0 #when the entry is empty
            height-=1 #decreasing height by one
            row-=1
        else
            break #exit the loop for the next column
        end
    end
    return height
end
function neighbor_checking(arr, col)
    h=[]
    for i in (col-1):1:(col+1)
        height= height_cal(i,arr)
        if i==col
            push!(h, (height+1))
        else
            push!(h, height)
        end
    end
    return maximum(h)
end
function width_cal(arr, L)
    firstx=0
    firsty=0
    col=1 #starting from the beggining
    for i in 1:L
        for row in 1:L
            if arr[row, col]!=0.0
                firstx=col
                firsty=row
                break
            end
        end
        if firstx!=0 && firsty!=0
            break
        else
            col+=1
        end
    end
    lastx=0
    lasty=0
    col=L #starting from the end
    for i in 1:L
        for row in 1:L
            if arr[row, col]!=0.0
                lastx=col
                lasty=row
                break
            end
        end
        if lastx!=0 && lasty!=0
            break
        else
            col-=1
        end
    end
    d=sqrt((firstx-lastx)^2 + (firsty-lasty)^2)
    return d
end
function deposing(L,n)
    WidthList=[]
    color=1
    arr=zeros((L,L))
    meanList=[]
    stdList=[]
    finalP=n
    for particle in 1:n
        col=rand(1:L)
        height=neighbor_checking(arr, col)
        if height>=L
            finalP=particle
            break
        end
        if height!=1 || col==ceil(Int, L/2)
            arr[height, col]=color
        end
        if particle%(10*200*color)==0
            color+=1
        end
        WidthNum=width_cal(arr, L)
        push!(WidthList, WidthNum)
    end
    return arr, WidthList, finalP
end
arr, WidthList, finalP=deposing(L,30000)
heatmap(hcat(arr), c=cgrad(:roma, 10, categorical = true, scale = :exp), xlabel="L")
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter3\\Fig\\3.4.png")
scatter(1:finalP, WidthList, xlabel="time",ylabel="width of the shrub" , markersize=0.001)
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter3\\Fig\\3.4_width.png")
