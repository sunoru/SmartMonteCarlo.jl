abstract type SelectType end

struct UniformSelect <: SelectType end

function select_atom(::UniformSelect, state::SMCState, model::MosiModel)
    N = natoms(model)
    rand(state.rng, 1:N)
end
