using Plots, LaTeXStrings, JLD, Statistics
TotalTime=20
probability=[0.25,0.5,0.75,0.95]
function RandomWalk(TotalTime, probability)
    arr=zeros((TotalTime,length(probability)))
    #starting at random postions:
    for i in 1:length(probability)
        arr[1, i]=rand(1:10)
    end
    #filling the other entries with 1 and -1 with the given probabilities:
    for j in 1:length(probability)
        for i in 2:TotalTime
            if probability[j]>rand()
                arr[i,j]=1
            else
                arr[i,j]=-1
            end
        end
    end
    PosPerTime=cumsum(arr,dims=1)
    #stoping the random walker when reachin the boundaries(-10 or 10):
    for cartesianIndex in findall(x->x>10, PosPerTime)
            PosPerTime[cartesianIndex[1], cartesianIndex[2]]=10
    end
    for cartesianIndex in findall(x->x<-10, PosPerTime)
            PosPerTime[cartesianIndex[1], cartesianIndex[2]]=-10
    end
    return PosPerTime
end
TheMatrix=RandomWalk(TotalTime, probability)
