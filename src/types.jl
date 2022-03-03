mutable struct SMCState{T <: MosiVector} <: SimulationState
    step::Int
    accepted::Int
    configuration::ConfigurationSystem{T, Vector{T}}
    rng::Xoshiro256StarStar
    just_moved_index::Int
end
Base.time(s::SMCState) = s.step
MosiBase.system(s::SMCState) = s.configuration

struct SMCResult <: SimulationResult
# TODO
end
