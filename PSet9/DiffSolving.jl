module DiffSolving

export EulerMethod, InstableAlgorithm, EulerCromer, Verlet, VelocityVerlet

using LaTeXStrings, Plots, ProgressBars, Statistics, StatsBase
cd(dirname(@__FILE__))
#First Order ODE_Comparison between Euler method's and Numerical solution

function EulerMethod(func::Function, xᵢₙᵢₜ::Vector{Float64}, tₘᵢₙ::Float64, tₘₐₓ::Float64, h::Float64)
    t_range=collect(range(tₘᵢₙ, tₘₐₓ, step=h))
    Q=zeros(length(t_range), length(xᵢₙᵢₜ))
    Q[1, :]=xᵢₙᵢₜ

    for (i,t) in enumerate(t_range[1:end-1])
        Q[i+1, :] = Q[i, :] + func(t,Q[i, :])*h
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

#Second Order ODE
#Simple Harmonic Oscillator
xᵢₙᵢₜ , vᵢₙᵢₜ= 1.0, 0.0; step=0.1;  n=2; tₘᵢₙ=0.0; tₘₐₓ=round(2π * n); h=0.5
function EulerCromer(func::Function, xᵢₙᵢₜ::Float64, vᵢₙᵢₜ::Float64, tₘᵢₙ::Float64, tₘₐₓ::Float64, h::Float64)
    t=collect(range(tₘᵢₙ, tₘₐₓ, step=h))
    x=zeros(length(t))
    v=zeros(length(t))

    v[1]= vᵢₙᵢₜ
    x[1]= xᵢₙᵢₜ
    for i in 1:length(t)-1
        v[i+1] = v[i] + h * func(t[i], x[i])
        x[i+1] = x[i] + h * v[i+1]
    end
    
    return t, x, v
end
t_EC, x_EC, v_EC = DiffSolving.EulerCromer((t,x)-> -x, 0.0, 1.0, tₘᵢₙ, tₘₐₓ, h)
xᵢₙᵢₜ , vᵢₙᵢₜ= 1.0, 0.0; step=0.1;  n=2; tₘᵢₙ=0.0; tₘₐₓ=round(2π * n); h=0.5
function Verlet(func::Function, xᵢₙᵢₜ::Float64, vᵢₙᵢₜ::Float64, tₘᵢₙ::Float64, tₘₐₓ::Float64, h::Float64)
    t=collect(range(tₘᵢₙ, tₘₐₓ, step=h))
    x=zeros(length(t))
    v=zeros(length(t))

    v[1]= vᵢₙᵢₜ
    x[1]= xᵢₙᵢₜ
    x[2]= xᵢₙᵢₜ + vᵢₙᵢₜ * h + func(tₘᵢₙ, xᵢₙᵢₜ ) * h^2 *1/2

    for i in 2: length(t)-1
        x[i+1]= 2 * x[i] - x[i-1] + func(t[i], x[i]) * h^2
        v[i+1]= (x[i+1] - x[i])/h
    end
    return t, x, v
end
t_V, x_V, v_V = DiffSolving.Verlet((t,x)-> -x, 0.0, 1.0, tₘᵢₙ, tₘₐₓ, h)

function VelocityVerlet(func::Function, xᵢₙᵢₜ::Float64, vᵢₙᵢₜ::Float64, tₘᵢₙ::Float64, tₘₐₓ::Float64, h::Float64)
    t= collect(range(tₘᵢₙ, tₘₐₓ, step=h))
    x=zeros(length(t))
    v=zeros(length(t))

    v[1]= vᵢₙᵢₜ
    x[1]= xᵢₙᵢₜ

    for i in 2:length(t)-1
        x[i+1] = x[i] + v[i] * h + 1/2 * func(t[i], x[i]) * h^2
        v[i+1] = v[i] + 1/2 * (func(t[i], x[i]) + func(t[i+1], x[i+1])) * h
    end
    
    return t, x, v
end

end