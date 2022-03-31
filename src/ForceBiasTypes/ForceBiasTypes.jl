module ForceBiasTypes

using LinearAlgebra
using MosimoBase
using ..SmartMonteCarlo: SMCState
using ..Ensembles: probability_ratio
using ..StepFunctions
using ..StepFunctions: get_move_step

export ForceBiasType
abstract type ForceBiasType end

export OrthogonalToGradients
include("./orthogonal_to_gradients.jl")
export OrthogonalToPotential
include("./orthogonal_to_potential.jl")

end
