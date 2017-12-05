function pathMap = buildPathForOneNode(nodeIndice, userStructure, environment, pathMap)
    %Recursive way
    %TODO add previous direction to avoid do circle\
    
     %TODO add COUT A LA MATRICE
     %TODO INCREMENT AT EACH CALL FUNCTION
%     pathMap
%     size(pathMap)
%     nodeIndice
%     pathMap(5, nodeIndice);
%     nodeIndice
    if (  ( (testIfInsideeMap(nodeIndice, userStructure)) == 0) || (pathMap(5, nodeIndice)) )
        %Already visited
%         display('Has to return')
        return ;
     else    
%         display('Has not')
%         nodeIndice
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
        %nodeIndice
        pathMap(5, nodeIndice) = 1; %He is visited
        pathMap = buildPathForOneNode(leftNode, userStructure, environment, pathMap);
        pathMap = buildPathForOneNode(rightNode, userStructure, environment, pathMap);
        pathMap = buildPathForOneNode(downNode, userStructure, environment, pathMap);
        pathMap = buildPathForOneNode(upNode, userStructure, environment, pathMap);
    end
end

function [u, userStructure] = userCtrl(model, environment, userStructure)

    % previously defined value as an example at userInit function
    % used as a global variable, so that this will change as 0, 1, 2, ....
    % at every iteration
    %userStructure.exampleVariable = userStructure.exampleVariable + 1;
    
    % control input example
    u = [0.5; -0.5];
    if(environment.time < 5)
        u = [0.5; -0.5];
    elseif(environment.time < 15)
        u = [0; 0.5];
    else
        u = [-0.3; 0];
    end
end

function isInside = IsInsideObstacle(x, y, obstacleMap)
    obstSize = size(obstacleMap);
    isInside = 0;
    for i = 1 : 4 : obstSize(2)
        edgeObstacle = getObstacleEdge(i,obstacleMap);
        if( (x >= edgeObstacle(1) & x <= edgeObstacle(2) ) )
            if (  (y >= edgeObstacle(3) & y <= edgeObstacle(4) ) )
                isInside = 1;
                isInside;
                return ;
            end
        end
    end
    return ;
    

function edgeObstacle = getObstacleEdge(startPoint,obstacleMap)
%Do not work try to use point on a vect with one point
    edgeObstacle = [-100 -100 -100 -100]
    edgeObstacle(1) = min([ obstacleMap(1, startPoint) obstacleMap(3, startPoint) obstacleMap(1, startPoint + 1) obstacleMap(3, startPoint + 1) obstacleMap(1, startPoint + 2) obstacleMap(3, startPoint + 2) obstacleMap(1, startPoint + 3) obstacleMap(3, startPoint + 3) ]);
    edgeObstacle(2) = max([ obstacleMap(1, startPoint) obstacleMap(3, startPoint) obstacleMap(1, startPoint + 1) obstacleMap(3, startPoint + 1) obstacleMap(1, startPoint + 2) obstacleMap(3, startPoint + 2) obstacleMap(1, startPoint + 3) obstacleMap(3, startPoint + 3) ]);
    edgeObstacle(3) = min([ obstacleMap(2, startPoint) obstacleMap(4, startPoint) obstacleMap(2, startPoint + 1) obstacleMap(4, startPoint + 1) obstacleMap(2, startPoint + 2) obstacleMap(4, startPoint + 2) obstacleMap(2, startPoint + 3) obstacleMap(4, startPoint + 3) ]);
    edgeObstacle(4) = max([ obstacleMap(2, startPoint) obstacleMap(4, startPoint) obstacleMap(2, startPoint + 1) obstacleMap(4, startPoint + 1) obstacleMap(2, startPoint + 2) obstacleMap(4, startPoint + 2) obstacleMap(2, startPoint + 3) obstacleMap(4, startPoint + 3) ]);
end


function obstacleMap3 = buildObstacleMap3(model, environment)
    map = robotics.BinaryOccupancyGrid(20,20) %Todo makte it more general
    mapDecaleOrigine = environment.corner + 10
    show(map)
    setOccupancy(map, mapDecaleOrigine, 1)
    show(map)
%     mapInflated = robotics.BinaryOccupancyGrid(environment.corner);
%     %mapInflated = environment.corner;
%     inflate(mapInflated,model.radius);
    obstacleMap = map;
end

