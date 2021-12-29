import Printf: @printf

function default_callback(setup::SMCSetup)
    logging_period = max(10, setup.max_steps ÷ 20)
    model = setup.model
    @printf "  Step  | Potential Energy "
    (state::SMCState; force_logging::Bool = false) -> begin
        step = state.step
        if force_logging || step % logging_period ≡ 0
            @printf " %5d  | %20.8f\n" step potential_energy(system(state), model)
        end
    end
end

function evolve!(state, setup)
    # TODO: evolve the state.
    state.step += 1
    state
end

# Main function for running SMC.
function smc_run(
    setup::SMCSetup;
    # Do the logging and other verification work in this callback function
    callback::Function = default_callback(setup)
)
    state = init_state(setup)
    callback(state)
    while state.step < setup.max_steps
        state = evolve!(state, setup)
        callback(state)
    end
    # Log the final state.
    callback(state, force_logging = true)
end
