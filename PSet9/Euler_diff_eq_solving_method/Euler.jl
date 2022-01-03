using LaTeXStrings, Plots, ProgressBars, Statistics, StatsBase
#First Order Differential Equation
#RC
function EulerSolving(func::Function, xᵢₙᵢₜ::Float64, tᵢₙᵢₜ::Float64, tₛ::Float64, h::Float64=0.01)
    tₐₗₗ=collect(range(tᵢₙᵢₜ, tₛ, step=h))
    Q=zeros(length(tₐₗₗ))
    Q[1]=xᵢₙᵢₜ

    x=xᵢₙᵢₜ
    for (i,t) in enumerate(tₐₗₗ[1:end])
        x += func(t,x)*h
        Q[i+1] = x
    end
    return tₐₗₗ, Q
end
##Plots
