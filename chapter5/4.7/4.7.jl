using Plots, JLD, ProgressBars, Statistics
Directions=[[0,1],[0,-1],[1,0],[-1,0]]
function f(N, Network_,Pos)
    if N==0
        return 1
    end
    Network_[Pos...]=true
    c=0
    for path in Directions
        NextPos=Pos .+ path
        if !Network_[NextPos...]
            c+=f(N-1, Network_, NextPos)
        end
    end
    Network_[Pos...]=false
    return c
end
Totdata=[]
N=16
for n in ProgressBar(0:N)
    L=2n+1
    Network_=falses(L,L)
    FirstPos=[n+1, n+1]
    push!(Totdata, f(n, Network_,FirstPos))
end
plot(0:N,Totdata, legend=false, dpi=400)
scatter!(0:N,Totdata, legend=false, xlabel="N",ylabel="Number of Paths",
    title="Number of Paths versus N for Self-Avoiding Walker", titlefontsize=10, dpi=400)
save("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter5\\4.7\\SAW.jld", "Data", Totdata)
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter5\\4.7\\Figs\\NumberOfPaths_N.png")
plot(0:N, Totdata./ 4 .^(0:N), legend=false, dpi=400)
scatter!(0:N, Totdata./ 4 .^(0:N), legend=false, xlabel="N",ylabel="Ratio of Number of Paths",
    title="Ratio of Number of Paths of SAW and RW ", dpi=400)
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter5\\4.7\\Figs\\Ratio_N.png")
