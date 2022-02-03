@doc """
Orthogonal to the potential energy
"""
function OrthogonalToPotential(a::Real, model::MosiModel)
    ∇O_func = (rs, i) -> potential_energy_gradients(model, rs, i)
    OrthogonalToGradients(a, ∇O_func)
end
