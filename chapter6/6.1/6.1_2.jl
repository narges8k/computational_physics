using Plots, JLD, Statistics, LaTeXStrings,StatsBase
number_list=[i for i in 0:9]
NList=[n for n in 100:100:10000]
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
function Linear_fit(X, Y)
    A = [hcat(X) reshape(ones(length(X)), length(X), 1)]
    b = reshape(hcat(Y), length(Y), 1)
    line = (A \ b)
    return line
end
Line=Linear_fit(log.(NList), log.(STDList))
X = log.(NList)
Y = X .* Line[1,1] .+ Line[2,1]
plot(log.(NList),log.(STDList), xlabel="log(N)", ylabel="log(sigma)",
    title=L"Sigma\ versus\ Number\ of\ Iterations(100<N<10000, with\ steps\ of\ 10)",label=nothing,dpi=400,titlefontsize=11)
plot!(X,Y, color=:black,label = L"Y = %$(round(Line[1],digits=3))\ X + %$(round(Line[2],digits=3))")
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter6\\6.1\\Figs\\Sigma_N1.png")

plot(log.(NList),log.(STDList), xlabel="log(N)", ylabel="log(sigma)",
    title=L"Sigma\ versus\ Number\ of\ Iterations(100<N<10000, with\ steps\ of\ 100)", label=nothing,dpi=400,titlefontsize=11)
plot!(X,Y, color=:black,label = L"Y = %$(round(Line[1],digits=3))\ X + %$(round(Line[2],digits=3))")
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter6\\6.1\\Figs\\Sigma_N2.png")
