@doc raw"""
Orthogonal to the potential energy

```math
\mathbf{m}_j(\mathbf{R}) = a\left(1-\hat{\nabla}_jV(\mathbf{R})\hat{\nabla}_jV(\mathbf{R})\right)
    + (1-a)\left(\hat{\nabla}_jV(\mathbf{R})\hat{\nabla}_jV(\mathbf{R})\right)
```
"""
struct OrthogonalPotential <: ForceBiasType
    a::Float64
    function OrthogonalPotential(a)
        @assert a ≥ 0.5 && a < 1
        new(a)
    end
end

@inline function get_projector(
    fb::OrthogonalPotential, rs::AbstractVector{T},
    model::MosiModel, i::Int
) where T <: MosiVector
    a = fb.a
    C = √(3 / (1 - 2a + 3a ^ 2 / 2))
    ∇V_i = normalize(potential_energy_gradients(model, rs, i))
    P = ∇V_i * ∇V_i'
    C * (a / 2 * (I - P) + (1 - a) * P)
end

@inline function _G(rs, i, Δr_i, model)
    F_i = -normalize(potential_energy_gradients(model, rs, i))
    (Δr_i ⋅ F_i) ^ 2 / tr(F_i * F_i')
end

function apply_constraints(rs, i, Δr_i, model::MosiModel{T}) where T
    ∇Cs = constraint_gradients(model, rs)
    if length(∇Cs) == 0
        new_rs = copy(rs)
        new_rs[i] += Δr_i
        return new_rs
    end
    P = projection_matrix(∇Cs)
    N = length(rs)
    direction = zeros(T, N)
    direction[i] = Δr_i
    new_rs = rs + unflatten(T, P * flatten(direction))
end

function try_move(
    state::SMCState, model::MosiModel, i::Int,
    fb::OrthogonalPotential,
    gaussian_step::GaussianStep,
    ensemble::Ensemble
)
    δr = get_move_step(gaussian_step, state, model)
    rs = positions(system(state))
    m = get_projector(fb, rs, model, i)
    Δr_i = m * δr
    without_constraints = copy(rs)
    without_constraints[i] += Δr_i
    new_rs = apply_constraints(rs, i, Δr_i, model)
    ρ_ratio = probability_ratio(ensemble, model, rs, new_rs)
    ρ_ratio ≤ 0 && return rs, 0
    α = 1 / 2 / gaussian_step.σ ^ 2
    a = fb.a
    C = √(3 / (1 - 2a + 3a ^ 2 / 2))
    γ = ((1 - a) ^ (-2) - (a / 2) ^ (-2)) / C ^ 2
    p = ρ_ratio * exp(-α * γ * (
        _G(without_constraints, i, Δr_i, model) - _G(rs, i, Δr_i, model)
    ))
    new_rs, p
end

@inline function accept_move!(
    state::SMCState, ::MosiModel{T}, i::Int,
    ::OrthogonalPotential,
    new_rs::Vector{T}
) where T
    rs = positions(system(state))
    rs[i] = new_rs[i]
    state
end