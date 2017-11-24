function pathMap = buildPathMap(model, environment, userStructure)
     distBetweenNode = userStructure.nodeInterval.current;
     startGap = userStructure.nodeInterval.min;
     pathMap = startGap;

end

function nbNode = calcNbNodeMax(xMin, xMax, yMin, YMax, distBetweenNode)
    nbNode = fix( ( (xMax - xMin) * (YMax - yMin) ) / ( distBetweenNode * distBetweenNode) ); %Fix return an integer
    nbNode = nbNode + 100; %Take 100 as secure otherwise don't work in all case (TODO Fix it)
end

function pointStart = findStartingRobotPosition(userStructure)
    
end