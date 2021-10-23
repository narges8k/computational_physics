using Plots, LaTeXStrings, JLD, Statistics
time_step=200
probability=[0.25,0.5,0.75]
arr=zeros((time_step,length(probability)))
for i in 1:time_step
    for j in 1:length(probability)
        if p>rand()
            arr[i,j]=1
        else
            arr[i,j]=-1
        end
    end
end
cumsum(arr,dims=1)
