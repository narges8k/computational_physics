module MD

export Sim_process, initialize

using LaTeXStrings, Plots, Statistics 
#mutable struct -> instances of the composite types can be modified.
mutable struct MDSystem{FT<:AbstractFloat} #indicating that the newly declared abstract type is a subtype of this "parent" type. 
    step :: FT; L :: FT; Eᵤ :: FT; Eₖ :: FT; T :: FT; P :: FT
    N :: Integer
    r:: Matrix{FT}; v :: Matrix{FT}; F :: Matrix{FT}

    function MDSystem(N :: Integer, L :: FT, T₀ :: FT, step :: FT) where {FT<:AbstractFloat}
        r = rand(FT, N, 2) * L
        v = rand(FT, N, 2) .- 0.5
        v .-= mean(v, dims = 2) # This way the COM's velocity becomes zero => Temperature is no longer dependent on velocity
        v *= sqrt(2*T₀ / mean(v .^ 2))
        F = Matrix{FT}(undef, 2, N)
        return new{FT}(L, step, FT(NaN), FT(NaN), FT(NaN), FT(NaN), N, F, r, v)
    end
end

function initialize(N::Integer, T₀::FT, step::FT, L::FT) where {FT<:AbstractFloat}
    md = MDSystem(N, T₀, step, L)
    alignleft(md)
    for i in 1:md.N
        force_cal(md, i)
    end
    VelVerlet(md)
    Boundary_condition(md)
    Potential_cal(md)
    Kinetic_cal(md)
    Temprature_cal(md)
    Pressure_cal(md)
    return md
end

function Sim_process(md :: MDSystem)
    VelVerlet(md)
    Boundary_condition(md)
    Potential_cal(md)
    Kinetic_cal(md)
    Temprature_cal(md)
    Pressure_cal(md)
end
function Boundary_condition(md :: MDSystem)
    md.r = (md.r .+ md.L) .% md.L
end

function alignleft!(md::MDSystem) 
    xcount = ceil(Integer, (2 * md.N)^(1 / 2) / 2)
    ycount = 2 * xcount

    xs = collect(range(0.1 * md.L / 2, 0.9 * md.L / 2, length = xcount))
    md.r[1, :] .= repeat(xs, outer = ycount)[1:md.N]

    ys = collect(range(0.1 * md.L, 0.9 * md.L, length = ycount))
    md.r[2, :] .= repeat(ys, inner = xcount, outer = 1)[1:md.N]
end

function Potential_cal(md :: MDSystem)
    ΣΔr = 0.0
    for i in 1:md.N - 1
        for j in i+1:md.N
            rp = md.r[:, j]
            Δx = md.r[1, i] - rp[1]
            Δy = md.r[2, i] - rp[2]
            if Δx < -md.L / 2 
                rp[1] += md.L
            elseif Δy < -md.L / 2
                rp[2] += md.L
            elseif Δx > md.L / 2
                rp[1] -= md.L
            elseif Δy > md.L / 2
                rp[2] -= md.L
            end
            Δr = sqrt(sum(md.r[:, i] - rp) .^ 2)
            ΣΔr += (Δr ^ (-12) - Δr ^ (-6))
        end
    end
    md.Eᵤ = 4 * ΣΔr
end

function Force_cal(md :: MDSystem, i :: Integer)
    md.r[:, i] = 0.0
    for j in setdiff(1:md.N, i)
        rp = md.r[:, j]
        Δx = md.r[1, i] - rp[1]
        Δy = md.r[2, i] - rp[2]
        if Δx < -md.L / 2 
            rp[1] += md.L
        elseif Δy < -md.L / 2
            rp[2] += md.L
        elseif Δx > md.L / 2
            rp[1] -= md.L
        elseif Δy > md.L / 2
            rp[2] -= md.L
        end
        Δr = sqrt(sum(md.r[:, i] - rp) .^ 2)
        md.f[:, i] += 48 * (((Δr)^-14) - 0.5 * ((Δr)^-8)) * (md.r[:, i] - rp)
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

function Kinetic_cal(md :: MDSystem)
    md.Eₖ = sum(md.v .^2) / 2 #kinetic Energy per molecule
end

function Temprature_cal(md :: MDSystem)
    md.T = md.Eₖ / md.N
end

function Pressure_cal(md :: MDSystem)
    Σrterm = 0.0
    Σvᵢ² = sum(md.v .^2)
    for i in 1:md.N - 1
        for j in i+1:md.N
            rp = md.r[:, j]
            Δx = md.r[1, i] - rp[1]
            Δy = md.r[2, i] - rp[2]
            if Δx < -md.L / 2 
                rp[1] += md.L
            elseif Δy < -md.L / 2
                rp[2] += md.L
            elseif Δx > md.L / 2
                rp[1] -= md.L
            elseif Δy > md.L / 2
                rp[2] -= md.L
            end
            Δr = sqrt(sum(md.r[:, i] - rp) .^ 2)
            Σrterm += (Δr ^ (-12) - 1/2 *Δr ^ (-6))
        end
    end
    md.p = (Σvᵢ² + 48 * Σrterm)/(2 * md.L * md.L)
end

end
