
% Problem 1 - Round shaped differential drive robot navigation
% Your control function

function [u, userStructure] = userCtrl(model, environment, userStructure)

    % previously defined value as an example at userInit function
    % used as a global variable, so that this will change as 0, 1, 2, ....
    % at every iteration
    %userStructure.exampleVariable = userStructure.exampleVariable + 1;
    
    if(checkIfRobotPositionEqualsNodeObjective(model, userStructure))
        goToNextNode(userStructure);
    end
    
    % control input example
    u = calcU(model, userStructure);
end

function robotIsNearObjective = checkIfRobotPositionEqualsNodeObjective(model, userStructure)
    robotIsNearObjective = 0;
    currentNodeInPath = userStructure.currentNodeInPath;
    
    currentNodeIndice = userStructure.pathPlanning(currentNodeInPath);
%     currentNodeInPath
%     currentNodeIndice
    currentNode = userStructure.nodeMap(1:2, currentNodeIndice);
    posRobot = model.state(1:2);
%     posRobot
%     currentNode
    posWanted = currentNode(1:2);
%     posWanted
    tolerance = userStructure.toleranceStateRobot;
    if( (posRobot(1) < (currentNode(1) + tolerance) ) && (posRobot(1) > (currentNode(1) - tolerance) ) )
            if( (posRobot(2) < (currentNode(2) + tolerance) ) && (posRobot(2) > (currentNode(2) - tolerance) ) )
                robotIsNearObjective = 1;
%                 robotIsNearObjective
            end
    end
    
    pause(2);
end

function nextNode = goToNextNode(userStructure)
    %TODO Check if not go to far in indice
    userStructure.currentNodeInPath  = userStructure.currentNodeInPath + 1;
    nextNode = userStructure.pathPlanning(userStructure.currentNodeInPath);
end

function uCalc = calcU(model, userStructure)
    robotState = model.state;
    currentPathIndice = userStructure.currentNodeInPath;
    objectiveNodeIndice = userStructure.pathPlanning(1,currentPathIndice);
    objectivePosition = userStructure.nodeMap(1:2, objectiveNodeIndice);
    
    Binv = inverseB(userStructure.B);
    tmpX = calcTmpX(model, objectivePosition, robotState);
%     tmpX
    uCalc = Binv*tmpX;
%     uCalc
end


function Binv = inverseB(B)
    Binv = inv(B' * B) * B';
end

function tmpX = calcTmpX(model, Xwanted, Xprev)
%TODO Find better name
    Xwant = zeros(5,1);%Try with zeros in other state
    Xwant(1:2) = Xwanted;
    
    %Get from TA Code
    dt = 0.01;
    Xprev(1) = dt * ((Xprev(4)+Xprev(5))/2*cos(Xprev(3)));
    Xprev(2) = dt * ((Xprev(4)+Xprev(5))/2*sin(Xprev(3)));
    Xprev(3) = dt * ((Xprev(5)-Xprev(4))/model.track);
    Xprev(4) = 0;
    Xprev(5) = 0;
%     Xwant
%     Xprev
    tmpX = Xwant - Xprev';
%     tmpX
    
    %ADDED SHOULD NOT WORK
%     tmpX(4) = tmpX(2);
%     tmpX(5) = tmpX(1);
%       tmpX(4:5) = tmpX(1:2);
end

function X = getX(model, environment)
    % X = [x y ? vleft v right]
    
end

function testInternet()
%https://www.mathworks.com/help/robotics/examples/path-following-for-a-differential-drive-robot.html?s_tid=gn_loc_drop
    
    controller = robotics.PurePursuit

end
