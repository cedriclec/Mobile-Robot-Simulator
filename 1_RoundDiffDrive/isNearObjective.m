function nearObjective = isNearObjective(x, y, objective, model)
    
    nearObjective = 1;
    
    if(objective(1) > x + model.radius || ...
        objective(1) < x - model.radius )
        nearObjective = 0;
    end
    
    if(objective(2) > y + model.radius || ...
        objective(2) < y - model.radius)
        nearObjective = 0;
    end
    
end