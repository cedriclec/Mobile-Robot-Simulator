
% Problem 1 - Round shaped differential drive robot navigation
% Plot function

function plotAll(model, env, userStructure)

    figure(1);
    plot(-9999,-9999); % dummy plot for holding on other things
    hold on;
    
    % draw current robot state
    drawRobot(model);
    
    % draw goal robot state
    modelGoal = model;
    modelGoal.state = env.stateGoal;
    drawRobotGoal(modelGoal);
    
    % draw environment
    drawEnvironment(env);
    
    
    %Comment Them if you want control faster
    
    %Enlarge the obstacles around 
    %drawObstacle(userStructure);
    
    %drawNodes(userStructure);
    %drawGlobalPath(userStructure);
    drawOptimalPath(userStructure);
    hold off;
    axis equal;
    axis(env.plotArea);
    str = sprintf('Time = %f, x = %f, y = %f, theta = %f\nleft angular vel. = %f, right angular vel. = %f',env.time, model.state(1), model.state(2), model.state(3), model.state(4), model.state(5));
    title(str);
    drawnow;
    
end

function drawRobot(model)

    % rotation matrix
    rotM = [cos(model.state(3)), -sin(model.state(3)); sin(model.state(3)), cos(model.state(3))];
    
    % draw pivot
    circle(model.state(1), model.state(2), model.radius);
    hold on;
    
    % calculate navigation frame corner position
    arrow = [[-model.radius;0],[model.radius;0],[model.radius/2;model.radius/2],[model.radius;0],[model.radius/2;-model.radius/2]];
    arrowNav = rotM * arrow;
    arrowNav = arrowNav + repmat(model.state(1:2)', [1, 5]);
    for i = 1:4
        plot(arrowNav(1,i:i+1), arrowNav(2,i:i+1),'k-');
    end
    
    % draw tires
    cornerWheelNav = [   [-model.wheelRadius ; -model.wheelThickness/2-model.track/2 ; model.wheelRadius ; -model.wheelThickness/2-model.track/2] , ...
                            [model.wheelRadius ; model.wheelThickness/2-model.track/2 ; model.wheelRadius ; -model.wheelThickness/2-model.track/2] , ...
                            [-model.wheelRadius ; model.wheelThickness/2-model.track/2 ; model.wheelRadius ; model.wheelThickness/2-model.track/2] , ...
                            [-model.wheelRadius ; model.wheelThickness/2-model.track/2 ; -model.wheelRadius ; -model.wheelThickness/2-model.track/2] , ...
                            [-model.wheelRadius ; -model.wheelThickness/2+model.track/2 ; model.wheelRadius ; -model.wheelThickness/2+model.track/2] , ...
                            [model.wheelRadius ; model.wheelThickness/2+model.track/2 ; model.wheelRadius ; -model.wheelThickness/2+model.track/2] , ...
                            [-model.wheelRadius ; model.wheelThickness/2+model.track/2 ; model.wheelRadius ; model.wheelThickness/2+model.track/2] , ...
                            [-model.wheelRadius ; model.wheelThickness/2+model.track/2 ; -model.wheelRadius ; -model.wheelThickness/2+model.track/2]...
                            ];
    cornerWheelNav(1:2,:) = (rotM * cornerWheelNav(1:2,:) + repmat(model.state(1:2)', [1, 8]));
    cornerWheelNav(3:4,:) = (rotM * cornerWheelNav(3:4,:) + repmat(model.state(1:2)', [1, 8]));
    for i = 1:8
        plot([cornerWheelNav(1,i),cornerWheelNav(3,i)], [cornerWheelNav(2,i),cornerWheelNav(4,i)],'g-');
    end
end

function drawRobotGoal(model)

    % rotation matrix
    rotM = [cos(model.state(3)), -sin(model.state(3)); sin(model.state(3)), cos(model.state(3))];
    
    % draw pivot
    circleDashed(model.state(1), model.state(2), model.radius);
    hold on;
    
    % calculate navigation frame corner position
    arrow = [[-model.radius;0],[model.radius;0],[model.radius/2;model.radius/2],[model.radius;0],[model.radius/2;-model.radius/2]];
    arrowNav = rotM * arrow;
    arrowNav = arrowNav + repmat(model.state(1:2)', [1, 5]);
    for i = 1:4
        plot(arrowNav(1,i:i+1), arrowNav(2,i:i+1),'k:');
    end
    
    % draw tires
    cornerWheelNav = [   [-model.wheelRadius ; -model.wheelThickness/2-model.track/2 ; model.wheelRadius ; -model.wheelThickness/2-model.track/2] , ...
                            [model.wheelRadius ; model.wheelThickness/2-model.track/2 ; model.wheelRadius ; -model.wheelThickness/2-model.track/2] , ...
                            [-model.wheelRadius ; model.wheelThickness/2-model.track/2 ; model.wheelRadius ; model.wheelThickness/2-model.track/2] , ...
                            [-model.wheelRadius ; model.wheelThickness/2-model.track/2 ; -model.wheelRadius ; -model.wheelThickness/2-model.track/2] , ...
                            [-model.wheelRadius ; -model.wheelThickness/2+model.track/2 ; model.wheelRadius ; -model.wheelThickness/2+model.track/2] , ...
                            [model.wheelRadius ; model.wheelThickness/2+model.track/2 ; model.wheelRadius ; -model.wheelThickness/2+model.track/2] , ...
                            [-model.wheelRadius ; model.wheelThickness/2+model.track/2 ; model.wheelRadius ; model.wheelThickness/2+model.track/2] , ...
                            [-model.wheelRadius ; model.wheelThickness/2+model.track/2 ; -model.wheelRadius ; -model.wheelThickness/2+model.track/2]...
                            ];
    cornerWheelNav(1:2,:) = (rotM * cornerWheelNav(1:2,:) + repmat(model.state(1:2)', [1, 8]));
    cornerWheelNav(3:4,:) = (rotM * cornerWheelNav(3:4,:) + repmat(model.state(1:2)', [1, 8]));
    for i = 1:8
        plot([cornerWheelNav(1,i),cornerWheelNav(3,i)], [cornerWheelNav(2,i),cornerWheelNav(4,i)],'g:');
    end
end

function circle(x,y,r)
%x and y are the coordinates of the center of the circle
%r is the radius of the circle
%0.01 is the angle step, bigger values will draw the circle faster but
%you might notice imperfections (not very smooth)
ang=0:0.01:2*pi; 
xp=r*cos(ang);
yp=r*sin(ang);
plot(x+xp,y+yp);
end

function circleDashed(x,y,r)
%x and y are the coordinates of the center of the circle
%r is the radius of the circle
%0.01 is the angle step, bigger values will draw the circle faster but
%you might notice imperfections (not very smooth)
ang=0:0.01:2*pi; 
xp=r*cos(ang);
yp=r*sin(ang);
plot(x+xp,y+yp,':');
end

function drawEnvironment(env)
    envSize = size(env.corner);
    for i = 1:envSize(2)
        plot([env.corner(1,i),env.corner(3,i)], [env.corner(2,i),env.corner(4,i)],'k-');
    end
    
    return;
end

function drawObstacle(userStructure)
    obst = userStructure.obstacleMap;
    obstSize = size(obst);
    for i = 1:obstSize(2)
        plot([obst(1,i),obst(3,i)], [obst(2,i),obst(4,i)],'b-');
    end
    
    return;
end

function drawNodes(userStructure)
    node = userStructure.nodeMap;
    nodeSize = size(node);
    for i = 1:nodeSize(2)
        if(node(3,i))
             plot(node(1,i),node(2,i),'g*');
        elseif(node(4,i))
            plot(node(1,i),node(2,i),'y*');
        elseif(node(5,i))
            plot(node(1,i),node(2,i),'k*');
        else
            plot(node(1,i),node(2,i),'r*');
        end
    end
    
    return;
end

function drawOptimalPath(userStructure)
    pathMap = userStructure.idealPathMap;
    node = userStructure.nodeMap;
    pathSize = size(pathMap);
    for i = 2:pathSize(2)
        if(pathMap(1,i) > 0 ) 
            plot([node(1,pathMap(1,i-1)),node(1,pathMap(1,i))], [node(2,pathMap(1,i-1)),node(2,pathMap(1,i))],'c--');
        end
    end
    
    return;
end


function drawGlobalPath(userStructure)
    pathMap = userStructure.globalPathMap;
    node = userStructure.nodeMap;
    pathSize = size(pathMap);
    for i = 1:pathSize(2)
        for j = 1 : 4
            if(pathMap(j,i) > 0 )
                if( mod(pathMap(6,i),7) == 1 )
                    plot([node(1,i),node(1,pathMap(j,i))], [node(2,i),node(2,pathMap(j,i))],'m--');
                elseif( mod(pathMap(6,i),7) == 2 )
                    plot([node(1,i),node(1,pathMap(j,i))], [node(2,i),node(2,pathMap(j,i))],'g--');
                elseif( mod(pathMap(6,i),7) == 3 )
                    plot([node(1,i),node(1,pathMap(j,i))], [node(2,i),node(2,pathMap(j,i))],'b--');
                elseif( mod(pathMap(6,i),7) == 4 )
                    plot([node(1,i),node(1,pathMap(j,i))], [node(2,i),node(2,pathMap(j,i))],'y--');
                elseif( mod(pathMap(6,i),7) == 5 )
                    plot([node(1,i),node(1,pathMap(j,i))], [node(2,i),node(2,pathMap(j,i))],'r--');
                elseif( mod(pathMap(6,i),7) == 6 )
                    plot([node(1,i),node(1,pathMap(j,i))], [node(2,i),node(2,pathMap(j,i))],'c--');
                elseif( mod(pathMap(6,i),7) == 7 )
                    plot([node(1,i),node(1,pathMap(j,i))], [node(2,i),node(2,pathMap(j,i))],'k--');          
                else
                    plot([node(1,i),node(1,pathMap(j,i))], [node(2,i),node(2,pathMap(j,i))],'c--');
                end
            end
        end
    end
    
    return;
end

