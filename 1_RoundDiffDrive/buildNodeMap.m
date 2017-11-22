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
     
     nodeMap = zeros(2, nbNode);

     currentNode = 0;
     for i = xMin : distBetweenNode : xMax
        for j = yMin : distBetweenNode : YMax
            currentNode = currentNode + 1;
            isInside = IsInsideObstacle(model, i,j,environment);
            if (isInside == 1)
                nodeMap(currentNode) = 0;
                currentNode = currentNode + 1;
                nodeMap(currentNode) = 0;
            else
                nodeMap(currentNode) = i;
                currentNode = currentNode + 1;
                nodeMap(currentNode) = j;
            end
        end
     end

end

function nbNode = calcNbNodeMax(xMin, xMax, yMin, YMax, distBetweenNode)
    nbNode = fix( ( (xMax - xMin) * (YMax - yMin) ) / ( distBetweenNode * distBetweenNode) ); %Fix return an integer
    nbNode = nbNode + 100; %Take 100 as secure otherwise don't work in all case (TODO Fix it)
end