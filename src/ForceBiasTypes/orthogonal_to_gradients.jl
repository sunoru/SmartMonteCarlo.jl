@doc raw"""
Orthogonal to some general gradients.

`∇O`: (rs, i) -> Vectord

```math
\begin{align}
\mathbf{m}_j(\mathbf{R}) &= C\left[
    \frac{a}{2}\left(\mathbf{1}-\hat\nabla_jO(\mathbf{R})\hat\nabla_jO(\mathbf{R})\right) +
    (1-a)\left(\hat\nabla_jO(\mathbf{R})\hat\nabla_jO(\mathbf{R})\right) \right]  \\
C &= \sqrt{3/(1-2a+\frac{3}{2}a^2)}
\end{align}
```
"""
struct OrthogonalToGradients{TO <: Function} <: ForceBiasType
    a::Float64
    ∇O::TO
    function OrthogonalToGradients(a, ∇O)
        @assert a ≥ 0 && a ≤ 1
        new{typeof(∇O)}(a, ∇O)
    end
end

@inline function get_projector(
    fb::OrthogonalToGradients,
    rs::AbstractVector{T},
    i::Int
) where T <: MosiVector
    a = fb.a
    ∇O_func = fb.∇O
    J = ndims(T)
    C = √(J / (1 - 2a + (1 + (J - 1) / 4) * a ^ 2))
    ∇O_i = normalize(∇O_func(rs, i))
    P = ∇O_i * ∇O_i'
    C * (a / 2 * (I - P) + (1 - a) * P)
end

@inline function _G(rs, i, Δr_i, ∇O_func)
    F_i = -∇O_func(rs, i)
    (Δr_i ⋅ F_i) ^ 2 / tr(F_i * F_i')
end

function try_move(
    state::SMCState, model::MosiModel, i::Int,
    fb::OrthogonalToGradients,
    gaussian_step::GaussianStep,
    ensemble::Ensemble
)
    δr = get_move_step(gaussian_step, state, model)
    rs = positions(system(state))
    m = get_projector(fb, rs, i)
    ∇O_func = fb.∇O
    Δr_i = m * δr
    new_rs = copy(rs)
    new_rs[i] += Δr_i
    ρ_ratio = probability_ratio(ensemble, model, rs, new_rs)
    ρ_ratio ≤ 0 && return rs, 0
    α = 1 / 2 / gaussian_step.σ ^ 2
    a = fb.a
    J = ndims(δr)
    C = √(J / (1 - 2a + (1 + (J - 1) / 4) * a ^ 2))
    γ = ((1 - a) ^ (-2) - (a / 2) ^ (-2)) / C ^ 2
    p = ρ_ratio * exp(-α * γ * (
        _G(without_constraints, i, Δr_i, ∇O_func) - _G(rs, i, Δr_i, ∇O_func)
    ))
    new_rs, p
end

@inline function accept_move!(
    state::SMCState, ::MosiModel{T}, i::Int,
    ::OrthogonalToGradients,
    new_rs::Vector{T}
) where T
    rs = positions(system(state))
    rs[i] = new_rs[i]
    state
end
