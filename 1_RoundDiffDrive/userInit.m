
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
    userStructure.nodeInterval.max = 0.25; %0.25 for easy and hard 
    userStructure.nodeInterval.max = 0.4; %0.4 for moderate
    userStructure.nodeInterval.epsilon = 0.05;
    userStructure.nodeInterval.current = userStructure.nodeInterval.max;
    

    userStructure.nodeMap = buildNodeMap(model, environment, userStructure);
    userStructure.globalPathMap = buildGlobalPathMap(environment, userStructure);
    userStructure.idealPathMap = buildIdealPathMap(environment, userStructure);
    userStructure.currentNodeInPath = 1;
    
    %To Delete
    userStructure.currentNodeInPath = userStructure.currentNodeInPath + 1;
    
    %0 = Finish
    %1 = Stop
    %2 = Turn
    %3 = Move forward
    userStructure.currentUobjectif = -1;
    
    userStructure.velocity = 0.25;
    userStructure.angleVelocity = 0.3;
    %userStructure.angleVar = 1;
    mapAllNode = getAllNode(userStructure);
    userStructure.mapAllNode = mapAllNode;
    userStructure.controller = robotics.PurePursuit('DesiredLinearVelocity', 0.5, 'Waypoints', mapAllNode, 'MaxAngularVelocity', 2);
       
    %Velocity PID Initial conditions
    userStructure.velPIDVal.Kp = 1;
    userStructure.velPIDVal.Ki = 0;
    userStructure.velPIDVal.Kd = 0;
    userStructure.velPIDVal.errorPrior = 0;
    userStructure.velPIDVal.integral = 0;
    userStructure.velPID = pid(userStructure.velPIDVal.Kp, userStructure.velPIDVal.Ki,  userStructure.velPIDVal.Kd );
    %Angular Velocity PID Initial conditions
    userStructure.angVelPIDVal.Kp = 20;
    userStructure.angVelPIDVal.Ki = 0;
    userStructure.angVelPIDVal.Kd = 0;
    userStructure.angVelPIDVal.errorPrior = 0;
    userStructure.angVelPIDVal.integral = 0;
    userStructure.angvelPID = pid(userStructure.angVelPIDVal.Kp, userStructure.angVelPIDVal.Ki,  userStructure.angVelPIDVal.Kd );
    
    plotAll(model, environment, userStructure);
    userStructure.pathPlanning = userStructure.idealPathMap; %Matrix for the map
    %pause(3);
    
    
    %HACK INIT A VALUE
    model.state(4:5) = [1 1]
%    userStructure.exampleVariable = 0;
    
    for i = 1:3
        'Hello World!'
    end

end

function mapAllNode = getAllNode(userStructure)
    size = 1;
    while (userStructure.idealPathMap(1,size) > 0)
        size = size + 1;        
    end
    size = size - 1;
    mapAllNode = zeros(size, 2);
    for i = 1 : size
        mapAllNode(i, 1:2) = userStructure.nodeMap(1:2, (userStructure.idealPathMap(1, i)) );
    end
end
