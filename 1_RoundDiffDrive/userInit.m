
% Problem 1 - Round shaped differential drive robot navigation
% User initialization function

function userStructure = userInit(model, environment)

    userStructure.obstacleMap = buildObstacleMap(model, environment);    
    userStructure.nullValue = -100;
    userStructure.endIdealPath = -50000;
    
    userStructure.toleranceStateRobot = 0.2
    
    userStructure.B = [0 0; 0 0; 0 0; 1 0; 0 1];
    
    userStructure.nodeInterval.min = 0.25; %Can not be smaller, otherwise size problem to build the matrix of zeros
    %0.5 good for hard
    %0.75 good for easy
    %0.8 good for moderate
    userStructure.nodeInterval.max = 0.5;
    userStructure.nodeInterval.epsilon = 0.05;
    userStructure.nodeInterval.current = userStructure.nodeInterval.max;

    
    userStructure.nodeMap = buildNodeMap(model, environment, userStructure);
    userStructure.globalPathMap = buildGlobalPathMap(environment, userStructure);
    userStructure.idealPathMap = buildIdealPathMap(environment, userStructure);
    userStructure.currentNodeInPath = 1;
    
    plotAll(model, environment, userStructure);
    userStructure.pathPlanning = userStructure.idealPathMap; %Matrix for the map
    pause(3);
    
    
    %HACK INIT A VALUE
    model.state(4:5) = [1 1]
%    userStructure.exampleVariable = 0;

    
    for i = 1:3
        'Hello World!'
    end

end
