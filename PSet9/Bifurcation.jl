using Plots, LaTeXStrings, ProgressBars
cd(dirname(@__FILE__))
function LogisticMap(x₀::Vector{Float64} , r::Float64, n::Real)
    x = x₀
    for i in 1:n
    x = 4 .* r .* x .* (1 .- x)
    end
    return x
end

####Part A####
r_s=collect(range(0.0, 1.0, step=10^(-4)))
x₀_s = rand(100)
x_s=zeros(length(r_s), length(x₀_s))

for (i,r) in enumerate(r_s)
    x_s[i,:]=LogisticMap(x₀_s, r, 10^4 )
end

scatter(r_s, x_s, legend=false, ms=0.5, color=:black, dpi=400, xlabel=L"r", ylabel=L"x", title=L"Logistic\ Map\ :\ x_n_+_1\ =\ 4rx_n(1-x_n)")
savefig("../../computational_physics/PSet9/Figs/Bifurcation.pdf")

####Part B####
####Zoomed Plot####
r_zoom= collect(range(0.70, 1.0, step=10^(-4)))
x₀_zoom = rand(range(0.70, 1.0, length=100), 100)
x_zoom=zeros(length(r_zoom), length(x₀_zoom))
for (i,r) in enumerate(r_zoom)
    x_zoom[i,:]=LogisticMap(x₀_zoom, r, 10^4 )
end
scatter(r_zoom, x_zoom, legend=false, ms=0.5, color=:black, dpi=400, xlabel=L"r", ylabel=L"x", 
    title=L"Logistic\ Map\ :\ x_n_+_1\ =\ 4rx_n(1-x_n),\ 0.7<r<1.0")
savefig("../../computational_physics/PSet9/Figs/Zoomed_Bifurcation.pdf")
####Part C####
####Feigenbaum constants#####

#### σ ####
rb= collect(range(0.85, 0.99, step=10^(-4)))
x₀=rand(range(0.88, 0.99, length=256), 256)
x=zeros(length(rb), length(x₀))
for (i,r) in ProgressBar(enumerate(rb))
    x[i,:]=LogisticMap(x₀, r, 10^4 )
end
x
dₙ₋₂_index = findfirst(i->length(unique(round.(x[i, :], digits=9))) == 4, 1:1401)
dₙ₋₁_index = findfirst(i->length(unique(round.(x[i, :], digits=9))) == 8, 1:1401)
dₙ_index = findfirst(i->length(unique(round.(x[i, :], digits=9))) == 16, 1:1401)
δ=(rb[dₙ₋₁_index]-rb[dₙ₋₂_index])/(rb[dₙ_index]-rb[dₙ₋₁_index])
# σ ∼ 5.0999
#### α ####
dₙ₊₁_index = findfirst(i->length(unique(round.(x[i, :], digits=9))) == 32, 1:1401)
rₙ₋₂_index = findfirst(i-> 1/2 ∈ unique(ceil.(x[i, :], digits=3)), dₙ₋₂_index:dₙ₋₁_index) + dₙ₋₂_index
rₙ₋₁_index = findfirst(i-> 1/2 ∈ unique(ceil.(x[i, :], digits=3)),dₙ₋₁_index:dₙ_index) + dₙ₋₁_index
rₙ_index = findfirst(i-> 1/2 ∈ unique(ceil.(x[i, :], digits=3)), dₙ_index:dₙ₊₁_index) + dₙ_index
xsₙ₋₂ = sort(unique(round.(x[rₙ₋₂_index, :], digits=3)))
xsₙ₋₁ = sort(unique(round.(x[rₙ₋₁_index, :], digits=3)))
xsₙ = sort(unique(round.(x[rₙ_index, :], digits=3)))
α = (xsₙ₋₁[2] - xsₙ₋₁[1] - (xsₙ₋₂[4]- xsₙ₋₂[3] ))/( xsₙ[2] - xsₙ[1] - (xsₙ₋₁[2] - xsₙ₋₁[1]))

