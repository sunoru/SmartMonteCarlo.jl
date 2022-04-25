@doc raw"""
Uniform rotation on a sphere

```math
\begin{cases}
\delta\theta_\omega^2 \sim \text{Uniform}(0,\, \delta\omega_\text{max}^2)  \\
\delta\varphi_\omega \sim \text{Uniform}(-\pi,\, \pi)
\end{cases}
```
"""
struct UniformRotationStep <: StepFunction
    δω_max::Float64
end

get_move_step(u::UniformRotationStep, state::SMCState, ::MosiModel{Vector3}) =
    Vector2(√(rand(state.rng) * u.δω_max ^ 2), 2π * rand(state.rng) - π)
