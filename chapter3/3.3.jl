using Plots
using Statistics
using ProgressBars
L=100
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
function mean_calculater(arr,L)
    h=[]
    for i in 1:L
        i=BoundaryCondition(i)
        height= height_cal(i,arr)
        push!(h, height)
    end
    return mean(h)
end
function deposing(L,n)
    arr=zeros((L, L))
    meanList=[]
    color=1
    finalP=n
    anim = Animation()
    for particle in ProgressBar(1:n)
        col=rand(1:L)
        height=neighbor_checking(arr, col)
        if height>=L
            finalP=particle
            break
        end
        arr[height, col]=color
        if particle%(10*L*color)==0
            color+=1
        end
        #meanNum=mean_calculater(arr,L)
        #push!(meanList, meanNum)
        p = heatmap(hcat(arr), c=cgrad(:roma, 10, categorical = true, scale = :exp), xlabel="L")
        frame(anim, p)
    end
    gif(anim,"C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter3\\Fig\\3.3.gif",fps=70)
    return arr, meanList, finalP
end
arr,meanList, finalP=deposing(L,15000)
heatmap(hcat(arr), c=cgrad(:roma, 10, categorical = true, scale = :exp), xlabel="L")
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter3\\Fig\\3.3_1.png")
scatter(1:finalP-1,meanList, xlabel="time", ylabel="mean height of the layer")
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter3\\Fig\\3.3_2.png")