% function inflation = calcInflation(point)
%     if (point < 0)
%           
% end


function obstacleMap2 = buildObstacleMap2(model, environment)
%     %TODO : Check if it is not ouside

     dim = size(environment.corner)
     nbPointPerCol = dim(1)
     nbPointPerColForObs = dim(1) * 4
     nbRow = dim(2) %Replace by nbCol
     obstacleMap = zeros(nbPointPerCol, nbRow * 16)%*4 caus each line give one square (4 lines)
     radius = model.radius
     xMin = environment.plotArea(1)
     xMax = environment.plotArea(2)
     yMin = environment.plotArea(3)
     YMax = environment.plotArea(4)

     for j = 0 : nbRow - 1 
         i = 0
         %Left
         nbRow
         j
         size(obstacleMap)
         j*nbRow  + 1 + i*nbPointPerCol
         j*nbRow + 1
         obstacleMap(j*nbPointPerColForObs  + 1 + i*nbPointPerCol) = environment.corner(j*nbPointPerCol + 1) - radius;
         obstacleMap(j*nbPointPerColForObs  + 2 + i*nbPointPerCol) = environment.corner(j*nbPointPerCol + 2) + radius;
         obstacleMap(j*nbPointPerColForObs  + 3 + i*nbPointPerCol) = environment.corner(j*nbPointPerCol + 1) - radius;
         obstacleMap(j*nbPointPerColForObs  + 4 + i*nbPointPerCol) = environment.corner(j*nbPointPerCol + 2) - radius;
         %down
         i = i + 1;
         obstacleMap(j*nbPointPerColForObs  + 1 + i*nbPointPerCol) = environment.corner(j*nbPointPerCol + 1) - radius;
         obstacleMap(j*nbPointPerColForObs  + 2 + i*nbPointPerCol) = environment.corner(j*nbPointPerCol + 2) - radius;
         obstacleMap(j*nbPointPerColForObs  + 3 + i*nbPointPerCol) = environment.corner(j*nbPointPerCol + 3) + radius;
         obstacleMap(j*nbPointPerColForObs  + 4 + i*nbPointPerCol) = environment.corner(j*nbPointPerCol + 4) - radius;        
         %Right
         i = i + 1;
         obstacleMap(j*nbPointPerColForObs  + 1 + i*nbPointPerCol) = environment.corner(j*nbPointPerCol + 3) + radius;
         obstacleMap(j*nbPointPerColForObs  + 2 + i*nbPointPerCol) = environment.corner(j*nbPointPerCol + 4) - radius;
         obstacleMap(j*nbPointPerColForObs  + 3 + i*nbPointPerCol) = environment.corner(j*nbPointPerCol + 3) + radius;
         obstacleMap(j*nbPointPerColForObs  + 4 + i*nbPointPerCol) = environment.corner(j*nbPointPerCol + 4) + radius;
         %Up
         i = i + 1;
         obstacleMap(j*nbPointPerColForObs  + 1 + i*nbPointPerCol) = environment.corner(j*nbPointPerCol + 3) + radius;
         obstacleMap(j*nbPointPerColForObs  + 2 + i*nbPointPerCol) = environment.corner(j*nbPointPerCol + 4) + radius;
         obstacleMap(j*nbPointPerColForObs  + 3 + i*nbPointPerCol) = environment.corner(j*nbPointPerCol + 1) - radius;
         obstacleMap(j*nbPointPerColForObs  + 4 + i*nbPointPerCol) = environment.corner(j*nbPointPerCol + 2) + radius;        
         
         %obstacleMap(i+(j-1)*(nbRow)) = environment.corner(i+(j-1)*(nbRow)) - radius
     end
end

function Xnext = calcX(X, U, model)
    % X = [x y ? vleft v right]
    % CF projet pdf for explanation on equation

  Xnext = zeros(size(X),1);
  vleft = X(4);
  vright = X(5);
  theta = X(3);
  
  aleft = U(1);
  aright = U(2);
  
  d = model.radius; %Check if true
  Xnext(1) = ( ( vleft + vright )* cos(theta) ) /2;
  Xnext(2) = ( ( vleft + vright )* sin(theta) ) /2;
  Xnext(3) = (vright - vleft)/d;
  
end

function Y = calcY(X, U)
    %Y = [X Y]
    Y = zeros(2,1);
    Y(1) = X(1);
    Y(2) = X(2);
end