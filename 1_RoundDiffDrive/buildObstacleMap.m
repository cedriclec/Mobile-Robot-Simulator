function obstacleMap = buildObstacleMap(model, environment)
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
         pointA = [environment.corner(j*nbPointPerCol + 1) environment.corner(j*nbPointPerCol + 2)];
         pointB = [environment.corner(j*nbPointPerCol + 3) environment.corner(j*nbPointPerCol + 4)];
         points = calcPointsObstacle(pointA, pointB, model.radius);
         %Left
%          nbRow
%          j
%          size(obstacleMap)
%          j*nbRow  + 1 + i*nbPointPerCol
%          j*nbRow + 1
         pointA
         pointB
         points
         obstacleMap(j*nbPointPerColForObs  + 1 + i*nbPointPerCol) = points(1); %environment.corner(j*nbPointPerCol + 1) - radius;
         obstacleMap(j*nbPointPerColForObs  + 2 + i*nbPointPerCol) = points(2);% environment.corner(j*nbPointPerCol + 2) + radius;
         obstacleMap(j*nbPointPerColForObs  + 3 + i*nbPointPerCol) = points(3); %environment.corner(j*nbPointPerCol + 1) - radius;
         obstacleMap(j*nbPointPerColForObs  + 4 + i*nbPointPerCol) = points(4); %environment.corner(j*nbPointPerCol + 2) - radius;
         %down
         i = i + 1;
         obstacleMap(j*nbPointPerColForObs  + 1 + i*nbPointPerCol) = points(3);
         obstacleMap(j*nbPointPerColForObs  + 2 + i*nbPointPerCol) = points(4);
         obstacleMap(j*nbPointPerColForObs  + 3 + i*nbPointPerCol) = points(7);
         obstacleMap(j*nbPointPerColForObs  + 4 + i*nbPointPerCol) = points(8);    
         %Right
         i = i + 1;
         obstacleMap(j*nbPointPerColForObs  + 1 + i*nbPointPerCol) = points(7);
         obstacleMap(j*nbPointPerColForObs  + 2 + i*nbPointPerCol) = points(8);
         obstacleMap(j*nbPointPerColForObs  + 3 + i*nbPointPerCol) = points(5);
         obstacleMap(j*nbPointPerColForObs  + 4 + i*nbPointPerCol) = points(6);
         %Up
         i = i + 1;
         obstacleMap(j*nbPointPerColForObs  + 1 + i*nbPointPerCol) = points(5);
         obstacleMap(j*nbPointPerColForObs  + 2 + i*nbPointPerCol) = points(6);
         obstacleMap(j*nbPointPerColForObs  + 3 + i*nbPointPerCol) = points(1);
         obstacleMap(j*nbPointPerColForObs  + 4 + i*nbPointPerCol) = points(2);
    end
end

function vector = calcVector(ptA, ptB)
    vector = [(ptB(1) - ptA(1)) (ptB(2) - ptA(2))];
end

function dist = calcDistance(vect)
    dist = norm(vect);
end

function ptsArray = calcPointsObstacle(ptA, ptB, radius)

     vect = calcVector(ptA, ptB);
     dist = norm(vect);
     coef = calcCoeffDistRadius(dist, radius);
     litleVect = calcLittleVect(coef, vect)
     
     ptProjectA = calcProjectionPoint(ptA, litleVect);
     ptsObsA =  calcptsObstacle(ptProjectA, litleVect)
     
     ptProjectB = calcProjectionPoint(ptB, -litleVect);
     ptsObsB =  calcptsObstacle(ptProjectB, litleVect)
     
     ptsArray = [ptsObsA ptsObsB]
%      ptsArray(1) = pts(1) ;
%      ptsArray(2) = pts(2);
%      ptsArray(3) = pts(1) + 0.5;
%      ptsArray(4) = pts(2) + 0.5;
end

function ptsObstacle = calcptsObstacle(ptProject, littleVec)
    ptsObstacle(1) = ptProject(1) + littleVec(2)
    ptsObstacle(2) = ptProject(2) - littleVec(1)
    ptsObstacle(3) = ptProject(1) - littleVec(2)
    ptsObstacle(4) = ptProject(2) + littleVec(1)
end

function litleVect = calcLittleVect(coef, vector)
    litleVect = [0 0]
    if(vector(1) ~= 0)
        litleVect(1) = vector(1)/coef
    end
    if(vector(2) ~= 0)
        litleVect(2) = vector(2)/coef
    end
end


function ptProject = calcProjectionPoint(pt, litleVect)
    ptProject = pt - litleVect;
end
        
function coef = calcCoeffDistRadius(dist, radius)
    coef = dist/radius
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