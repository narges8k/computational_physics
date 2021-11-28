using Plots, Distributions, LaTeXStrings, Statistics, StatsPlots, JLD, ProgressBars

function Metropolis(p :: Function, steps :: Integer, dx :: Real, X₀ :: Real)
    success=0
    x= X₀
    xList=Float64[i for i in 1:steps]
    n=0
    for n in 1:steps
        xList[n]=x
        y= x + rand(Uniform(-dx, dx))
        if rand()< p(y)/p(x)
            x=y
            success+=1
        end
    end
    return xList, success/steps
end

#histogram
xList, successful_steps=Metropolis(x -> ℯ^(-x^2/2), 10^5, 3 , 0.0)
save("../../chapter8/8.1/HistoData.jld","xList", xList, "SuccessfulSteps", successful_steps)
histogram(xList, normalize=true, alpha=0.7, label="Normal line")
plot!(Normal(0,1), ylabel="Probability Density", xlabel="x",
    title=L"Guassian\ Distribution\ for\ 100000\ steps\ and\ a_r=%$successful_steps", label="Metropolis Series", dpi=600)
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter8\\HistoPlot.png")
#acceptence rate per unit length
N=100
stepsList= range(0.1, 50, length=N)
aᵣData=[]
for n in ProgressBar(1:N)
    xList, successful_steps=Metropolis(x -> ℯ^(-x^2/2), 10^5, stepsList[n] , 0.0)
    push!(aᵣData, successful_steps)
end
plot(stepsList,aᵣData , xlabel=L"dx", ylabel=L"a_r(dx)", title="Acceptance per Length of Steps", label=nothing, dpi=600)
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter8\\acceptance_ratio.png")
