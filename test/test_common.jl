import Pkg

if dirname(Pkg.project().path) != @__DIR__
    Pkg.activate(@__DIR__)
end

using Test
using SmartMonteCarlo
