struct SMCSetup{
    T <: MosiVector,
    TE <: Ensemble,
    TM <: MosiModel,
    TS <: StepFunction,
    TF <: ForceBiasType
} <: SimulationSetup
    initial::ConfigurationSystem{T, Vector{T}}
    model::TM
    ensemble::TE
    max_steps::Int
    step_function::TS
    force_bias::TF

    output_dir::String
end

mutable struct SMCState{T <: MosiVector} <: SimulationState
    step::Int
    accepted::Int
    configuration::ConfigurationSystem{T, Vector{T}}
end
Base.time(s::SMCState) = s.step
system(s::SMCState) = s.configuration

struct SMCResult <: SimulationResult
# TODO
end
