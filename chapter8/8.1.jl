using Plots, Distributions, LaTeXStrings, Statistics, StatsPlots, JLD, ProgressBars, StatsBase

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
#C(j)_j plot
stepsList=[15.9, 7.95, 5.27, 3.88, 2.94, 2.2, 1.57, 1.03, 0.5]
aᵣList=[0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]
CⱼList=[]
for n in ProgressBar(1:9)
    xList, successful_steps=Metropolis(x -> ℯ^(-x^2/2), 10^5, stepsList[n] , 0.0)
    push!(CⱼList, autocor(xList))
end
save("../../chapter8/8.1/CjList.jld","CjList",CⱼList)
selectedNums=[1, 3, 6, 9 ]

plot()
for i in selectedNums
    plot!(1:length(CⱼList[i]), CⱼList[i], linewidth=3, label=L"a_r\ =\ %$(aᵣList[i])")
end
plot!(ylabe="Cⱼ", xlabel="j", title=L"C_j \_\ j", dpi=600)
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter8\\Cj_j.png")
#length correlation
logCl=[]
ξList=Float64[]
x=[i for i in 1:10]
for i in CⱼList
    push!(logCl,log.(i[1:10]))
end
hcat(x, ones(10))
for y in logCl
    ξ⁽⁻¹⁾, Const= hcat(x, ones(10)) \ y
    ξ= -1/ξ⁽⁻¹⁾
    push!(ξList, ξ)
end
plot(aᵣList, ξList, title="Correlation Length", xlabel=L"a_r", ylabel=L"\xi", label=nothing)
scatter!(aᵣList, ξList, dpi=600, label=nothing)
save("../../chapter8/8.1/xiList.jld","ξList",ξList)
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter8\\correlationLength.png")
