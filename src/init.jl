function MosiBases.init_state(setup::SMCSetup)
    SMCState(0, 0, copy(setup.initial))
end

function smc_init(
    initial::MosiSystem,
    model::MosiModel;
    max_steps::Integer = 10000,
    force_bias::ForceBiasType = OrthogonalPotential(0.8),
    step_function::StepFunction = GaussianStep(0.5),
    ensemble::Ensemble = PotentialEnergyLandscapeEnsemble(potential_energy(initial, model)),
    output_dir::AbstractString = "./output"
)
    rs = positions(initial)
    pbc_box = box(initial)
    initial = ConfigurationSystem(copy(rs), box = pbc_box)
    output_dir = abspath(output_dir)
    setup = SMCSetup(
        initial, model, ensemble,
        max_steps, step_function,
        force_bias,
        output_dir
    )
end
