include("test_common.jl")

@testset "Simple 2D Lennard-Jones System" begin

include("LJ2D.jl")

# Periodic boundary conditions
# [-1, 1)^3
model = LJ2D.LJ2DModel(3, Vector2(2, 2))

initial = ConfigurationSystem([
    Vector2(-1, -1),
    Vector2( 0, -1),
    Vector2(-1,  0)
], box=model.box)

max_steps = 1000
setup = smc_init(
    initial, model,
    max_steps = max_steps,
    select_type = UniformSelect(),
    step_function = GaussianStep(0.1),
    force_bias = OrthogonalPotential(0.75),
    ensemble = PotentialEnergyLandscapeEnsemble(2),
    rng_seed = 1257891,
    output_dir = joinpath(@__DIR__, "./output")
)

@test SmartMonteCarlo.init_state(setup) isa SMCState

@test potential_energy(initial, model) ≈ -0.4375

function make_callback(setup, data)
    model = setup.model
    logging_period = 100
    data["PEs"] = PEs = Float64[]
    data["accepted"] = 0
    @printf "  Step  | Just Moved | Potential Energy \n"
    (state::SMCState; force_logging::Bool = false) -> begin
        step = state.step
        V = potential_energy(system(state), model)
        push!(PEs, V)
        just_moved = state.just_moved_index
        if just_moved > 0
            data["accepted"] += 1
        end
        if !force_logging && step % logging_period == 0
            @printf(
                " %5d  | %s | %20.8f\n",
                step,
                if just_moved == 0
                    " Started  "
                elseif just_moved < 0
                    @sprintf "%4d (rej)" -just_moved
                else
                    @sprintf "%4d      " just_moved
                end,
                V
            )
        end
    end
end

data = Dict{String, Any}()
result = smc_run(setup; callback = make_callback(setup, data))

mean_PEs = mean(data["PEs"])
@show mean_PEs
@test mean_PEs ≈ 0.5210879790489125
accepted = data["accepted"]
@printf "Acceptance: %d/%d (%.2f%%)\n" accepted max_steps accepted / max_steps * 100
@test accepted ≡ 614

end
