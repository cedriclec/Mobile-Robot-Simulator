function globalPathMap = buildGlobalPathMap(environment, userStructure)
     goalPoint = findGoalRobotPosition(userStructure);
     globalPathMap = buildAllPath(goalPoint, userStructure, environment);
end

function goalPoint = findGoalRobotPosition(userStructure)
    nbNode = size(userStructure.nodeMap,2);
    goalPointPosition = 4;
    goalPoint = 0;
    i = 1;
    while ( (goalPoint == 0) && (i <= nbNode) )
        if (userStructure.nodeMap(goalPointPosition, i) == 1)
            goalPoint = i;
        end
        i = i + 1;
    end
end

function pathMap=buildAllPath(nodeIndice, userStructure, environment)
    nbNode = size(userStructure.nodeMap,2);
        nbNode = nbNode * 2;
    
    
    pathMap = zeros(6, nbNode);
    pathMap = buildPathForOneNode(nodeIndice, userStructure, environment, pathMap);
    
    pathMap = createEveryLinkBetweenNode(pathMap, userStructure, environment);
end

function pathMap = buildPathForOneNode(nodeIndice, userStructure, environment, pathMap)
    %Iterative way

    visitedIndice = 5;

    if (  ( (testIfInsideeMap(nodeIndice, userStructure)) == 0) || (pathMap(visitedIndice, nodeIndice)) )

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
        costIndice = 6;

        nbNode = size(pathMap,2);
        nodeToExplore = zeros(1,nbNode);
        i = 1;
        nodeToExplore(i) = nodeIndice;
        nodesForNextIteration = 0;
        nodesForCurrentIteration = 1;
        currentIterationNodesDone = 0;
        costCurrent = 1;
        lastFreeSpace = i + 1;
        while ( (i <= nbNode) && (nodeToExplore(i) ~= 0) )
            nodeIndice = nodeToExplore(i);
            if ( currentIterationNodesDone >= nodesForCurrentIteration)
                costCurrent = costCurrent + 1;
                currentIterationNodesDone = 0;
                nodesForCurrentIteration = nodesForNextIteration;
                nodesForNextIteration = 0;
            end
            
            if (  ( (testIfInsideeMap(nodeIndice, userStructure)) == 0) || (pathMap(visitedIndice, nodeIndice)) )
                i = i + 1;
                currentIterationNodesDone = currentIterationNodesDone + 1;
         
            else
                %Left case
                leftNode = nodeIndice + leftGap;
                if (testIfhaveToAddNextNode(nodeIndice, leftNode, leftIndice, userStructure, pathMap) )
                    pathMap(leftIndice, nodeIndice) = leftNode;
                    pathMap(rightIndice, leftNode) = userStructure.nullValue;
                    
                     if ( checkIfhaveReachedStartPoint(nodeIndice, userStructure) == 0)
                        nodeToExplore(lastFreeSpace) = leftNode;
                        lastFreeSpace = lastFreeSpace + 1;
                        nodesForNextIteration = nodesForNextIteration + 1;
                     end
                  
                    
                    
                    pathMap(costIndice, nodeIndice) = costCurrent;
                end
                %Right case
                rightNode = nodeIndice + rightGap; 
                if (testIfhaveToAddNextNode(nodeIndice, rightNode, rightIndice, userStructure, pathMap) )
                    pathMap(rightIndice, nodeIndice) = rightNode;
                    pathMap(leftIndice, rightNode) = userStructure.nullValue;

                     if ( checkIfhaveReachedStartPoint(nodeIndice, userStructure) == 0)
                        nodeToExplore(lastFreeSpace) = rightNode;
                        lastFreeSpace = lastFreeSpace + 1;
                        nodesForNextIteration = nodesForNextIteration + 1;
                     end
                    
                    
                    pathMap(costIndice, nodeIndice) = costCurrent;
                end
                %Down case
                downNode = nodeIndice + downGap; 
                if (testIfhaveToAddNextNode(nodeIndice, downNode, downIndice, userStructure, pathMap) )
                    pathMap(downIndice, nodeIndice) = downNode;
                    pathMap(upIndice, downNode) = userStructure.nullValue;
                    
                     if ( checkIfhaveReachedStartPoint(nodeIndice, userStructure) == 0)
                        nodeToExplore(lastFreeSpace) = downNode;
                        lastFreeSpace = lastFreeSpace + 1;
                        nodesForNextIteration = nodesForNextIteration + 1;
                     end
                    
                    
                    pathMap(costIndice, nodeIndice) = costCurrent;
                end
                %Up case
                upNode = nodeIndice + upGap; 
                if (testIfhaveToAddNextNode(nodeIndice, upNode, upIndice, userStructure, pathMap) )
                    pathMap(upIndice, nodeIndice) = upNode;
                    pathMap(downIndice, upNode) = userStructure.nullValue;
                    
                     if ( checkIfhaveReachedStartPoint(nodeIndice, userStructure) == 0)
                        nodeToExplore(lastFreeSpace) = upNode;
                        lastFreeSpace = lastFreeSpace + 1;
                        nodesForNextIteration = nodesForNextIteration + 1;
                    end
                    
             
                    
                    pathMap(costIndice, nodeIndice) = costCurrent;
                end

                pathMap(visitedIndice, nodeIndice) = 1; %It is visited

                i = i + 1;
                currentIterationNodesDone = currentIterationNodesDone + 1;
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

function haveReachedStartPoint = checkIfhaveReachedStartPoint(nodeIndice, userStructure)
    currentNode = userStructure.nodeMap(3, nodeIndice);
    haveReachedStartPoint = 0;
    if ( currentNode == 1 )
        haveReachedStartPoint = 1;
        userStructure.nodeMap(:, nodeIndice);
    end 
end

function value = calcGap(direction, userStructure, environment)
    distHauteur = abs(environment.plotArea(1) - environment.plotArea(2));
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

function pathMap = createEveryLinkBetweenNode(pathMap, userStructure, environment)
    %Have to implement this function to recreate every link between Nodes

    sizeMap = size(pathMap,2);
    leftGap = calcGap('left', userStructure, environment);
    rightGap = calcGap('right', userStructure, environment);
    downGap = calcGap('down', userStructure, environment);
    upGap = calcGap('up', userStructure, environment);
    for i = 1 : sizeMap
        if (pathMap(1,i) == -100)
            pathMap(1,i) = i + leftGap;
        end
        if (pathMap(2,i) == -100)
            pathMap(2,i) = i + rightGap;
        end
        if (pathMap(3,i) == -100)
            pathMap(3,i) = i + downGap;
        end
        if (pathMap(4,i) == -100)
            pathMap(4,i) = i + upGap;
        end
    end
end