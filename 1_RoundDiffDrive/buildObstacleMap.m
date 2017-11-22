function obstacleMap = buildObstacleMap(model, environment)
     dim = size(environment.corner);
     nbPointPerCol = dim(1);
     nbPointPerColForObs = dim(1) * 4;
     nbCol = dim(2); %Replace by nbCol
     obstacleMap = zeros(nbPointPerCol, nbCol * 16); %4 caus each line give one square (4 lines of each 2 points => 4 * 2 *2)
     radius = model.radius;
     
%     %TODO : Check if it is not ouside
     xMin = environment.plotArea(1);
     xMax = environment.plotArea(2);
     yMin = environment.plotArea(3);
     YMax = environment.plotArea(4);
     
    for j = 0 : nbCol - 1 
         i = 0;
         %Todo put it in a function => More proper
         pointA = [environment.corner(j*nbPointPerCol + 1) environment.corner(j*nbPointPerCol + 2)];
         pointB = [environment.corner(j*nbPointPerCol + 3) environment.corner(j*nbPointPerCol + 4)];
         
         points = calcPointsObstacle(pointA, pointB, radius);
         %Left
         %Todo put it in a function => More redable
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

function ptsArray = calcPointsObstacle(ptA, ptB, radius)

     vect = calcVector(ptA, ptB);
     dist = calcDistance(vect);
     coef = calcCoeffDistRadius(dist, radius);
     litleVect = calcLittleVect(coef, vect);
     
     ptProjectA = calcProjectionPoint(ptA, litleVect);
     ptsObstacleA =  calcptsObstacle(ptProjectA, litleVect);
     
     ptProjectB = calcProjectionPoint(ptB, -litleVect);
     ptsObstacleB =  calcptsObstacle(ptProjectB, litleVect);
     
     ptsArray = [ptsObstacleA ptsObstacleB];
end

function ptsObstacle = calcptsObstacle(ptProject, littleVec)
    ptsObstacle(1) = ptProject(1) + littleVec(2);
    ptsObstacle(2) = ptProject(2) - littleVec(1);
    ptsObstacle(3) = ptProject(1) - littleVec(2);
    ptsObstacle(4) = ptProject(2) + littleVec(1);
end

function litleVect = calcLittleVect(coef, vector)
    litleVect = [0 0];
    if(vector(1) ~= 0)
        litleVect(1) = vector(1)/coef;
    end
    if(vector(2) ~= 0)
        litleVect(2) = vector(2)/coef;
    end
end


function ptProject = calcProjectionPoint(pt, litleVect)
    ptProject = pt - litleVect;
end
        
function coef = calcCoeffDistRadius(dist, radius)
    coef = dist/radius;
end

function dist = calcDistance(vect)
    dist = norm(vect);
end
