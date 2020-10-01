# Driver script for all unit tests

using Distributed
@everywhere using Pkg

if abspath(PROGRAM_FILE) == @__FILE__
    # when run as a script, activate the test environment of this package so that test dependencies are available
    @everywhere Pkg.activate(dirname(@__FILE__))
    @everywhere Pkg.instantiate()
end

using Jive

# TODO reinstate after refactoring all modules
runtests(@__DIR__, skip=["runtests.jl", "helper", "broken"])
