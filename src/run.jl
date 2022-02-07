import Printf: @printf

import .ForceBiasTypes: try_move, accept_move!

function default_callback(setup::SMCSetup)
    logging_period = max(10, setup.max_steps ÷ 20)
    model = setup.model
    @printf "  Step  | Potential Energy \n"
    (state::SMCState; force_logging::Bool = false) -> begin
        step = state.step
        if force_logging || step % logging_period ≡ 0
            @printf " %5d  | %20.8f\n" step potential_energy(system(state), model)
        end
    end
end

@inline function evolve!(state::SMCState, setup::SMCSetup)
    model = setup.model
    # Move one atom at a time.
    i = select_atom(setup.select_type, state, model)
    # To make use of multiple dispatching.
    fb = setup.force_bias
    new_rs, probability = try_move(
        state, model, i,
        fb,
        setup.step_function,
        setup.ensemble
    )
    state.just_moved_index = if probability > 0 && rand(state.rng) < probability
        accept_move!(state, model, i, fb, new_rs)
        i
    else
        -i
    end
    state.step += 1
    state
end

function invoke_callback(callback, state, force_logging = false)
    ret = callback(state, force_logging = force_logging)
    isnothing(ret) ? false : ret
end

# Main function for running SMC.
function smc_run(
    setup::SMCSetup;
    # Do the logging and other verification work in this callback function
    callback::Function = default_callback(setup),
    return_result::Bool = true
)
    state = init_state(setup)
    should_stop = invoke_callback(callback, state)
    while !should_stop && state.step < setup.max_steps
        state = evolve!(state, setup)
        should_stop = invoke_callback(callback, state)
    end
    # Log the final state.
    invoke_callback(callback, state, true)
    return_result || return nothing
    # TODO: Make Result
    result = SMCResult()
end
