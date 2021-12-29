struct SMCSetup{
    T <: MosiVector,
    TE <: Ensemble,
    TM <: MosiModel,
    TA <: SelectType,
    TS <: StepFunction,
    TF <: ForceBiasType
} <: SimulationSetup
    initial::ConfigurationSystem{T, Vector{T}}
    model::TM
    ensemble::TE
    max_steps::Int

    select_type::TA
    step_function::TS
    force_bias::TF

    rng_seed::UInt64
    output_dir::String
end
