using Plots, JLD, Statistics, LaTeXStrings
number_list=[i for i in 0:9]
NList=[100,1000,10000,100000,1000000]
STDList=[]
final_res=[]
for N in NList
    res=rand(number_list, N)
    push!(final_res, res)
    frequency_list=[]
    for i in number_list
        push!(frequency_list, length(findall(x->x==i, res)))
    end
    push!(STDList,std(frequency_list))
end

p1=histogram(final_res[1], bins=15, alpha=0.5, xlabel="The Random Number", ylabel="Number",c = :red, label="N=100")
p2=histogram(final_res[2], bins=15, alpha=0.5, xlabel="The Random Number", ylabel="Number",c = :green,label="N=1000")
p3=histogram(final_res[3], bins=15, alpha=0.5, xlabel="The Random Number", ylabel="Number",c = :yellow,label="N=10000")
p4=histogram(final_res[4], bins=15, alpha=0.5, xlabel="The Random Number", ylabel="Number",c = :blue,label="N=100000")
p5=histogram(final_res[5], bins=15, alpha=0.5, xlabel="The Random Number", ylabel="Number",c = :orange,label="N=1000000")
plot(p1,p2,p3,p4,p5, layout=5,dpi=600,guidefontsize=9, legendfont=6, legend = :outertop)
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter6\\6.1\\Figs\\TheFrequencyCruve.png")
plot(STDList, log.(NList))
