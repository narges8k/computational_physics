using Plots, LaTeXStrings, ProgressBars
function LogisticMap(x::Matrix{<:Number}, r::Vector{<:Number})
    return x = 4 .* r .* x .* (1 .- x)
end
rcount= 2001
r_s = collect(range(0.0, 1.0, length=rcount))
x_s = rand(rcount, 10)
anim = @animate for n in ProgressBar(1:70)
    global x_s = LogisticMap(x_s, r_s)
    scatter(r_s, x_s, ms=0.5, msw=0, xlims=(0.0, 1.0), ylims = (0, 1), marker=:rect,
        legend=false, color=:black, alpha=0.25, xlabel=L"r", ylabel=L"x_n",
        title="\$\\textrm{Logistic\\ Map},\\quad n=$n\$",
        dpi=120)
end
gif(anim, "bifurcation.gif", fps=10)