using Plots,LaTeXStrings, Statistics, StatsPlots, JLD, ProgressBars, StatsBase, Ranges

#Initials
dim=4
β=range(0.1,0.9, 80)
System=rand([-1,1], dim, dim) 

function FindEnergy(ُSystem::Matrix{Int8}, dim::Integer)
    E = 0.0
    for i ∈ 1:dim
        for j ∈ 1:dim
            Neighbors = [[1 + i % dim, j], [i, 1 + j % dim], [(-2 + i + dim) % dim + 1, j], [i, (-2 + j + dim) % dim + 1]]
            E += -sum(System[i, j] * System[Neighbors]) / 2
        end
    end
    return E
end

function DE(System::Matrix{Int8}, i::Integer, j::Integer)
    return system[i,j]*(System[i-1,j]+System[i,j-1]+System[i,j+1], System[i+1,j])
end

function MC(System::Matrix{Int8}, dim::Integer, N::Integer, β::Real)
    ΔE_sum=0
    ΔM_sum=0
    for n in 1:N
        i=rand(1:dim);j=rand(1:dim)
        System[i,j]=spin
        ΔE= DE(i,j)
        if ΔE<=0 || rand()<exp(-ΔE*β)
            System[i,j] = -spin
            ΔE_sum += ΔE
            ΔM_sum += 2*(-spin)
        end
    end
    return System, ΔE_sum, ΔM_sum
end

function Initial_System(System::Matrix{Int8},dim::Integer)
    β=0.1
    N=100*dim^2
    for n in 1:N
        i=rand(1:dim);j=rand(1:dim)
        ΔE= DE(i,j)
        if ΔE<=0 || rand()<exp(-ΔE*β)
            System[i,j]= -System[i,j]
        end
    end
    return System
end

System=Initial_System(System, dim)
M_list=[]; E_list=[]
for β in range(0.11, 0.9, 80)
    Eᵢ=FindEnergy(system, dim)
    Mᵢ=sum(System)
    N=10*dim^2
    System, ΔE, ΔM = MC(System,dim,N,β)
    Eᵢ += ΔE 
    Mᵢ += ΔM
    System, ΔE, ΔM = MC(System,dim,N,β)
    E = Eᵢ + ΔE
    M = Mᵢ + ΔM
    push!(E_list, E)
    push!(M_list, M)
end


