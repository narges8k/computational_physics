using Plots, Distributions, LaTeXStrings, Statistics

function Metropolois(p :: Function, steps :: Integer, dx :: Real, x₀ :: Real)
    success=0
    x= X₀
    xList=[i for i in 1:steps]
    for n in 1:steps
        xList[n]=x
        y= x + rand(Uniform(-dx, dx))
        if rand()< p(y)/p(x)
            x=y
            success+=1
        end
    end
end
Metropolis(, 10^6, 1, 0.0)
