using Plots
number_list=[i for i in 0:9]
N=100000
res=rand(number_list, N)
frequency_list=[]
for i in number_list
    push!(frequency_list, length(findall(x->x==i, res)))
end
frequency_list
std(frequency_list)
histogram(res, bins=15, alpha=0.5, xlabel="The Random Number", ylabel="NUmber",
    title=" Frequency Curve",  c = :red, dpi=400)
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter6\\6.1\\Figs\\TheFrequencyCruve_N=100000.png")
