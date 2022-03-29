module LJ2D

try
    using LennardJones
catch ArgumentError
    import Pkg
    Pkg.add(url="https://github.com/sunoru/LennardJones.jl.git")
    using LennardJones
end

using SmartMonteCarlo.MosimoBase

struct LJ2DModel <: MosiModel{Vector2}
    N::Int
    box::Vector2
end

function V_func(rs::Vector2s, dist)
    N = length(rs)
    V = 0.0
    for i in 1:N-1
        for j in i+1:N
            V += LennardJones.lj_potential_uij(rs[i], rs[j], dist=dist)
        end
    end
    V
end
MosimoBase.potential_energy_function(model::LJ2DModel, rs) = V_func(rs, distance_function(model))

function ∇V_func(rs::Vector2s, dist)
    N = length(rs)
    ∇V = zeros(Vector2, N)
    for i in 1:N-1
        for j in i+1:N
            fij = LennardJones.lj_potential_fij(rs[i], rs[j], dist=dist)
            ∇V[i] -= fij
            ∇V[j] += fij
        end
    end
    ∇V
end
function ∇V_func(rs::Vector2s, i::Int, dist)
    N = length(rs)
    ∇V = zero(Vector2)
    ri = rs[i]
    for j in 1:N
        i ≡ j && continue
        fij = LennardJones.lj_potential_fij(ri, rs[j], dist=dist)
        ∇V -= fij
    end
    ∇V
end
MosimoBase.force_function(model::LJ2DModel, rs) = -∇V_func(rs, distance_function(model))
MosimoBase.force_function(model::LJ2DModel, rs, i) = -∇V_func(rs, i, distance_function(model))
MosimoBase.potential_energy_gradients(model::LJ2DModel, rs) = ∇V_func(rs, distance_function(model))
MosimoBase.potential_energy_gradients(model::LJ2DModel, rs, i) = ∇V_func(rs, i, distance_function(model))
MosimoBase.has_pbc(::LJ2DModel) = true

end
