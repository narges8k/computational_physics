using Plots, Statistics, Distributions
initial=[]
res=[]
N=100000
for i in 1:N
    num=rand(0:9)
    push!(initial, num)
end
for i in 2:N
    if initial[i-1]==4
        push!(res, initial[i])
    end
end

histogram(res, bins=15, alpha=0.5, xlabel="The Random Number", ylabel="NUmber",
    title=" Frequency Curve",  c = :yellow, dpi=400)
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter6\\6.2\\Figs\\TheFrequencyCruve.png")
