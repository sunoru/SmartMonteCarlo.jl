# The ratio of the target probability density. $ρ(R₂)/ρ(R₁)$
# For PEL ensembles, it's simply 1 or 0 based on if the new configuration is allowed.
probability_ratio(
    pel::PotentialEnergyLandscapeEnsemble, model::MosiModel
) = (_R₁, R₂) -> potential_energy(R₂, model) ≤ pel.E_L ? 1.0 : 0.0
