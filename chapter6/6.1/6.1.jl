using Plots
res=[]
N=100000
for i in 1:N
    num=rand(0:9)
    push!(res, num)
end

histogram(res, bins=15, alpha=0.5, xlabel="The Random Number", ylabel="NUmber",
    title=" Frequency Curve",  c = :red, dpi=400)
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter6\\6.1\\Figs\\TheFrequencyCruve.png")
