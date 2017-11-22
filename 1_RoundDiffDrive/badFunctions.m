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