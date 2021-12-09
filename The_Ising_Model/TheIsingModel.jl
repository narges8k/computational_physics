using Plots,LaTeXStrings, Statistics, StatsPlots, JLD, ProgressBars, StatsBase, Ranges

function Initials()
    flag=0
    L=10
    β=range(0.1,0.9, 80)
    N=L
    system=rand([-1,1], L, L) 
end

function DE(i, j, system)
    return system[i,j](system[i-1,j]+system[i,j-1]+system[i,j+1], system[i+1,j])
end

function successful_change(system, i, j, L, β)
    ΔE_sum=0
    system[i,j]=ΔE
    ΔE_sum += ΔE
    return system, ΔE_sum
end

function MC(system,L,N,β)
    for n in 1:N
        i=rand(1:L);j=rand(1:L)
        ΔE= DE(i,j)
        if ΔE<=0 || rand()<exp(-ΔE*β)
            system,ΔE_sum, M=successful_change(system, i, j)
        end
    end
    return system, ΔE_sum
end

function Inital_system(system,L)
    β=0.1
    N=100*L^2
    for n in 1:N
        i=rand(1:L);j=rand(1:L)
        ΔE= DE(i,j)
        if ΔE<=0 || rand()<exp(-ΔE*β)
            system[i,j]=ΔE
    end
    E=0
    for i in 1:L
        for j in 1:L
            E+=
        end
    end
    return system
end

system=Initial_system(system, L)

for β in range(0.11, 0.9, 80)
    N=10*L^2
    system, ΔE_sum = MC(system,L,N,β)
    
