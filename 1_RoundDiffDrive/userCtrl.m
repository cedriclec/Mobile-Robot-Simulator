
% Problem 1 - Round shaped differential drive robot navigation
% Your control function

function [u, userStructure] = userCtrl(model, environment, userStructure)

    %Solution 1 choose
    % 1. Stop robot
    % 2. Turn robot to be in front of next Node
    % 1. Stop robot
    % 3. Go (Slowly) to next node
    
    %Solution 2 not choose
    % 1. PID

    %Solution 3 not choose
    % 1. Turn robot until Robot inclination is 0 or 180 (according to x)
    % 1. Move Forward until xRobot = xPosition
    % 2. Turn until Robot inclination is +90 or -90 (according to y)
    % 3. Move Forward until yRobot = yPosition 
    % 4. Go to NextNode

%      if(checkIfRobotPositionEqualsNodeObjective(model, userStructure))
%          goToNextNode(userStructure);
%      end
    
    % control input example
    if (    userStructure.currentUobjectif == -1)
        %u = [1 1];
        u = [0 0];
        userStructure.currentUobjectif = 1;
    else
        [u, userStructure] = calcU2(model, userStructure);
    end
    %u
    %userStructure
    %pause(1)
end



function currentNode = getCurrentNode(userStructure)
    currentPathIndice = userStructure.currentNodeInPath;
    objectiveNodeIndice = userStructure.pathPlanning(1,currentPathIndice);
    currentNode = userStructure.nodeMap(1:2, objectiveNodeIndice);
end

function [uCalc, userStructure]  = calcU2(model, userStructure)
    if(userStructure.currentUobjectif == 0)
        %Finish
        uCalc = [-model.state(4) -model.state(5)];
    elseif (userStructure.currentUobjectif == 1)
        %have to stop robot
        [uCalc, userStructure] = calcUtoStopRobot(model, userStructure);
    elseif (userStructure.currentUobjectif == 2)
        %have to turn robot
        [uCalc, userStructure] = calcUtoTurn(model, userStructure);                
    elseif (userStructure.currentUobjectif == 3)
        %have to move forward robot
        [uCalc, userStructure] = calcUtoMoveForward(model, userStructure);
    else
        %have to move forward robot
        uCalc = [0 0]
        userStructure.currentUobjectif = 1;
    end

end

function [uStopRobot, userStructure] = calcUtoStopRobot(model, userStructure)
    display("calcUtoStopRobot")
    minValuePos = 0; %TODO Improve
    minValueNeg = 0 - minValuePos;
    if (IsRobotStop(model))
       %TODO Improve stoping robot
        uStopRobot = [0 0];
        userStructure.currentUobjectif = userStructure.currentUobjectif + 1;
        %userStructure.currentUobjectif = 3;
    else
        %Try to accerate the slowing
           velLeft = - model.state(4) * 100;
           velRight = - model.state(5)* 100;
           uStopRobot = [velLeft velRight];
    end
end

function [uMoveForward, userStructure] = calcUtoMoveForward(model, userStructure)
    display("calcUtoMoveForward")
    if(checkIfRobotPositionEqualsNodeObjective(model, userStructure))
        %TODO Look if finish
        userStructure = goToNextNode(userStructure);
        userStructure.currentUobjectif = 1;
        uMoveForward = [0 0];
    elseif(  robotIsSlow(model))
        %TODO improve move really slowly
        diffVelObjectifLeft = userStructure.velocity - model.state(4);
        diffVelObjectifRight = userStructure.velocity - model.state(5);            
        uMoveForward = [diffVelObjectifLeft diffVelObjectifRight];
    else
        diffVelObjectifLeft = userStructure.velocity - model.state(4);
        diffVelObjectifRight = userStructure.velocity - model.state(5);            
        uMoveForward = [diffVelObjectifLeft diffVelObjectifRight];    
    end
    uMoveForward
    userStructure.currentUobjectif;
end

function isRobotSlow = robotIsSlow(model)
    slow = 0.1;
    isRobotSlow = (abs(model.state(4)) <= slow) || (abs(model.state(5)) <= slow);
    
end

function [utoTurn, userStructure] = calcUtoTurn(model, userStructure)
    display("calcUtoTurn")
    tolerance = 0.1;
    acceleration = userStructure.angleVelocity;
    %If aleft = model.state(4) < 0 => Move vers bas

    inclinationNextNode = calcinclinationNextNode(model, userStructure);
    inclinationDifference = calcinclinationDifference(model, inclinationNextNode);
    inclinationDifference = inclinationDifference;% * abs(inclinationDifference);
    inclinationDifference
    if (inclinationDifference < 0)
    %if (inclinationDifference < 3)
        acceleration = -acceleration;
    end
    %u1 same sign as inclinationDifference
    if ( robotIsSlow(model) )
        %No speed launch acceleration
        display("robotIsSlow")
        u1 = acceleration - model.state(4);
        u2 = - acceleration - model.state(5);
    elseif(abs(inclinationDifference < tolerance))
%         u1 = - acceleration;% * model.state(4);
%         u2 = - u1;

            %TODO KEEP THIS ONE WORK FOR ALL EXEPT HARD
