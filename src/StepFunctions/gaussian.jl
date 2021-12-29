@doc raw"""
Simple $d$-dimensional Gaussian

```math
P(\delta\mathbf{r}) = \frac{\exp(-(\delta\mathbf{r})^2/2\sigma^2)}{(2\pi\sigma^2)^{d/2}}
```
"""
struct GaussianStep <: StepFunction
    σ::Float64
end

get_move_step(g::GaussianStep, state::SMCState, ::MosiModel{T}) where T =
    T(randn(state.rng, length(T)) * g.σ)
