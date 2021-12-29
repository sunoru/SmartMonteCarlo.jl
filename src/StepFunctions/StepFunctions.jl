module StepFunctions

using MosiBases

export StepFunction
abstract type StepFunction end

export GaussianStep
include("./gaussian.jl")

end
