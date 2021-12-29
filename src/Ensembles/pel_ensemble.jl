# The ratio of the target probability density. $ρ(R₂)/ρ(R₁)$
# For PEL ensembles, it's simply 1 or 0 based on if the new configuration is allowed.
probability_ratio(
    pel::PotentialEnergyLandscapeEnsemble, model::MosiModel,
    R₁::AbstractVector{T}, R₂::AbstractVector{T}
) where T <: MosiVector = potential_energy_function(model, R₂) ≤ pel.E_L ? 1.0 : 0.0
