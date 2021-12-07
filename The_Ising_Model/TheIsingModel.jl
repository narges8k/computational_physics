using Plots,LaTeXStrings, Statistics, StatsPlots, JLD, ProgressBars, StatsBase

function Initials()
    flag=0
    L=10
    T=1
    system=rand([-1,1], L, L) 
end

function DE(i, j, system)
    return -2*system[i,j](system[i-1,j]+system[i,j-1]+system[i,j+1], system[i+1,j])
end

function MC()
    i=rand(1:L);j=rand(1:L)
    ΔE= DE(i,j)
    if ΔE<0
        
end