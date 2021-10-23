using Plots, LaTeXStrings, JLD, Statistics
TotalTime=1000
probability=[0.25,0.5,0.75,0.95]
function RandomWalk(TotalTime, probability)
    arr=zeros((TotalTime,length(probability)))
    for i in 1:TotalTime
        for j in 1:length(probability)
            if p>rand()
                arr[i,j]=1
            else
                arr[i,j]=-1
            end
        end
    end
    return cumsum(arr,dims=1)
end
run_num=100
RandomWalkers=[[[] for j in 1:TotalTime] for i in 1:length(probability)]
for n in 1:run_num
    col_num=1
    for col in eachcol(RandomWalk(TotalTime, probability))
        for i in 1:length(col)
            push!(RandomWalkers[col_num][i],RandomWalk(TotalTime, probability)[i,col_num])
        end
        col_num+=1
    end
end
