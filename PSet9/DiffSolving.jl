module DiffSolving

export EulerMethod

using LaTeXStrings, Plots, ProgressBars, Statistics, StatsBase
cd(dirname(@__FILE__))
#First Order Differential Equation_Comparison between Euler method's and Numerical solution
#RC Circuit
function EulerMethod(func::Function, xᵢₙᵢₜ::Float64, tₘᵢₙ::Float64, tₘₐₓ::Float64, h::Float64)
    t_range=collect(range(tₘᵢₙ, tₘₐₓ, step=h))
    Q=zeros(length(t_range))
    Q[1]=xᵢₙᵢₜ

    for (i,t) in enumerate(t_range[1:end-1])
        Q[i+1] = Q[i] + func(t,Q[i])*h
    end
    return t_range, Q
end

function InstableAlgorithm(func::Function, xᵢₙᵢₜ::Float64, tₘᵢₙ::Float64, tₘₐₓ::Float64, h::Float64 )
    t_range=collect(range(tₘᵢₙ, tₘₐₓ, step=h))
    Q=zeros(length(t_range))

    Q[1]=xᵢₙᵢₜ
    Q[2]=xᵢₙᵢₜ + h*func(tₘᵢₙ, xᵢₙᵢₜ )
    for i in 2:length(t_range)-1
        Q[i+1] = Q[i-1] + 2*h*func(t_range[i], Q[i])
    end
    return t_range, Q
end

end


