using Plots, Distributions, Statistics, LaTeXStrings

function SSMC(f :: Function , R :: Real, r :: Real, Θ :: Real, θ ::Real , N :: Integer)
    ΔR= R - r
    Δθ= Θ - θ
    dist=[ ΔR * rand(N) + R, Δθ * rand(N) + Θ ]
    f₍ₓ₎=[]
    for n in 1:N
        push!(f₍ₓ₎, f.(getindex(dist, n)...))
    end
    ∫f₍ₓ₎dx= mean(f₍ₓ₎)* ΔR * Δθ
    error= std(f₍ₓ₎)/sqrt(N)
    return ∫f₍ₓ₎dx, error
end
SSMC((r, θ) -> r^3 * sin(θ) * cos(θ) * (3 + r * cos(θ)), 1, 0 , π, 0, 10^6)
