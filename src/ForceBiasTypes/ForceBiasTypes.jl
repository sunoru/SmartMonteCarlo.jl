module ForceBiasTypes

using MosiBases

export ForceBiasType
abstract type ForceBiasType end

export OrthogonalPotential
include("./orthogonal_potential.jl")

end
