
% Problem 1 - Round shaped differential drive robot navigation
% Goal check function

function nearRobot = isNearRobot(x, y, model)
    
    nearRobot = 1;
    
    if(model.state(1) > x + model.radius || ...
        model.state(1) < x - model.radius )
        nearRobot = 0;
    end
    
    if(model.state(2) > y + model.radius || ...
        model.state(2) < y - model.radius)
        nearRobot = 0;
    end
    
end