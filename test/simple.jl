include("test_common.jl")

@testset "Simple 2D Lennard-Jones System" begin
    
import Pkg
Pkg.add(url="https://github.com/sunoru/LennardJones.jl.git")
using LennardJones

using SmartMonteCarlo

struct LJ2D <: MosiModel
    N::Int
    box::Vector2
end

function V_func(rs::Vector2s)
    N = length(rs)
    V = 0.0
    for i in 1:N-1
        for j in i+1:N
            V += LennardJones.lj_potential_uij(rs[i], rs[j])
        end
    end
    V
end
MosiBases.potential_energy_function(::LJ2D) = V_func

function ∇V_func(rs::Vector2s)
    N = length(rs)
    ∇V = zeros(Vector2, N)
    for i in 1:N-1
        for j in i+1:N
            fij = LennardJones.lj_potential_fij(rs[i], rs[j])
            ∇V[i] -= fij
            ∇V[j] += fij
        end
    end
    ∇V
end
MosiBases.force_function(::LJ2D) = (rs) -> -∇V_func(rs)
MosiBases.potential_energy_gradients(::LJ2D) = ∇V_func

# Periodic boundary conditions
MosiBases.has_pbc(::LJ2D) = true
model = LJ2D(3, Vector2(2, 2))

initial = ConfigurationSystem([
    Vector2(0, 0),
    Vector2(1, 0),
    Vector2(0, 1)
], box=model.box)

setup = smc_init(
    initial, model,
    max_steps = 1000,
    force_bias = OrthogonalPotential(0.8),
    step_function = GaussianStep(0.5),
    ensemble = PotentialEnergyLandscapeEnsemble(0.0),
    output_dir = joinpath(@__DIR__, "./output")
)

@test SmartMonteCarlo.init_state(setup) isa SMCState

@test potential_energy(initial, model) ≈ -0.4375

end
