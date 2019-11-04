abstract type AbstractSimulation end
struct DefaultSimulation end


simulate(model::Model, args...; kwargs...) = simulate(DefaultSimulation(), model, args...; kwargs...)
function simulate(::DefaultSimulation, model::Model, param, u0)
end
