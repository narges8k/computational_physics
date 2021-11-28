using Plots, LaTeXStrings, Statistics, JLD, BenchmarkTools, StatsBase, SpecialFunctions, ProgressMeter

Integral_answer=sqrt(π)/2 * erf(2)

function SSMC(f :: Function, a :: Real, b :: Real, N :: Integer )
    f₍ₓ₎= f.((b-a).*rand(N) .+ a)
    ∫f₍ₓ₎dx= (b-a)*(mean(f₍ₓ₎))
    error=std(f₍ₓ₎)/sqrt(N)
    return ∫f₍ₓ₎dx, error
end

function ISMC(f :: Function, a :: Real, b :: Real, g :: Function, y :: Function, N :: Integer)
    drivation= x-> f(x)/g(x)
    samples= drivation.(y.(rand(N)))
    ∫g₍ₓ₎dx= 1-ℯ^2
    ∫f₍ₓ₎dx= ∫g₍ₓ₎dx * mean(samples)
    error= ∫g₍ₓ₎dx * std(samples)/sqrt(N)
    return ∫f₍ₓ₎dx, error
end

nList=Integer.([10^n for n in 1:6])
SSMC_res=[]
prog= Progress(length(nList))
n=0
for n in nList
    I, error=SSMC(x-> ℯ^(-x^2), 0, 2, n)
    bench = @benchmark SSMC(x->ℯ^(-x^2), 0, 2, n)
    push!(SSMC_res, (I, error, mean(bench).time, bench))
    next!(prog)
end
ISMC_res=[]
n=0
prog= Progress(length(nList))
for n in nList
    I, error=ISMC(x->ℯ^(-x^2), 0, 2, x -> ℯ^(-x), x -> -log(1-(1-ℯ^2)*x), n)
    bench = @benchmark ISMC(x->ℯ^(-x^2), 0, 2, x -> ℯ^(-x), x -> -log(1-(1-ℯ^2)*x), n)
    push!(ISMC_res, (I, error, mean(bench).time, bench))
    next!(prog)
end

AnswerList=[Integral_answer for i in 1: length(nList)]
plot(log.(nList), [getindex.(SSMC_res, 1) getindex.(ISMC_res, 1) AnswerList])

plot(log.(nList), [getindex.(SSMC_res, 2) getindex.(ISMC_res, 2)])

plot(nList, )
