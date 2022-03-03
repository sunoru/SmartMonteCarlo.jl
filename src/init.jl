function MosiBase.init_state(setup::SMCSetup)
    rng = new_rng(setup.rng_seed)
    SMCState(0, 0, copy(setup.initial), rng, 0)
end

function smc_init(
    initial::MosiSystem,
    model::MosiModel;
    max_steps::Integer = 10000,
    select_type::SelectType = UniformSelect(),
    step_function::StepFunction = GaussianStep(0.1),
    force_bias::ForceBiasType = OrthogonalPotential(0.8),
    ensemble::Ensemble = PotentialEnergyLandscapeEnsemble(potential_energy(initial, model)),
    rng_seed::Nullable{Integer} = nothing,
    output_dir::AbstractString = "./output"
)
    rs = positions(initial)
    box = pbc_box(initial)
    initial = ConfigurationSystem(copy(rs), box = box, update_periods = false)
    output_dir = abspath(output_dir)
    setup = SMCSetup(
        initial, model, ensemble,
        max_steps,
        select_type,
        step_function,
        force_bias,
        make_seed(rng_seed),
        output_dir
    )
end
