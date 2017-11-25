
% Problem 1 - Round shaped differential drive robot navigation
% User initialization function

function userStructure = userInit(model, environment)

    userStructure.obstacleMap = buildObstacleMap(model, environment); %Matrix for the map
    
    userStructure.nullValue = -100;
    userStructure.endIdealPath = -50000;
    
    userStructure.nodeInterval.min = 0.25; %Can not be smaller, otherwise size problem to build the matrix of zeros
    %0.5 good for hard
    %0.75 good for easy
    %0.8 good for moderate
    userStructure.nodeInterval.max = 0.25;
    userStructure.nodeInterval.epsilon = 0.05;
    userStructure.nodeInterval.current = userStructure.nodeInterval.max;

    userStructure.nodeMap = buildNodeMap(model, environment, userStructure); %Matrix for the map
    userStructure.globalPathMap = buildGlobalPathMap(environment, userStructure); %Matrix for the map
    userStructure.idealPathMap = buildIdealPathMap(environment, userStructure);
    plotAll(model, environment, userStructure)
    userStructure.pathPlanning = [1,2;3,4]; %Matrix for the map
    pause(3);
    
    userStructure.exampleVariable = 0;

    
    for i = 1:3
        'Hello World!'
    end

end
