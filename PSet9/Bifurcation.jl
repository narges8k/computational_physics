using Plots, LaTeXStrings
cd(dirname(@__FILE__))
function LogisticMap(x₀::Vector{Float64} , r::Float64, n::Real)
    x = x₀
    for i in 1:n
    x = 4 .* r .* x .* (1 .- x)
    end
    return x
end
r_s=collect(range(0.0, 1.0, step=10^(-4)))
x₀_s = rand(100)
x_s=zeros(length(r_s), length(x₀_s))
for (i,r) in enumerate(r_s)
    x_s[i,:]=LogisticMap(x₀_s, r, 10^4 )
end
scatter(r_s, x_s, legend=false, ms=0.5, color=:black, dpi=400, xlabel=L"r", ylabel=L"x", title=L"Logistic\ Map\ :\ x_n_+_1\ =\ 4rx_n(1-x_n)")
savefig("../../computational_physics/PSet9/Figs/Bifurcation.pdf")