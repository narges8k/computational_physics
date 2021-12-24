using Plots, LaTeXStrings, Statistics, StatsPlots, JLD, ProgressBars, StatsBase, Ranges

function FindEnergy(System::Matrix{Int8}, dim::Integer)
    E = 0.0
    for i ∈ 1:dim
        for j ∈ 1:dim
            Neighbors = [[1 + i % dim, j], [i, 1 + j % dim], [(-2 + i + dim) % dim + 1, j], [i, (-2 + j + dim) % dim + 1]]
            E += -sum(System[i, j] * System[Neighbors]) / 2
        end
    end
    return E / dim^2
end

function DE(System::Matrix{Int8}, i::Integer, j::Integer)
    Neighbors = [[1 + i % dim, j], [i, 1 + j % dim], [(-2 + i + dim) % dim + 1, j], [i, (-2 + j + dim) % dim + 1]]
    return system[i, j] * sum(System[CartesianIndex.(Tuple.(Neighbors))])
end

function MC(System::Matrix{Int8}, dim::Integer, N::Integer, β::Real)
    ΔE_sum = 0
    ΔM_sum = 0
    for _ = 1:N
        i = rand(1:dim)
        j = rand(1:dim)
        System[i, j] = spin
        ΔE = DE(System, i, j)
        if ΔE <= 0 || rand() < exp(-ΔE * β)
            System[i, j] = -spin
            ΔE_sum += ΔE
            ΔM_sum += 2 * (-spin)
        end
    end
    return System, ΔE_sum, ΔM_sum
end

function ising2d(dim::Integer, β::Real, MCS::Real, N::Integer)
    System = rand([Int8(-1), Int8(1)], dim, dim)

    Eᵢ = FindEnergy(system, dim)
    Mᵢ = mean(System)
    M_list = [Eᵢ]
    E_list = [Mᵢ]
    for ـ = 1:MCS
        System, ΔE, ΔM = MC(System, dim, N, β)
        E = E_list[end] + ΔE
        M = M_list[end] + ΔM
        push!(E_list, E)
        push!(M_list, M)
    end
    return mean(E_list), mean(M_list), β^2 * var(E_list[ceil(Int64, MCS / 5):end]) * dim^2, β * var(E_list[ceil(Int64, MCS / 5):end])
end

#Initials
dim = 4
β_list = range(0.1, 0.9, 80)

E_list = []
M_list = []
C_list = []
χ_list = []

for β in β_list
    E, M, C, χ = ising2d(dim, β, 1000, 100)
    push!(E_list, E)
    push!(M_list, M)
    push!(C_list, C)
    push!(χ_list, χ)
end

plot(β_list, E_list)

plot(β_list, M_list)

plot(β_list, C_list)

plot(β_list, χ_list)

E_Data = []
M_Data = []
C_Data = []
χ_Data = []

for l in 3:12
    E_list = []
    M_list = []
    C_list = []
    χ_list = []

    for β in β_list
        E, M, C, χ = ising2d(dim, β, 1000, 100)
        push!(E_list, E)
        push!(M_list, M)
        push!(C_list, C)
        push!(χ_list, χ)
    end
    push!(E_Data, E_list)
    push!(M_Data, M_list)
    push!(C_Data, C_list)
    push!(χ_Data, χ_list)
end