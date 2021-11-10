using Plots, Statistics, Distributions
initial=[]
NList=[1000,10000,100000,1000000]
final_res=[]
for N in NList
    res=[]
    for i in 1:N
        num=rand(0:9)
        push!(initial, num)
    end
    for i in 2:N
        if initial[i-1]==4
            push!(res, initial[i])
        end
    end
    push!(final_res, res)
end
p1=histogram(final_res[1], bins=15, alpha=0.5, xlabel="The Random Number", ylabel="Number",c = :red, label="N=1000")
p2=histogram(final_res[2], bins=15, alpha=0.5, xlabel="The Random Number", ylabel="Number",c = :green,label="N=10000")
p3=histogram(final_res[3], bins=15, alpha=0.5, xlabel="The Random Number", ylabel="Number",c = :yellow,label="N=100000")
p4=histogram(final_res[4], bins=15, alpha=0.5, xlabel="The Random Number", ylabel="Number",c = :blue,label="N=1000000")
plot(p1,p2,p3,p4, layout=4,dpi=600,guidefontsize=9, legendfont=6, legend = :outertop)
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter6\\6.2\\Figs\\TheFrequencyCruve.png")
