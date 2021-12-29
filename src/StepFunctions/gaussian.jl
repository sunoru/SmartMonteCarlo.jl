@doc raw"""
Simple $d$-dimensional Gaussian

```math
P(\delta\mathbf{r})=(\frac{\alpha}{\pi})^{d/2} e^{-\alpha(\delta\mathbf{r})^2}
```
"""
struct GaussianStep <: StepFunction
    α::Float64
end
