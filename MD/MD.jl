module MD
using LaTeXStrings, Plots, Statistics 
#mutable struct -> instances of the composite types can be modified.
mutable struct MDStystem{FT<:AbstractFloat} #indicating that the newly declared abstract type is a subtype of this "parent" type. 
    Δt ::FT; L :: FT; U :: FT; K :: FT; T :: FT; P :: FT
    N :: Integer
    r:: Matrix{FT}; v :: Matrix{FT}; F :: Matrix{FT}

    function MDSystem(N :: Integer, L :: FT, T₀ :: FT, Δt :: FT)
        r = rand(FT, N, 2) * L
        v = rand(FT, N, 2) .- 0.5
        v .-= mean(v, dims = 2) # This way the COM's velocity becomes zero -> Temperature is no longer dependent on velocity
        v *= sqrt(2*T₀ / mean(v .^ 2))
        F = Matrix{FT}(undef, 2, N)
        return 
    end

end

function initialize(md :: MDSystem)

end

function Force()
