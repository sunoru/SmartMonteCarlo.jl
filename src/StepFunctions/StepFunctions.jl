module StepFunctions

using MosiBases
import ..SmartMonteCarlo: SMCState

export StepFunction
abstract type StepFunction end

export GaussianStep
include("./gaussian.jl")

end
