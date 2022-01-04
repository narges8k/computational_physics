module DiffSolving

    export EulerMethod

    using LaTeXStrings, Plots, ProgressBars, Statistics, StatsBase
    cd(dirname(@__FILE__))
    #First Order Differential Equation_Comparison between Euler method's and Numerical solution
    #RC Circuit
    cd(dirname(@__FILE__))
    function EulerMethod(func::Function, xᵢₙᵢₜ::Float64, tₘᵢₙ::Float64, tₘₐₓ::Float64, h::Float64)
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

end


