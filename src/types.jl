mutable struct SMCState{T <: MosiVector} <: SimulationState
    step::Int
    accepted::Int
    configuration::ConfigurationSystem{T, Vector{T}}
    rng::MosiRNG
    just_moved_index::Int
end
Base.time(s::SMCState) = s.step
MosimoBase.system(s::SMCState) = s.configuration

struct SMCResult <: SimulationResult
# TODO
end
