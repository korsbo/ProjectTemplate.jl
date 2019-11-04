module ProjectTemplate

using DifferentialEquations
using RecipesBase
using DiffEqBiological
using BlackBoxOptim
using CostFunctions
using DiffEqParameters

include("data.jl")
include("models.jl")
include("simulate.jl")
include("optimise.jl")
include("cost.jl")

Model = Union{DiffEqBase.AbstractReactionNetwork}

@param Param cost::Float64 metadata::Dict{Symbol, Any}
model(p::Param) = p.model
cost(p::Param) = p.cost

export simulate, optimise, cost, Param

end
