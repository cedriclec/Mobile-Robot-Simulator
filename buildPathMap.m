function pathMap = buildPathMap(model, environment, userStructure)
     pointStart = findStartingRobotPosition(userStructure);
    pointStart
     pathMap = buildAllPath(pointStart, userStructure, environment);
end

function nbNode = calcNbNodeMax(xMin, xMax, yMin, YMax, distBetweenNode)
    nbNode = fix( ( (xMax - xMin) * (YMax - yMin) ) / ( distBetweenNode * distBetweenNode) ); %Fix return an integer
    nbNode = nbNode + 100; %Take 100 as secure otherwise don't work in all case (TODO Fix it)
end

function pointStart = findStartingRobotPosition(userStructure)
    nbNode = size(userStructure.nodeMap,2);
    startPointPosition = 4;
    pointStart = 0;%[-100 -100];
    i = 1;
    while ( (pointStart == 0) && (i <= nbNode) )
        if (userStructure.nodeMap(startPointPosition, i) == 1)
            pointStart = i;
%             pointStart(1) = userStructure.nodeMap(1,i);
%             pointStart(2) = userStructure.nodeMap(2,i);
        end
        i = i + 1;
    end
end

function pathMap=buildAllPath(nodeIndice, userStructure, environment)
    nbNode = size(userStructure.nodeMap,2);
    pathMap = zeros(5, nbNode); %*4 cause at maximum 4 path for each node
    pathMap = buildPathForOneNode(nodeIndice, userStructure, environment, pathMap);
end

function pathMap = buildPathForOneNode(nodeIndice, userStructure, environment, pathMap)
    %TODO add previous direction to avoid do circle\
    
     %TODO add COUT A LA MATRICE
     %TODO INCREMENT AT EACH CALL FUNCTION
%     pathMap
%     size(pathMap)
%     nodeIndice
%     pathMap(5, nodeIndice);
    nodeIndice
    if (  ( (testIfInsideeMap(nodeIndice, userStructure)) == 0) || (pathMap(5, nodeIndice)) )
        %Already visited
        display('Has to return')
        return ;
    else    
        display('Has not')
        nodeIndice
        leftGap = calcGap('left', userStructure, environment);
        rightGap = calcGap('right', userStructure, environment);
        downGap = calcGap('down', userStructure, environment);
        upGap = calcGap('up', userStructure, environment);
        leftIndice = 1;
        rightIndice = 2;
        downIndice = 3;
        upIndice = 4;

        %Left case
        leftNode = nodeIndice + leftGap; 
        if (testIfhaveToAddNextNode(nodeIndice, leftNode, leftIndice, userStructure, pathMap) )
            pathMap(leftIndice, nodeIndice) = leftNode;
            pathMap(rightIndice, leftNode) = userStructure.nullValue;                
        end
        %Right case
        rightNode = nodeIndice + rightGap; 
        if (testIfhaveToAddNextNode(nodeIndice, rightNode, rightIndice, userStructure, pathMap) )
            pathMap(rightIndice, nodeIndice) = rightNode;
            pathMap(leftIndice, rightNode) = userStructure.nullValue;                
        end
        %Down case
        downNode = nodeIndice + downGap; 
        if (testIfhaveToAddNextNode(nodeIndice, downNode, downIndice, userStructure, pathMap) )
            pathMap(downIndice, nodeIndice) = downNode;
            pathMap(upIndice, downNode) = userStructure.nullValue;                
        end
        %Up case
        upNode = nodeIndice + upGap; 
        if (testIfhaveToAddNextNode(nodeIndice, upNode, upIndice, userStructure, pathMap) )
            pathMap(upIndice, nodeIndice) = upNode;
            pathMap(downIndice, upNode) = userStructure.nullValue;                
        end
%         nodeIndice
        nodeIndice
        pathMap(5, nodeIndice) = 1; %He is visited
        pathMap = buildPathForOneNode(leftNode, userStructure, environment, pathMap);
        pathMap = buildPathForOneNode(rightNode, userStructure, environment, pathMap);
        pathMap = buildPathForOneNode(downNode, userStructure, environment, pathMap);
        pathMap = buildPathForOneNode(upNode, userStructure, environment, pathMap);
    end
end

function haveToAddNextNode = testIfhaveToAddNextNode(nodeIndice, nextNodeIndice, nodeDirectionIndice, userStructure, pathMap)
    haveToAddNextNode = 0;
    if (testIfInsideeMap(nextNodeIndice, userStructure) && testIfInsideeMap(nodeIndice, userStructure) )
%         nodeDirectionIndice
%         nodeIndice
        if (pathMap(nodeDirectionIndice, nodeIndice) == 0)
            if  (testIfNoObstacle(nextNodeIndice, userStructure))
                haveToAddNextNode = 1;
            end
        end
    end
    %haveToAddNextNode = ( (pathMap(nodeDirectionIndice, nodeIndice) == 0) & testIfNoOutsideMap(nextNodeIndice, userStructure) & testIfNoObstacle(nextNodeIndice, userStructure) );
end

function insideMap = testIfInsideeMap(nodeIndice, userStructure)
    nbNode = size(userStructure.nodeMap,2);
    insideMap = 0;
    if ( (nodeIndice >= 1) && (nodeIndice <= nbNode) )
        insideMap = 1;
    end
end

function noObstacle = testIfNoObstacle(nodeIndice, userStructure)
    currentNode = userStructure.nodeMap(nodeIndice);
    noObstacle = 0;
    if ( currentNode(1) ~= -100 )
            noObstacle = 1;
    end
end

function value = calcGap(direction, userStructure, environment)
    distHauteur = abs(environment.plotArea(1) - environment.plotArea(2)); % TODO Check if right order (It it is not 1,2)
    nbNodeHauteur = distHauteur / userStructure.nodeInterval.current;
    switch direction
        case 'left'
            value = -1;
        case 'right'
            value = 1;
        case 'up'
            value = nbNodeHauteur;
        case 'down'
            value = - nbNodeHauteur;
    end
end