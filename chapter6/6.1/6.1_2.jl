using Plots, JLD, Statistics, LaTeXStrings
number_list=[i for i in 0:9]
NList=[n for n in 100:10:10000]
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
plot(log.(NList),log.(STDList), xlabel="log(N)", ylabel="log(sigma)",
    title=L"Sigma\ versus\ Number\ of\ Iterations(100<N<10000, with\ steps\ of\ 100)", legend=false,dpi=400,titlefontsize=11)
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter6\\6.1\\Figs\\Sigma_N1.png")
plot(log.(NList),log.(STDList), xlabel="log(N)", ylabel="log(sigma)",
    title=L"Sigma\ versus\ Number\ of\ Iterations(100<N<10000, with\ steps\ of\ 100)", legend=false,dpi=400,titlefontsize=11)
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter6\\6.1\\Figs\\Sigma_N2.png")
