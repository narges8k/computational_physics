using Plots, Distributions, Statistics, LaTeXStrings, ProgressBars, StatsBase, JLD

function SSMC(f :: Function , R :: Real, r :: Real, Θ :: Real, θ ::Real , N :: Integer)
    ΔR= R - r
    Δθ= Θ - θ
    dist=[ ΔR .* rand(N) .+ r, Δθ .* rand(N) .+ θ ]
    f₍ₓ₎=[]
    for n in 1:N
        push!(f₍ₓ₎, f(getindex.(dist, n)...))
    end
    ∫f₍ₓ₎dx= mean(f₍ₓ₎)* ΔR * Δθ
    error= std(f₍ₓ₎)/sqrt(N)
    return ∫f₍ₓ₎dx, error
end

samples=10^4
ErrorList=[]
IntegralRes=[]
for i in ProgressBar(1:samples)
    I, E=SSMC((r, θ) -> r^3 * sin(θ) * cos(θ) * (3 + r * cos(θ)), 1, 0 , π, 0, 10^5)
    push!(IntegralRes, I)
    push!(ErrorList, E)
end
histogram(IntegralRes, dpi=600, ylabel="Probability Density", xlabel="I",
    title="The Distribution of I's Results")
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter7\\7.2\\Figs\\IHistogram.png")
histogram(ErrorList, dpi=600,xlabel="Probability Density", ylabel="Error",
    title="The Distribution of Errors")
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter7\\7.2\\Figs\\EHistogram.png")
save("../../chapter7/7.2/data.jld","Idata",IntegralRes, "Edata", ErrorList )
