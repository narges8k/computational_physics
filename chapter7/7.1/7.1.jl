using Plots, LaTeXStrings, Statistics, JLD

function SMC(f :: Function, a :: Real, b :: Real, N :: Integer )
    f₍ₓ₎= f.((b-a).*rand(N) + a)
    ∫f₍ₓ₎dx= (b-a)*(mean(f₍ₓ₎))
    error=std(f₍ₓ₎)/sqrt(N)
    return ∫f₍ₓ₎dx, error
end
function IMC()


    
SMC(x->ℯ^(-x^2), 0, 2, 10^6)
