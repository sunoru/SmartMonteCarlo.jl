module ForceBiasTypes

using LinearAlgebra
using MosiBase
import ..SmartMonteCarlo: SMCState
import ..Ensembles: probability_ratio
using ..StepFunctions
import ..StepFunctions: get_move_step

export ForceBiasType
abstract type ForceBiasType end

export OrthogonalToGradients
include("./orthogonal_to_gradients.jl")
export OrthogonalToPotential
include("./orthogonal_to_potential.jl")

end
