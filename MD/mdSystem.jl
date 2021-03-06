
using Plots, Statistics, StatsBase, LaTeXStrings, JLD, ProgressBars
#mutable struct -> instances of the composite types can be modified.
mutable struct MDSystem{FT<:AbstractFloat}
    L::FT
    step::FT
    Eᵤ::FT
    Eₖ::FT
    T::FT
    P::FT
    N::Integer
    F::Matrix{FT}
    r::Matrix{FT}
    v::Matrix{FT}
    function MDSystem(N::Integer, T₀::FT, step::FT, L::FT) where {FT<:AbstractFloat}
        r = rand(FT, 2, N) * L
        v = rand(FT, 2, N) .- 0.5
        v *= sqrt((T₀ ÷ mean(v .^ 2)))
        F = Matrix{FT}(undef, 2, N)
        return new{FT}(L, step, FT(NaN), FT(NaN), FT(NaN), FT(NaN), N, F, r, v)
    end
end

function Initialize(N::Integer,L::FT, T₀::FT, step::FT) where {FT<:AbstractFloat}
    md = MDSystem(N,  T₀, step, L)
    alignleft(md)
    for i in 1:md.N
        Force_cal(md, i)
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

function alignleft(md::MDSystem) 
    xcount = ceil(Integer, (2 * md.N)^(1 / 2) / 2)
    ycount = 2 * xcount

    xs = collect(range(0.1 * md.L / 2, 0.9 * md.L / 2, length = xcount))
    md.r[1, :] .= repeat(xs, outer = ycount)[1:md.N]

    ys = collect(range(0.1 * md.L, 0.9 * md.L, length = ycount))
    md.r[2, :] .= repeat(ys, inner = xcount, outer = 1)[1:md.N]
end

function Force_cal(md :: MDSystem, i :: Integer)
    md.F[:, i] *= 0
    for j in setdiff(1:md.N, i)
        rp = md.r[:, j]
        Δx = md.r[1, i] - rp[1]
        Δy = md.r[2, i] - rp[2]
        if Δx < -md.L / 2 
            rp[1] -= md.L
        elseif Δx > md.L / 2
            rp[1] += md.L
        end
        if Δy < -md.L / 2
            rp[2] -= md.L
        elseif Δy > md.L / 2
            rp[2] += md.L
        end
        Δr = sqrt(sum((md.r[:, i] - rp) .^ 2))
        md.F[:, i] += 48 * (((Δr)^-14) - 0.5 * ((Δr)^-8)) * (md.r[:, i] - rp)
    end
end

function VelVerlet(md :: MDSystem)
    for i in 1:md.N
        a₁ = md.F[:, i]
        md.r[:, i] += md.step * md.v[:, i] + 1/2 * md.step  * md.step * a₁
        Force_cal(md, i)
        a₂ = md.F[:, i]
        md.v[:, i] += md.step * (a₁ + a₂) / 2
    end
end

function Boundary_condition(md :: MDSystem)
    md.r = (md.r .+ md.L) .% md.L
end

function Potential_cal(md :: MDSystem)
    ΣΔr = 0.0
    for i in 1:(md.N - 1)
        for j in (i+1):md.N
            rp = md.r[:, j]
            Δx = md.r[1, i] - rp[1]
            Δy = md.r[2, i] - rp[2]
            if Δx < -md.L / 2 
                rp[1] -= md.L
            elseif Δx > md.L / 2
                rp[1] += md.L
            end
            if Δy < -md.L / 2
                rp[2] -= md.L
            elseif Δy > md.L / 2
                rp[2] += md.L
            end
            Δr = sqrt(sum((md.r[:, i] - rp) .^ 2))
            ΣΔr += ((Δr) ^ (-12)) - ((Δr) ^ (-6))
        end
    end
    md.Eᵤ = 4 * ΣΔr
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
    for i in 1:(md.N-1)
        for j in (i+1):md.N
            rp = md.r[:, j]
            Δx = md.r[1, i] - rp[1]
            Δy = md.r[2, i] - rp[2]
            if Δx < -md.L / 2 
                rp[1] -= md.L
            elseif Δx > md.L / 2
                rp[1] += md.L
            end
            if Δy < -md.L / 2
                rp[2] -= md.L
            elseif Δy > md.L / 2
                rp[2] += md.L
            end
            Δr = sqrt(sum(md.r[:, i] - rp) .^ 2)
            Σrterm += ((Δr) ^ (-12)) - (1/2) * ((Δr) ^ (-6))
        end
    end
    md.P = (Σvᵢ² + 48 * Σrterm)/(2 * md.L * md.L)
end


N = 100; T₀ = 1.0; h = 0.001; L = 50.0; step_num = 20000
md = Initialize(N, L, T₀ , h)

Poses = zeros(step_num, 2, N)
Velocities = zeros(step_num, 2, N)
Potentials = zeros(step_num)
Kinetics = zeros(step_num)
Temps = zeros(step_num)
pressures = zeros(step_num)

for i in ProgressBar(1:step_num)
    Sim_process(md)
    Poses[i, :, :] = md.r
    Velocities[i, :, :] = md.v
    Potentials[i] = md.Eᵤ
    Kinetics[i] = md.Eₖ
    Temps[i] = md.T
    pressures[i] = md.P
end
Poses
save("../../MD/SingleData.jld",
    "Poses", Poses, "Velocities", Velocities, "Potentials", Potentials, 
    "Kinetics", Kinetics, "Temps", Temps, "Pressures", pressures)

plot(collect(0:h:(h*step_num))[1:20000], [count(<=(md.L / 2), Poses[i, 1, :]) / md.N for i ∈ 1:step_num][1:20000],
    ylabel=L"N_l_e_f_t/N", xlabel=L"t/\tau", dpi=400, title=L"Molecules'\ Densities\ at\ the\ left\ half", legend=false)
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\MD\\Figs\\LeftHalfDensity.png")

plot(collect(0:h:(h*step_num))[1:2000],Kinetics[1:2000], label = L"E_k")
plot!(collect(0:h:(h*step_num))[1:2000],Potentials[1:2000], label = L"E_U")
plot!(collect(0:h:(h*step_num))[1:2000],Potentials[1:2000]+Kinetics[1:2000], label = L"E_t_o_t_a_l"
    , title = L"Enery\ of\ the\ System",dpi = 400)
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\MD\\Figs\\Energies.png")


plot(collect(0:h:(h*step_num))[1:20000],120*Temps[1:20000], label = L"Temprature", title=L"Temprature\ of\ the\ System")
plot!([0.0, 20.0], 120 * [mean(Temps[10000:end]), mean(Temps[10000:end])],
    label = L"\langle T_{eq} \rangle = %$(round(120 * mean(Temps[10000:end]), digits = 3))")
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\MD\\Figs\\Temprature.png")   