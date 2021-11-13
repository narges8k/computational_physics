using Plots, LaTeXStrings, Statistics,  Distributions,StatsPlots, JLD

N=1000
σList=[0.5, 1, 5, 10, 20 ]
function GaussianD(σ, UniformD)
    x1=rand(UniformD, round(Int,N/2))
    x2=rand(UniformD, round(Int,N/2))
    ρ=σ * .√(2 * log.(1 ./ (1 .- x1)))
    θ=2π * x2
    y1=ρ.*cos.(θ)
    y2=ρ.*sin.(θ)
    return [y1 ; y2]
end
Data=[GaussianD(σList[i], rand(N)) for i in 1:5]
save("../../chapter6/6.4/samples.jld","Samples", Data)
plots=[]
colors=[:silver, :turquoise,:pink2,:mediumpurple3, :darkgoldenrod1]
for i in 1:length(σList)
    plt=begin
        histogram(Data[i],color=colors[i],normalize = true, label=L"Histogram\ of\ Samples", alpha=0.9)
        plot!(Normal(mean(Data[i]),std(Data[i])), c = :black, label= L"Normal(\mu = %$(round(mean(Data[i]),digits = 2)), \sigma = %$(round(std(Data[i]),digits = 2)))")
    end
    push!(plots, plt)
end
plot(plots..., size = (1000,1000), plot_title = "Normalized Distribution of Samples", dpi=600)
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter6\\6.4\\Figs\\N_Distribution.png")
