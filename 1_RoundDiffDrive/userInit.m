
% Problem 1 - Round shaped differential drive robot navigation
% User initialization function

function userStructure = userInit(model, environment)

    userStructure.obstacleMap = buildObstacleMap(model, environment); %Matrix for the map
    plotAll(model, environment, userStructure)
    userStructure.pathPlanning = [1,2;3,4]; %Matrix for the map
    pause(3);
    userStructure.exampleVariable = 0;
    userStructure.exampleRowVector = [1,2,3];
    userStructure.exampleColumnVector = [1;2;3];
    userStructure.exampleMatrix = [1,2;3,4];
    
    for i = 1:3
        'Hello World!'
    end

end
