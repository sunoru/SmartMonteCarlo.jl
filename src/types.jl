struct SMCSetup{TE <: Ensemble, TM <: MosiModel} <: SimulationSetup
    initial::ConfigurationSystem{T, Vector{T}}
    model::TM
    ensemble::TE
    max_steps::Int
end

mutable struct SMCState{T <: MosiVector} <: SimulationState
    step::Int
    accepted::Int
    configuration::ConfigurationSystem{T, Vector{T}}
end
Base.time(s::SMCState) = s.step
system(s::SMCState) = s.configuration

