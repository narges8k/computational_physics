module MD
using LaTeXStrings, Plots, Statistics 
#mutable struct -> instances of the composite types can be modified.
mutable struct MDStystem{FT<:AbstractFloat} #indicating that the newly declared abstract type is a subtype of this "parent" type. 
    step ::FT; L :: FT; U :: FT; K :: FT; T :: FT; P :: FT
    N :: Integer
    r:: Matrix{FT}; v :: Matrix{FT}; F :: Matrix{FT}

    function MDSystem(N :: Integer, L :: FT, T₀ :: FT, Δt :: FT)
        r = rand(FT, N, 2) * L
        v = rand(FT, N, 2) .- 0.5
        v .-= mean(v, dims = 2) # This way the COM's velocity becomes zero -> Temperature is no longer dependent on velocity
        v *= sqrt(2*T₀ / mean(v .^ 2))
        F = Matrix{FT}(undef, 2, N)
        return new{DT}(l, h, DT(NaN), DT(NaN), DT(NaN), DT(NaN), N, f, r, v)
    end
end
function initialize(md :: MDSystem)

end

function alignleft!(md::MDSystem) 
    xcount = ceil(Integer, (2 * md.N)^(1 / 2) / 2)
    ycount = 2 * xcount

    xs = collect(range(0.1 * md.l / 2, 0.9 * md.l / 2, length = xcount))
    md.r[1, :] .= repeat(xs, outer = ycount)[1:md.N]

    ys = collect(range(0.1 * md.l, 0.9 * md.l, length = ycount))
    md.r[2, :] .= repeat(ys, inner = xcount, outer = 1)[1:md.N]
end

function force_cal(md :: MDStystem, i :: Integer)
    for j in 1:md.N
        Δx = md.r[1, i] - md.r[1, j]
        Δy = md.r[2, i] - md.r[2, j]
        if Δx < -md.L / 2 
            md.r[1, j] += md.L
        elseif Δy < -md.L / 2
            md.r[2, j] -= md.L
        elseif Δx > md.L / 2
            md.r[1, j] += md.L
        elseif Δy > md.L / 2
            md.r[2, j] -= md.L
        end
        Δr = sqrt(sum(md.r[:, i] - md.r[:, j]) .^ 2)
        md.f[:, i] += 48 * (((Δr)^-14) - 0.5 * ((Δr)^-8)) * (md.r[:, i] - md.r[:, j])
    end
end

function VelVerlet(md :: MDSystem)
    for i in 1:md.N
        a₁ = md.f[:, i]
        md.r[:, i] += md.step * (md.v[:, i] + md.step / 2 * a₁)
        force_cal(md, i)
        a₂ = md.f[:, i]
        md.v[:, i] += md.step / 2 * (a₁ + a₂)
    end
end

end
