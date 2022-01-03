using LaTeXStrings, Plots, ProgressBars, Statistics, StatsBase
function f(x)
    return -x
end

function euler(τ, xᵢₙᵢₜ, h)
    count=length(collect(range(0, τ, step=h)))
    x=zeros(count)
    x[0]=xᵢₙᵢₜ
    for n in 1:count
        x[n+1]=x[n]+ f(x[n])*h
    end
return x, count



