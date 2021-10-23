using Plots, LaTeXStrings, JLD, Statistics
TotalTime=20
probability=[0.25,0.5,0.75,0.95]
function RandomWalk(TotalTime, probability)
    arr=zeros((TotalTime,length(probability)))
    for j in 1:length(probability)
        for i in 1:TotalTime
            if probability[j]>rand()
                arr[i,j]=1
            else
                arr[i,j]=-1
            end
        end
    end
    PosPerTime=cumsum(arr,dims=1)
    for cartesianIndex in findall(x->x>10, PosPerTime)
            PosPerTime[cartesianIndex[1], cartesianIndex[2]]=10
    end
    for cartesianIndex in findall(x->x<-10, PosPerTime)
            PosPerTime[cartesianIndex[1], cartesianIndex[2]]=-10
    end
    return PosPerTime
end
TheMatrix=RandomWalk(TotalTime, probability)
