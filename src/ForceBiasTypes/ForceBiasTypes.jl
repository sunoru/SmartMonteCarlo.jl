module ForceBiasTypes

using LinearAlgebra
using MosiBases
import ..SmartMonteCarlo: SMCState
import ..Ensembles: probability_ratio
using ..StepFunctions
import ..StepFunctions: get_move_step

export ForceBiasType
abstract type ForceBiasType end

export OrthogonalPotential
include("./orthogonal_potential.jl")

end
