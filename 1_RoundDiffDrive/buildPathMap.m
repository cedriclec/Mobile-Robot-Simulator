function pathMap = buildPathMap(model, environment, userStructure)
     pointStart = findStartingRobotPosition(userStructure);
     pathMap = buildAllPath(pointStart, userStructure, environment);
end

function pointStart = findStartingRobotPosition(userStructure)
    nbNode = size(userStructure.nodeMap,2);
    startPointPosition = 4;
    pointStart = 0;
    i = 1;
    while ( (pointStart == 0) && (i <= nbNode) )
        if (userStructure.nodeMap(startPointPosition, i) == 1)
            pointStart = i;

        end
        i = i + 1;
    end
end

function pathMap=buildAllPath(nodeIndice, userStructure, environment)
    nbNode = size(userStructure.nodeMap,2);
    pathMap = zeros(5, nbNode);
    pathMap = buildPathForOneNode(nodeIndice, userStructure, environment, pathMap);
end

function pathMap = buildPathForOneNode(nodeIndice, userStructure, environment, pathMap)
    %Iterative way
    
     %TODO add COUT A LA MATRICE
     %TODO INCREMENT AT EACH CALL FUNCTION

    if (  ( (testIfInsideeMap(nodeIndice, userStructure)) == 0) || (pathMap(5, nodeIndice)) )

        return ;
     else    

        leftGap = calcGap('left', userStructure, environment);
        rightGap = calcGap('right', userStructure, environment);
        downGap = calcGap('down', userStructure, environment);
        upGap = calcGap('up', userStructure, environment);
        leftIndice = 1;
        rightIndice = 2;
        downIndice = 3;
        upIndice = 4;
        
        nbNode = size(pathMap,2);
        nodeToExplore = zeros(1,nbNode);
        i = 1;
        nodeToExplore(i) = nodeIndice;
        remainNodesForNextIteration = i;
        currentIterationNodesDone = 0;
        costCurrent = 1;
        lastFreeSpace = i + 1;
        while ( (i <= nbNode) && (nodeToExplore(i) ~= 0) )
            nodeIndice = nodeToExplore(i);
            
            if (  ( (testIfInsideeMap(nodeIndice, userStructure)) == 0) || (pathMap(5, nodeIndice)) )
                i = i + 1;
            else
                
                %Left case
                leftNode = nodeIndice + leftGap;
                if (testIfhaveToAddNextNode(nodeIndice, leftNode, leftIndice, userStructure, pathMap) )
                    pathMap(leftIndice, nodeIndice) = leftNode;
                    pathMap(rightIndice, leftNode) = userStructure.nullValue;
                    
                    nodeToExplore(lastFreeSpace) = leftNode;
                    lastFreeSpace = lastFreeSpace + 1;
                end
                %Right case
                rightNode = nodeIndice + rightGap; 
                if (testIfhaveToAddNextNode(nodeIndice, rightNode, rightIndice, userStructure, pathMap) )
                    pathMap(rightIndice, nodeIndice) = rightNode;
                    pathMap(leftIndice, rightNode) = userStructure.nullValue;
                    
                    nodeToExplore(lastFreeSpace) = rightNode;
                    lastFreeSpace = lastFreeSpace + 1;
                end
                %Down case
                downNode = nodeIndice + downGap; 
                if (testIfhaveToAddNextNode(nodeIndice, downNode, downIndice, userStructure, pathMap) )
                    pathMap(downIndice, nodeIndice) = downNode;
                    pathMap(upIndice, downNode) = userStructure.nullValue;
                    
                    nodeToExplore(lastFreeSpace) = downNode;
                    lastFreeSpace = lastFreeSpace + 1;
                end
                %Up case
                upNode = nodeIndice + upGap; 
                if (testIfhaveToAddNextNode(nodeIndice, upNode, upIndice, userStructure, pathMap) )
                    pathMap(upIndice, nodeIndice) = upNode;
                    pathMap(downIndice, upNode) = userStructure.nullValue;
                    
                    nodeToExplore(lastFreeSpace) = upNode;
                    lastFreeSpace = lastFreeSpace + 1;
                end

                pathMap(5, nodeIndice) = 1; %He is visited

                i = i + 1;
            end
        end
    end
end

function haveToAddNextNode = testIfhaveToAddNextNode(nodeIndice, nextNodeIndice, nodeDirectionIndice, userStructure, pathMap)
    haveToAddNextNode = 0;
    if (testIfInsideeMap(nextNodeIndice, userStructure) && testIfInsideeMap(nodeIndice, userStructure) )
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
    currentNode = userStructure.nodeMap(1:2, nodeIndice);
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