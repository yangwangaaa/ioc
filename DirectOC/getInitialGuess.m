function [angles, velocities, control, time] = getInitialGuess(model,config,flag)
    
    % This function generates a quantic spline as the initial guess of a
    % trajectory optimization instance
    initialState=config.initialState;
    finalState=config.finalState;
    t=[config.initialState.time; config.finalState.time];
    dt=config.dt;
    
    if flag==1 % flag is for spline guess
        y = [initialState.jointAngles';
            finalState.jointAngles'];
        dy = [initialState.angularVelocities';
            finalState.angularVelocities'];
        ddy = zeros(2,length(initialState.jointAngles));
        [angles, velocities, accelerations, time] = quinticSplineNew(y,dy, ddy,t, dt);
    else % other guess
        y = [initialState.jointAngles';
            finalState.jointAngles'];
        dy = [initialState.angularVelocities';
            finalState.angularVelocities'];
        ddy = 100*ones(2,length(initialState.jointAngles));
        [angles, velocities, accelerations, time] = quinticSplineNew(y,dy, ddy,t, dt);
        
        
    end
    
    
    control = zeros(size(angles));
    
    previousState = model.getState();
    
    for i = 1:size(angles, 1)
        currQ = angles(i, :);
        currDq = velocities(i, :);
        currDdq = accelerations(i, :);
    
        model.updateState(currQ(1:end), currDq(1:end));
        control(i, :) = model.inverseDynamicsQDqDdq(currQ,currDq,currDdq);
    end
  
    model.updateState(previousState(1,:), previousState(2,:));
end

