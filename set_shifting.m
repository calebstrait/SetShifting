% Copyright (c) 2012 Aaron Roth
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in
% all copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
% THE SOFTWARE.
%

function set_shifting()
    % ---------------------------------------------- %
    % -------------- Global variables -------------- %
    % ---------------------------------------------- %
    
    % Colors.
    colorBackground = [0 0 0];
    colorFixDot     = [255 255 0];
    colorBlue       = [5 61 245];  
    colorCyan       = [0 253 254];
    colorGreen      = [0 248 79];
    colorRed        = [255 30 24];
    colorWhite      = [255 255 255];
    
    % Coordinates.
    centerX         = 512;                % X pixel coordinate for the screen center.
    centerY         = 434;                % Y pixel coordinate for the screen center.
    hfWidth         = 88;                 % Half the width of the fixation boxes.
    
    % Values to calculate fixation box.
    fixBoundXMax    = centerX + hfWidth;  % Max x distance from fixation point to fixate.
    fixBoundXMin    = centerX - hfWidth;  % Min x distance from fixation point to fixate.
    fixBoundYMax    = centerY + hfWidth;  % Max y distance from fixation point to fixate.
    fixBoundYMin    = centerY - hfWidth;  % Mix y distance from fixation point to fixate.
    
    % Values to calculate fixation boxes on all sides.
    topBoundXMax    = centerX + hfWidth;
    topBoundXMin    = centerX - hfWidth;
    topBoundYMax    = centerY - 108;
    topBoundYMin    = centerY - 284;
    leftBoundXMax   = centerX - 108;
    leftBoundXMin   = centerX - 284;
    leftBoundYMax   = centerY + 176;
    leftBoundYMin   = centerY;
    rightBoundXMax  = centerX + 284;
    rightBoundXMin  = centerX + 108;
    rightBoundYMax  = centerY + 176;
    rightBoundYMin  = centerY;
    
    centerShift         = 196;     % Dist. from fix. dot to center of other fix. squares.
    circleAdj           = 22;
    circleBorderHeight  = 11;
    circleBorderWidth   = 11;
    fixAdj              = 1;
    starBorderWidth     = 30;
    starHfWidth         = hfWidth + 10;
    starShift           = centerShift - 6;
    triAdj              = 30;
    
    % Values to draw star.
    starBottomInX   = 35;
    starBottomInY   = 18;
    starBottomMid   = 45;
    starSpacerFloor = 58;   
    starSpacerCeil  = 25;
    starTopInner    = 20;
    
    % References.
    monkeyScreen    = 1;       % Number of the screen the monkey sees.
    
    % Stimuli.
    dotRadius       = 10;      % Radius of the fixation dot.
    starOutline     = 10;      % Width of star outline.
    
    % Times.
    feedbackTime    = 0.4;     % Duration of the error state.
    holdFixTime     = 0.25;    % Duration to hold fixation before choosing.
    ITI             = 0.8;     % Intertrial interval.
    minFixTime      = 0.1;     % Min time monkey must fixate to start trial.
    timeToFix       = intmax;  % Amount of time monkey is given to fixate.
    timeToSaccade   = intmax;  % Time allowed for monkey to make a choice.
    
    % Trial.
    trialCount      = 0;
    
    % ---------------------------------------------- %
    % ------------------- Setup -------------------- %
    % ---------------------------------------------- %
    
    % Window.
    window = setup_window;
    
    % ---------------------------------------------- %
    % ------------ Main experiment loop ------------ %
    % ---------------------------------------------- %
    
    running = true;
    while running
        keyPress = key_check;
        key_execute(keyPress);
        
        run_single_trial;
        trialCount = trialCount + 1;
        % print_stats;
    end
    
    Screen('Close', window);
    
    % ---------------------------------------------- %
    % ----------------- Functions ------------------ %
    % ---------------------------------------------- %
    
    % Determines if the eye has fixated within the given bounds
    % for the given duration before the given timeout occurs.
    function [fixation, area] = check_fixation(type, duration, timeout)
        startTime = GetSecs;
        
        % Keep checking for fixation until timeout occurs.
        while timeout > (GetSecs - startTime)
            [xCoord, yCoord] = get_eye_coords;
            
            % Determine if one, two, or three locations are being tracked.
            if strcmp(type, 'single')
                % Determine if eye is within the fixation boundary.
                if xCoord >= fixBoundXMin && xCoord <= fixBoundXMax && ...
                   yCoord >= fixBoundYMin && yCoord <= fixBoundYMax
                    % Determine if eye maintained fixation for given duration.
                    checkFixBreak = fix_break_check(fixBoundXMin, fixBoundXMax, ...
                                                    fixBoundYMin, fixBoundYMax, ...
                                                    duration);
                    
                    if checkFixBreak == false
                        % Fixation was obtained for desired duration.
                        fixation = true;
                        area = 'single';
                        
                        return;
                    end
                end
            elseif strcmp(type, 'double')
                % Determine if eye is within the left option boundary.
                if xCoord >= leftBoundXMin && xCoord <= leftBoundXMax && ...
                   yCoord >= leftBoundYMin && yCoord <= leftBoundYMax
                    % Determine if eye maintained fixation for given duration.
                    checkFixBreak = fix_break_check(leftBoundXMin, leftBoundXMax, ...
                                                    leftBoundYMin, leftBoundYMax, ...
                                                    duration);
                    
                    if checkFixBreak == false
                        % Fixation was obtained for desired duration.
                        fixation = true;
                        area = 'double';
                        
                        return;
                    end
                % Determine if eye is within the right option boundary.
                elseif xCoord >= rightBoundXMin && xCoord <= rightBoundXMax && ...
                       yCoord >= rightBoundYMin && yCoord <= rightBoundYMax
                    % Determine if eye maintained fixation for given duration.
                    checkFixBreak = fix_break_check(rightBoundXMin, rightBoundXMax, ...
                                                    rightBoundYMin, rightBoundYMax, ...
                                                    duration);
                    
                    if checkFixBreak == false
                        % Fixation was obtained for desired duration.
                        fixation = true;
                        area = 'double';
                        
                        return;
                    end
                end
            elseif strcmp(type, 'triple')
                % Determine if eye is within the left option boundary.
                if xCoord >= leftBoundXMin && xCoord <= leftBoundXMax && ...
                   yCoord >= leftBoundYMin && yCoord <= leftBoundYMax
                    % Determine if eye maintained fixation for given duration.
                    checkFixBreak = fix_break_check(leftBoundXMin, leftBoundXMax, ...
                                                    leftBoundYMin, leftBoundYMax, ...
                                                    duration);
                    
                    if checkFixBreak == false
                        % Fixation was obtained for desired duration.
                        fixation = true;
                        area = 'double';
                        
                        return;
                    end
                % Determine if eye is within the right option boundary.
                elseif xCoord >= rightBoundXMin && xCoord <= rightBoundXMax && ...
                       yCoord >= rightBoundYMin && yCoord <= rightBoundYMax
                    % Determine if eye maintained fixation for given duration.
                    checkFixBreak = fix_break_check(rightBoundXMin, rightBoundXMax, ...
                                                    rightBoundYMin, rightBoundYMax, ...
                                                    duration);
                    
                    if checkFixBreak == false
                        % Fixation was obtained for desired duration.
                        fixation = true;
                        area = 'double';
                        
                        return;
                    end
                % Determine if eye is within the top option boundary.
                elseif xCoord >= topBoundXMin && xCoord <= topBoundXMax && ...
                       yCoord >= topBoundYMin && yCoord <= topBoundYMax
                    % Determine if eye maintained fixation for given duration.
                    checkFixBreak = fix_break_check(topBoundXMin, topBoundXMax, ...
                                                    topBoundYMin, topBoundYMax, ...
                                                    duration);
                    
                    if checkFixBreak == false
                        % Fixation was obtained for desired duration.
                        fixation = true;
                        area = 'double';
                        
                        return;
                    end
                end
            end
        end
        
        % Timeout reached.
        fixation = false;
        area = 'none';
    end
    
    function draw_circle(position, type, colorFill, colorOut)
        % Calculate circle center.
        if strcmp(position, 'left')
            circleCenterX = centerX - centerShift;
            circleCenterY = centerY + hfWidth;
        elseif strcmp(position, 'right')
            circleCenterX = centerX + centerShift;
            circleCenterY = centerY + hfWidth;
        elseif strcmp(position, 'top')
            circleCenterX = centerX;
            circleCenterY = centerY - centerShift;
        end
        
        if strcmp(type, 'solid')
            % Draw a filled circle.
            Screen('FillOval', window, colorFill, [circleCenterX - hfWidth + circleAdj; ...
                                                   circleCenterY - hfWidth; ...
                                                   circleCenterX + hfWidth - circleAdj; ...
                                                   circleCenterY + hfWidth]);
        elseif strcmp(type, 'outline')
            % Draw a filled circle.
            Screen('FillOval', window, colorFill, [circleCenterX - hfWidth + circleAdj; ...
                                                  circleCenterY - hfWidth; ...
                                                  circleCenterX + hfWidth - circleAdj; ...
                                                  circleCenterY + hfWidth]);
            % Draw a circle outline.
            Screen('FrameOval', window, colorOut, [circleCenterX - hfWidth + circleAdj; ...
                                                   circleCenterY - hfWidth; ...
                                                   circleCenterX + hfWidth - circleAdj; ...
                                                   circleCenterY + hfWidth], ...
                                                   circleBorderWidth, circleBorderHeight);
        else
            disp('Called draw_circle with an illegal value for the "type" parameter');
        end
    end

    function draw_fixation_bounds()
        Screen('FrameRect', window, colorFixDot, [fixBoundXMin fixBoundYMin ...
                                                  fixBoundXMax fixBoundYMax], 1);
        Screen('FrameRect', window, colorFixDot, [topBoundXMin topBoundYMin ...
                                                  topBoundXMax topBoundYMax], 1);
        Screen('FrameRect', window, colorFixDot, [leftBoundXMin leftBoundYMin ...
                                                  leftBoundXMax leftBoundYMax], 1);
        Screen('FrameRect', window, colorFixDot, [rightBoundXMin rightBoundYMin ...
                                                  rightBoundXMax rightBoundYMax], 1);
        Screen('Flip', window);
    end
    
    % Draws the fixation point on the screen.
    function draw_fixation_point(color)
        Screen('FillOval', window, color, [centerX - dotRadius + fixAdj; ...
                                           centerY - dotRadius; ...
                                           centerX + dotRadius - fixAdj; ...
                                           centerY + dotRadius]);
        Screen('Flip', window);
    end
    
    function draw_star(position, type, colorFill, colorOut)
        % Calculate star center.
        if strcmp(position, 'left')
            starCenterX = centerX - centerShift;
            starCenterY = centerY + starHfWidth;
        elseif strcmp(position, 'right')
            starCenterX = centerX + centerShift;
            starCenterY = centerY + starHfWidth;
        elseif strcmp(position, 'top')
            starCenterX = centerX;
            starCenterY = centerY - starShift;
        end
        
        % Calculate all star points.
        starPoints = star_points([starCenterX; starCenterY], starHfWidth);
        
        if strcmp(type, 'solid')
            % Draw a filled star.
            Screen('FillPoly', window, colorFill, starPoints, 0);
        elseif strcmp(type, 'outline')
            % Calculate all star points for inner star.
            starPoints2nd = star_points([starCenterX; starCenterY], ...
                                         starHfWidth - starBorderWidth);
            
            Screen('FillPoly', window, colorOut, starPoints, 0);
            Screen('FillPoly', window, colorFill, starPoints2nd, 0);
        else
            disp('Called draw_star with an illegal value for the "type" parameter');
        end
    end
    
    function draw_triangle(position, type, colorFill, colorOut)
        % Calculate triangle center.
        if strcmp(position, 'left')
            triCenterX = centerX - centerShift;
            triCenterY = centerY + hfWidth;
        elseif strcmp(position, 'right')
            triCenterX = centerX + centerShift;
            triCenterY = centerY + hfWidth;
        elseif strcmp(position, 'top')
            triCenterX = centerX;
            triCenterY = centerY - centerShift;
        end
        
        % Calculate outer triangle points.
        point1 = [triCenterX + hfWidth - triAdj, triCenterY + hfWidth];
        point2 = [triCenterX, triCenterY - hfWidth];
        point3 = [triCenterX - hfWidth + triAdj, triCenterY + hfWidth];
        point4 = point1;
            
        if strcmp(type, 'solid')
            % Draw a filled triangle.
            Screen('FillPoly', window, colorFill, [point1; point2; ...
                                                   point3; point4], 0);
        elseif strcmp(type, 'outline')
            % Calculate inner triangle points.
            point5 = [triCenterX + hfWidth - 11 - triAdj, triCenterY + hfWidth - 10];
            point6 = [triCenterX, triCenterY - hfWidth + 26];
            point7 = [triCenterX - hfWidth + 11 + triAdj, triCenterY + hfWidth - 10];
            point8 = point5;
            % Draw a filled triangle.
            Screen('FillPoly', window, colorOut, [point1; point2; ...
                                                  point3; point4], 0);
            % Draw a triangle outline.
            Screen('FillPoly', window, colorFill, [point5; point6; ...
                                                  point7; point8], 0);
             
        else
            disp('Called draw_triangle with an illegal value for the "type" parameter');
        end
    end
    
    % Checks if the eye breaks fixation bounds before end of duration.
    function fixationBreak = fix_break_check(xBoundMin, xBoundMax, ...
                                             yBoundMin, yBoundMax, ...
                                             duration)
        fixStartTime = GetSecs;
        
        % Keep checking for fixation breaks for the entire duration.
        while duration > (GetSecs - fixStartTime)
            [xCoord, yCoord] = get_eye_coords;
            
            % Determine if the eye has left the fixation boundaries.
            if xCoord < xBoundMin || xCoord > xBoundMax || ...
               yCoord < yBoundMin || yCoord > yBoundMax
                % Eye broke fixation before end of duration.
                fixationBreak = true;
                
                return;
            end
        end
        
        % Eye maintained fixation for entire duration.
        fixationBreak = false;
    end
    
    % Returns the current x and y coordinants of the given eye.
    function [xCoord, yCoord] = get_eye_coords()
        sampledPosition = Eyelink('NewestFloatSample');
        
        xCoord = centerX; %sampledPosition.gx(trackedEye);
        yCoord = centerY; %sampledPosition.gy(trackedEye);
    end
    
    % Checks to see what key was pressed.
    function key = key_check()
        % Assign key codes to some variables.
        stopKey = KbName('ESCAPE');
        
        % Make sure default values of key are false.
        key.escape = false;
        
        % Get info about any key that was just pressed.
        [~, ~, keyCode] = KbCheck;
        
        % Check pressed key against the keyCode array of 256 key codes.
        if keyCode(stopKey)
            key.escape = true;
        end
    end
    
    % Execute a passsed key command.
    function key_execute(keyRef)
        % Stop task at end of current trial.
        if keyRef.escape == true
            running = false;
        end
    end
    
    % Makes a folder and file where data will be saved.
    function prepare_for_saving()
        cd(validData);
        
        % Check if cell ID was passed in with monkey's initial.
        if numel(monkeysInitial) == 1
            initial = monkeysInitial;
            cell = '';
        else
            initial = monkeysInitial(1);
            cell = monkeysInitial(2);
        end
        
        dateStr = datestr(now, 'yymmdd');
        filename = [initial dateStr '.' cell '1.C.mat'];
        folderNameDay = [initial dateStr];
        folderNameBlock = ['Block' num2str(currBlock)];
        
        % Make and/or enter a folder where trial block folders are located.
        if exist(folderNameDay, 'dir') == 7
            cd(folderNameDay);
        else
            mkdir(folderNameDay);
            cd(folderNameDay);
        end
        
        % Make and/or enter a folder where .mat files will be saved.
        if exist(folderNameBlock, 'dir') == 7
            cd(folderNameBlock);
        else
            mkdir(folderNameBlock);
            cd(folderNameBlock);
        end
        
        % Make sure the filename for the .mat file is not already used.
        fileNum = 1;
        while fileNum ~= 0
            if exist(filename, 'file') == 2
                fileNum = fileNum + 1;
                filename = [initial dateStr '.' cell num2str(fileNum) '.C.mat'];
            else
                fileNum = 0;
            end
        end
        
        saveCommand = ['save ' filename ' ' varName];
    end
    
    % Prints current trial stats.
    function print_stats()
        home;
        disp('             ');
        disp('****************************************');
        disp('             ');
        fprintf('Trials completed:% 4u', trialCount);
        disp('             ');
        disp('             ');
        disp('****************************************');
    end
    
    % Rewards monkey using the juicer with the passed duration.
    function reward(rewardAmount)
        if rewardAmount ~= 0
            % Get a reference the juicer device and set reward duration.
            daq = DaqDeviceIndex;
            rewardDuration = rewardAmount * pourTimeOneMl;
            
            % Open juicer.
            DaqAOut(daq, 0, .6);
            
            startTime = GetSecs;
            
            % Keep looping to keep juicer open until reward end.
            while (GetSecs - startTime) < rewardDuration
            end
            
            % Close juicer.
            DaqAOut(daq, 0, 0);
        end
    end

    function run_single_trial()
        % Fixation dot appears.
        draw_fixation_point(colorFixDot);
        draw_star('left', 'outline', colorBlue, colorCyan);
        draw_triangle('top', 'outline', colorBlue, colorCyan);
        draw_circle('right', 'outline', colorBlue, colorCyan);
    end
    
    % Sets up a new window and sets preferences for it.
    function window = setup_window()
        % Print only PTB errors.
        Screen('Preference', 'VisualDebugLevel', 1);
        
        % Suppress the print out of all PTB warnings.
        Screen('Preference', 'Verbosity', 0);
        
        % Setup a screen for displaying stimuli for this session.
        window = Screen('OpenWindow', monkeyScreen, colorBackground);
    end

    function points = star_points(centerColVector, armLength)
        innerPoints   = zeros(2, 5);       % Preallocate space for inner points.
        outerPoints   = zeros(2, 5);       % Preallocate space for outer points.
        rotationAngle = 0;                 % Rotation angle in degrees.
        rotationInner = 108;               % First rotation angle (deg) for inner points.
        rotationOuter = 72;                % Rotation angle (deg) between points.
        starPoints    = zeros(11, 2);      % Preallocate space for all star points.
        topPoint      = [0; ...
                         -armLength];       % Topmost point of outer star points.
        topPointInner = [0; ...
                         -armLength / 2.6]; % Topmost point of inner star points.

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
                    starPoints(i, 1:end) = innerPoints(1:end, 1)';
                    innerPoints(:, 1) = [];
                else
                    starPoints(i, 1:end) = outerPoints(1:end, 1)';
                    outerPoints(:, 1) = [];
                end
            else
                starPoints(i, 1:end) = starPoints(1, 1:end);
            end
        end

        points = starPoints;
        
        % Output for testing.
        %{
        disp(starPoints);
        axis([-50, 50, -50, 50]);
        hold on;
        plot(centerColVector(1, 1), centerColVector(2, 1), '+');
        for i = 1:11
            if i ~= 11
                plot(starPoints(i, 1), starPoints(i, 2), 'b.');
            else
                plot(starPoints(i, 1), starPoints(i, 2), 'g.');
            end
            pause(2);
        end
        %}
    end
end