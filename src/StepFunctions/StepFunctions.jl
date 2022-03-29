module StepFunctions

using MosimoBase
import ..SmartMonteCarlo: SMCState

export StepFunction
abstract type StepFunction end

export GaussianStep
include("./gaussian.jl")

end
