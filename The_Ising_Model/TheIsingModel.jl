using Plots,LaTeXStrings, Statistics, StatsPlots, JLD, ProgressBars, StatsBase, Ranges

function Initials()
    flag=0
    dim=4
    β=range(0.1,0.9, 80)
    System=rand([-1,1], dim, dim) 
end

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

function DE(i, j, System)
    return system[i,j](System[i-1,j]+System[i,j-1]+System[i,j+1], System[i+1,j])
end

function successful_change(System,spin, ΔE, ΔE_sum)

    return System, ΔE_sum, -spin
end

function MC(System,i,j,dim,N,β)
    ΔE_sum=0
    ΔM_sum=0
    for n in 1:N
        i=rand(1:dim);j=rand(1:dim)
        System[i,j]=spin
        ΔE= DE(i,j)
        if ΔE<=0 || rand()<exp(-ΔE*β)
            System[i,j] = -System[i,j]
            ΔE_sum += ΔE
            ΔM_sum += System[i,j]
        end
    end
    return System, ΔE_sum, ΔM_sum
end

function Inital_system(system,dim)
    β=0.1
    N=100*dim^2
    for n in 1:N
        i=rand(1:dim);j=rand(1:dim)
        ΔE= DE(i,j)
        if ΔE<=0 || rand()<exp(-ΔE*β)
            System[i,j]=ΔE
    end
    return System
end

System=Initial_System(System, dim)

for β in range(0.11, 0.9, 80)
    Eᵢ=FindEnergy(system, dim)
    Mᵢ=sum(System)
    N=10*dim^2
    System, ΔE, ΔM = MC(System, i,j ,dim,N,β)
    Eᵢ += ΔE 
    Mᵢ += ΔM
    M_list=[]; E_list=[]
    System, ΔE, ΔM = MC(System, i,j ,dim,N,β)
    E = Eᵢ + ΔE
    M = Mᵢ + ΔM
    push!(E_list, E)
    push!(M_list, M)
end


