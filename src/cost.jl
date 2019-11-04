
cost(param::AbstractParameter, data::AbstractData) = cost(model(param), param, data)
function cost(model::Model, param, data::AbstractData; idxs=length(model.syms))
    u0 = get_u0(model, param)
    sim = simulate(model, param, u0)
    x = x_values(data)
    y = y_values(data)
    return sum((sim(x; idxs=idxs) .- y) .^ 2)
end

