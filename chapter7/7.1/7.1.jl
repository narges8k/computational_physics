using Plots, LaTeXStrings, Statistics, JLD

function SMC(f :: Function, a :: Real, b :: Real, N :: Integer )
    f₍ₓ₎= f.((b-a).*rand(N) + a)
    ∫f₍ₓ₎dx= (b-a)*(mean(f₍ₓ₎))
    error=std(f₍ₓ₎)/sqrt(N)
    return ∫f₍ₓ₎dx, error
end
function IMC(f :: Function, a :: Real, b :: Real, g₍ₓ₎ :: Function, y :: Function, N :: Integer)
    f₍ₓ₎/g₍ₓ₎ = x-> f(x)/g(x)
    NewD= (f₍ₓ₎/g₍ₓ₎).(y.rand(N))
    ∫g₍ₓ₎dx= 1-ℯ^2
    ∫f₍ₓ₎dx= ∫g₍ₓ₎dx * mean(NewD)
    error= ∫g₍ₓ₎dx * std(NewD)/sqrt(N)
    return ∫f₍ₓ₎dx, error

end

SMC(x->ℯ^(-x^2), 0, 2, 10^6)
IMC(x->ℯ^(-x^2), 0, 2, x -> ℯ^(-x), x -> -log(1-(1-ℯ^2)*x), 10^6)
