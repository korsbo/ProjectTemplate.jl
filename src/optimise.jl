function optimise(
        model::Model,
        target = XXX,
        num_params=length(model.params),
        max_steps=Int(2e4),
        loss=:integral,
        silent=false,
        cost_kwargs = Dict{Symbol, Any}(),
        error_on_abort=false,
    )

    ### Set up for optimisation
    cost_kwargs[:loss] = loss

    opt_kwargs = Dict(
        :SearchRange => (0.,1.),
        :NumDimensions => num_params,
        :Method => :adaptive_de_rand_1_bin_radiuslimited,
        :TraceInterval => 5.,
        :MaxSteps => max_steps,
        :TraceMode => silent ? :silent : :compact,
    )

    ### Do the optimisation
    res = bboptimize(
        p -> cost(SimpleParam(model, transform_param(model, p)), target; cost_kwargs...);
        opt_kwargs...)

    error_on_abort && res.stop_reason == "InterruptException()" && error("InterruptException from blackboxoptim.")

    ### Format info for storage in parameter type.
    lower_param_bound = transform_param(model, fill(0., length(model.params)))
    upper_param_bound = transform_param(model, fill(1., length(model.params)))

    parameter_set = transform_param(model, best_candidate(res))
    cost = best_fitness(res)

    cost_kwargs[:target] = target

    metadata = Dict(
        :cost => cost_kwargs,
        :opt => opt_kwargs,
        :lower_param_bound => lower_param_bound,
        :upper_param_bound => upper_param_bound,
        )

    ### Create parameter type instance
    p = Param(model, parameter_set, cost, metadata)

    return p
end
