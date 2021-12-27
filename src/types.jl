struct SMCSetup{TC <: ConfigurationSystem, TM <: MosiModel} <: SimulationSetup
    initial::TC
    model::TM
end

mutable struct SMCState{T <: MosiVector} <: SimulationState
    step::Int
    accepted::Int
    configuration::ConfigurationSystem{T, Vector{T}}
end
Base.time(s::SMCState) = s.step
system(s::SMCState) = s.configuration

