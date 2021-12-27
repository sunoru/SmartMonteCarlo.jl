function MosiBases.init_state(setup::SMCSetup)
    SMCState(0, 0, copy(setup.initial))
end
