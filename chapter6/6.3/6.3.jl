using Plots, LaTeXStrings, Statistics,  Distributions,StatsPlots, JLD
TotalNum=10000
NList=[5,10,100,1000]
Data=[[] for i in 1:length(NList)]
for N in 1:length(NList)
    for i in 1:TotalNum
        push!(Data[N], sum(rand(NList[N])))
    end
end
plots=[]
colors=[:silver, :lightblue,:pink2,:mediumpurple3]
for i in 1:length(NList)
    plt=begin
        histogram(Data[i],color=colors[i],normalize = true, label=L"Histogram\ of\ Samples", alpha=0.9)
        plot!(Normal(mean(Data[i]),std(Data[i])), c = :black, label= L"Normal(\mu = %$(round(mean(Data[i]),digits = 2)), \sigma = %$(round(std(Data[i]),digits = 2)))")
    end
    push!(plots, plt)
end
plot(plots..., size = (1000,1000), plot_title = "Normalized Distribution of Samples", dpi=600)
save("../../chapter6/6.3/samples.jld","Samples", Data)
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter6\\6.3\\Figs\\N_Distribution.png")