%         u1 = -  model.state(4);% * model.state(4);
%         u2 = - model.state(5);
         u1 = -  model.state(4) * 10;% * model.state(4);
         u2 = - model.state(5) * 10;
        %TMP TEST
        %userStructure.currentUobjectif = userStructure.currentUobjectif + 1;
%     elseif ( (model.state(4) > 0) && (inclinationDifference < 0) )
%         display("inclinationDifference < 0 ")        
%         %Need to slow down
%         u1 = - acceleration;% * model.state(4);
%         u2 = - u1;
%     elseif ( (model.state(4) < 0) && (inclinationDifference > 0) )
%         %Need to slow down
%         display("inclinationDifference > 0 ")        
%         u1 = - acceleration;% * model.state(4);
%         u2 = - u1;
    else
        u1 = 0;
        u2 = 0;
    end
    utoTurn = [u1 u2];
    if( (abs(inclinationDifference) < tolerance) && robotIsSlow(model))    
         userStructure.currentUobjectif = userStructure.currentUobjectif + 1;
         
         %Try to slow again robot
         u1 = -  model.state(4);% * model.state(4);
         u2 = - model.state(5);
         utoTurn = [u1 u2];
    end
    utoTurn
   % pause(0.1)
end

function inclinationDifference = calcinclinationDifference(model, inclinationNextNode)
    angleRobot = model.state(3);
    inclinationDifference = angleRobot - inclinationNextNode;
end


function inclinationNextNode = calcinclinationNextNode(model, userStructure)
    hypotenuse = model.radius;
    pointRobot = model.state(1:2);
    pointObjectif = userStructure.nodeMap(1:2, userStructure.pathPlanning(1, userStructure.currentNodeInPath));
    oppose = pointObjectif(2) - pointRobot(2);
    adjacent = pointObjectif(1) - pointRobot(1);
%     oppose
%     adjacent
%     angleObjectif = atan(oppose/adjacent);
    angleObjectif = atan2(oppose, adjacent);
    
    
    inclinationNextNode = angleObjectif;
%     pause(5);
end
function inclination = calcInclination(model, userStructure)
    hypotenuse = model.radius;
    point = model.state(1:2);
    angle = model.state(3);
    pointProject = zeros(2,1);
    pointProject(1) = point(1) + hypotenuse * cos(angle);
    pointProject(2) = point(2) + hypotenuse * sin(angle);
%     pause(5);
    inclination = pointProject;
    
end

function userStructure = goToNextNode(userStructure)
    %TODO Check if not go to far in indice
    previousNode = userStructure.pathPlanning(1, userStructure.currentNodeInPath);
    userStructure.currentNodeInPath  = userStructure.currentNodeInPath + 1;
    userStructure.pathPlanning(1, userStructure.currentNodeInPath);
    currentNode = userStructure.pathPlanning(1, userStructure.currentNodeInPath);
    %Little Hack Improve this one TODO
     if (currentNode == 0)
        display("Hack for reach the goal") %TODO Improve this
        userStructure.currentNodeInPath  = 0;
%        %currentNode =
     else
        userStructure = updateNodeMapObjectifNode(userStructure, previousNode ,currentNode);
        prev = userStructure.nodeMap(5,previousNode);
        prev
        suiv = userStructure.nodeMap(5,currentNode);
        suiv
     end

end

function userStructure = updateNodeMapObjectifNode(userStructure, previousNode, currentNode)
    userStructure.nodeMap(5,previousNode) = 0;
    previousNode
    currentNode
    userStructure.nodeMap(5,currentNode) = 1;
end
function robotIsStop = IsRobotStop(model)
    tolerance = 0.1;
    robotIsStop = ( (model.state(4) < tolerance) && (model.state(4) > -tolerance) ) && ( (model.state(5) < tolerance) && (model.state(5) > -tolerance) );
    robotIsStop
end

function robotIsNearObjective = checkIfRobotPositionEqualsNodeObjective(model, userStructure)
    robotIsNearObjective = 0;
    currentNodeInPath = userStructure.currentNodeInPath;
    
    currentNodeIndice = userStructure.pathPlanning(1, currentNodeInPath);
%     currentNodeInPath
    %currentNodeIndice
    currentNode = userStructure.nodeMap(1:2, currentNodeIndice);
    posRobot = model.state(1:2);
%     posRobot
%     currentNode
    posWanted = currentNode(1:2);
    posWanted
    posRobot
    
%     posWanted
    %tolerance = model.radius;
    tolerance = 0.2; %TODO 0.3 works really well
    if( (posRobot(1) < (currentNode(1) + tolerance) ) && (posRobot(1) > (currentNode(1) - tolerance) ) )
        if( (posRobot(2) < (currentNode(2) + tolerance) ) && (posRobot(2) > (currentNode(2) - tolerance) ) )
%         if( (posRobot(1) > (currentNode(1) + tolerance) ) && (posRobot(1) < (currentNode(1) - tolerance) ) )
%             if( (posRobot(2) > (currentNode(2) + tolerance) ) && (posRobot(2) < (currentNode(2) - tolerance) ) )
            robotIsNearObjective = 1;
%                 robotIsNearObjective
        end
    end
    
    %pause(2);
end


