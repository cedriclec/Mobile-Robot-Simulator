function idealPathMap = buildIdealPathMap(environment, userStructure)
     startPoint = findStartRobotPosition(userStructure);
     idealPathMap = buildIdealPath(startPoint, userStructure, environment);
end

function startPoint = findStartRobotPosition(userStructure)
    nbNode = size(userStructure.nodeMap,2);
    startPointPosition = 3;
    startPoint = 0;
    i = 1;
    while ( (startPoint == 0) && (i <= nbNode) )
        if (userStructure.nodeMap(startPointPosition, i) == 1)
            startPoint = i;
        end
        i = i + 1;
    end
%     startPoint
%     %HACK Cause path neighbor are -100
     %startPoint = startPoint + 1;
%     startPoint
end

function idealPath = buildIdealPath(startPoint, userStructure, environment)
    %======CACA
    %IdealPath(node) = [nextNode traveledBool]
    %IdealPath(1) = [startPoint 0]
    
    %===========Better
    %IdealPath(i) = [currentNode traveledBool]
    %IdealPath(i + 1) = [nextNode 0]
    nbNode = size(userStructure.nodeMap,2);
    idealPath = zeros(2, nbNode);
    i = 1;
    
    %startPoint = 248; %Delete it qfter
    idealPath(i) = startPoint;
    nextNode = startPoint;
    

    while( ( (i < nbNode) && (i > 0) ) && ( checkIfhaveReachedGoal(nextNode, userStructure) == 0) )% && 0
        nextNode = takeMinCostNextNode(nextNode, userStructure);
        idealPath(i) = nextNode;
        i = i + 1;
    end
   
    
end

function haveReachedGoal = checkIfhaveReachedGoal(nodeIndice ,userStructure)
    haveReachedGoal = 0;
    goalIndice = 4;
    if (userStructure.nodeMap(goalIndice, nodeIndice) == 1)
        haveReachedGoal= 1;
    end
end

function nextNode = takeMinCostNextNode(nodeIndice, userStructure)

    globalPathMap = userStructure.globalPathMap;
    currentPath = globalPathMap(:, nodeIndice);
    maxNodeIndice = getNodeWithMinCost(currentPath, userStructure);
    nextNode = globalPathMap(maxNodeIndice,nodeIndice);
    
end

function nodeWithMinCost = getNodeWithMinCost(currentPath, userStructure)
    nodeWithMinCost = 0;
    node = zeros(2,4);
    node(:,1) = [getCostPathNode(currentPath(1), userStructure) 1];
    node(:,2) = [getCostPathNode(currentPath(2), userStructure) 2];
    node(:,3) = [getCostPathNode(currentPath(3), userStructure) 3];
    node(:,4) = [getCostPathNode(currentPath(4), userStructure) 4];
    
    nodeBiggerValue = min(node(1,:));
    if (nodeBiggerValue == node(1,1))
        nodeWithMinCost = 1;
    end
    if (nodeBiggerValue == node(1,2))
        nodeWithMinCost = 2;
    end
    if (nodeBiggerValue == node(1,3))
        nodeWithMinCost = 3;
    end
    if (nodeBiggerValue == node(1,4))
        nodeWithMinCost = 4;
    end
end

function costPathNode = getCostPathNode(nodeIndice, userStructure)
    costPathNode = intmax; %Value for unvalid node (-100)
    costIndice = 6;
    if (nodeIndice > 0)
       costPathTmp = userStructure.globalPathMap(costIndice, nodeIndice);
       if (costPathTmp > 0 && costPathTmp < intmax)
         costPathNode = costPathTmp;
       end

    end
end