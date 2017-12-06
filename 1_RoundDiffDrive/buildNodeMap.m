function nodeMap = buildNodeMap(model, environment, userStructure)
     distBetweenNode = userStructure.nodeInterval.current;
     startGap = userStructure.nodeInterval.min;
     xMin = environment.plotArea(1);
     xMax = environment.plotArea(2);
     yMin = environment.plotArea(3);
     YMax = environment.plotArea(4);
     nbNode = calcNbNodeMax(xMin, xMax, yMin, YMax, distBetweenNode);

     %Do not want to start a point 0
     xMin = xMin + startGap ;  
     yMin = yMin + startGap;

     nodeMap = zeros(5, nbNode);
     %nodeMap(5) = 1 Objectif for robot control

     currentNode = 0;
     for i = xMin : distBetweenNode : xMax
        for j = yMin : distBetweenNode : YMax
            currentNode = currentNode + 1;
            isInside = IsInsideObstacle(model, i,j,environment);
            if (isInside == 1)
                nodeMap(1, currentNode) = -100;
                nodeMap(2, currentNode) = -100;
            else
                nodeMap(1, currentNode) = i;
                nodeMap(2, currentNode) = j;
            end
            
                if (isNearObjective(i, j, model.state, model))
                    nodeMap(3, currentNode) = 1;
                else
                    nodeMap(3, currentNode) = 0;
                end
                if (isNearObjective(i, j, environment.stateGoal, model))
                    nodeMap(4, currentNode) = 1;
                else
                    nodeMap(4, currentNode) = 0;
                end

        end
     end
     nodeMap(1:2, 1) = environment.stateGoal(1:2);

end

function nbNode = calcNbNodeMax(xMin, xMax, yMin, YMax, distBetweenNode)
    nbNode = fix( ( (xMax - xMin) * (YMax - yMin) ) / ( distBetweenNode * distBetweenNode) ); %Fix return an integer
    nbNode = nbNode + 100; %Take 100 as secure otherwise don't work in all case (TODO Fix it)
end
