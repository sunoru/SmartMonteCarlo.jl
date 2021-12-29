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
