using LaTeXStrings, Plots, ProgressBars, Statistics, StatsBase
#First Order Differential Equation
#RC
cd(dirname(@__FILE__))
function EulerSolving(func::Function, xᵢₙᵢₜ::Float64, tₘᵢₙ::Float64, tₘₐₓ::Float64, h::Float64)
    t_range=collect(range(tₘᵢₙ, tₘₐₓ, step=h))
    Q=zeros(length(t_range))
    Q[1]=xᵢₙᵢₜ

    x=xᵢₙᵢₜ
    for (i,t) in enumerate(t_range[1:end-1])
        x += func(t,x)*h
        Q[i+1] = x
    end
    return t_range, Q
end
##Plots
rc=1.0; tₘᵢₙ=0.0; tₘₐₓ=5.0; Δt=0.01; q₀=1.0; xᵢₙᵢₜ = 0.0
t_range, Q=EulerSolving((t,x)->(q₀ .- x )/rc, xᵢₙᵢₜ, tₘᵢₙ, tₘₐₓ, Δt)
plot(t_range, Q,label="Euler Method",ylabel=L"Q(t)",xlabel="t(s)",title=L"\Delta t=0.01s", dpi=400, color=:orchid4, linewidth=3)
plot!(t -> q₀ *(1 - exp(-t/rc)), label="Numerical Solution", linewidth=3, color=:pink1, linestyle=:dash, legend=:bottomright)
savefig("../../PSet9/Euler_diff_eq_solving_method/Figs/Euler_compare.pdf")

