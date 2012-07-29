function points = star_points(centerColVector, armLength)
    innerPoints   = zeros(2, 5);       % Preallocate space for inner points.
    outerPoints   = zeros(2, 5);       % Preallocate space for outer points.
    rotationAngle = 0;                 % Rotation angle in degrees.
    rotationInner = 108;               % First rotation angle (deg) for inner points.
    rotationOuter = 72;                % Rotation angle (deg) between points.
    starPoints    = zeros(2, 11);      % Preallocate space for all star points.
    topPoint      = [0; ...
                     armLength];       % Topmost point of outer star points.
    topPointInner = [0; ...
                     armLength / 2.5]; % Topmost point of inner star points.
    
    % Create 5 outer star points.       
    for i = 1:5
        % Calculate new rotation matrix.
        rotationAngle = rotationAngle + rotationOuter;
        theta = rotationAngle * (pi / 180);
        rotationMatrix = [cos(theta), -sin(theta); ...
                          sin(theta), cos(theta)];
        
        % Rotate point.
        point = rotationMatrix * topPoint;
        
        % Translate point.
        point = point + centerColVector;
        
        % Store that new point with the other rotated outer points.
        outerPoints(1:end, i) = point;
    end
    
    % Create 5 inner star points.
    for i = 1:5
        % Calculate new rotation matrix.
        if i == 1
            rotationAngle = rotationAngle + rotationInner;
        else
            rotationAngle = rotationAngle + rotationOuter;
        end
        theta = rotationAngle * (pi / 180);
        rotationMatrix = [cos(theta), -sin(theta); ...
                          sin(theta), cos(theta)];
        
        % Rotate point.
        point = rotationMatrix * topPointInner;
        
        % Translate point.
        point = point + centerColVector;
        
        % Store that new point with the other rotated inner points.
        innerPoints(1:end, i) = point;
    end
    
    % Order points in a row vector.
    for i = 1:11
        if i ~= 11
            if mod(i, 2) == 0
                starPoints(1:end, i) = innerPoints(1:end, 1);
                innerPoints(:, 1) = [];
            else
                starPoints(1:end, i) = outerPoints(1:end, 1);
                outerPoints(:, 1) = [];
            end
        else
            starPoints(1:end, i) = starPoints(1:end, 1);
        end
    end
    
    points = starPoints;
    
    % Output for testing.
    disp(starPoints);
    axis([-50, 50, -50, 50]);
    hold on;
    plot(centerColVector(1, 1), centerColVector(2, 1), '+');
    for i = 1:11
        if i ~= 11
            plot(starPoints(1, i), starPoints(2, i), 'b.');
        else
            plot(starPoints(1, i), starPoints(2, i), 'g.');
        end
    end
end