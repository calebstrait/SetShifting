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
    
    centerShift     = 196;     % Dist. from fix. dot to center of other fix. squares.
    
    % Values to draw star.
    starBottomInX   = 35;
    starBottomInY   = 18;
    starBottomMid   = 45;
    starSpacerFloor = 58;   
    starSpacerCeil  = 25;
    starTopInner    = 20;
    
    % References.
    monkeyScreen    = 0;       % Number of the screen the monkey sees.
    
    % Stimuli.
    dotRadius       = 10;      % Radius of the fixation dot.
    
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
        print_stats;
    end
    
    Screen('Close', window);
    
    % ---------------------------------------------- %
    % ----------------- Functions ------------------ %
    % ---------------------------------------------- %
    
    % Determines if the eye has fixated within the given bounds
    % for the given duration before the given timeout occurs.
    function [fixation, area] = check_fixation(xBoundMin, xBoundMax, ...
                                               yBoundMin, yBoundMax, ...
                                               xBoundMin2nd, xBoundMax2nd, ...
                                               yBoundMin2nd, yBoundMax2nd, ...
                                               duration, timeout, checkTwo)
        startTime = GetSecs;
        
        % Keep checking for fixation until timeout occurs.
        while timeout > (GetSecs - startTime)
            [xCoord, yCoord] = get_eye_coords;
            
            % Determine if one or two locations are being tracked.
            if checkTwo
                % Determine if eye is within either of the two fixation boundaries.
                if (xCoord >= xBoundMin && xCoord <= xBoundMax && ...
                    yCoord >= yBoundMin && yCoord <= yBoundMax) || ...
                   (xCoord >= xBoundMin2nd && xCoord <= xBoundMax2nd && ...
                    yCoord >= yBoundMin2nd && yCoord <= yBoundMax2nd)
                    % Determine if the eye entered the leave option boundaries.
                    if xCoord >= xBoundMin && xCoord <= xBoundMax && ...
                       yCoord >= yBoundMin && yCoord <= yBoundMax
                        % Notify Plexon: Eye looked at leave option.
                        toplexon(4081);
                        
                        % Determine if eye maintained fixation for given duration.
                        checkFixBreak = fix_break_check(xBoundMin, xBoundMax, ...
                                                        yBoundMin, yBoundMax, ...
                                                        duration);
                        
                        if checkFixBreak == false
                            % Notify Plexon: Eye acquired fixtion on leave option.
                            toplexon(4083);
                            
                            % Fixation was obtained for desired duration.
                            fixation = true;
                            area = 'first';
                            
                            return;
                        else
                            % Notify Plexon: Eye looked away from leave option.
                            toplexon(4082);
                        end
                    % Determine if the eye entered the stay option boundaries.
                    else
                        % Notify Plexon: Eye looked at stay option.
                        toplexon(4071);
                        
                        % Determine if eye maintained fixation for given duration.
                        checkFixBreak = fix_break_check(xBoundMin2nd, xBoundMax2nd, ...
                                                        yBoundMin2nd, yBoundMax2nd, ...
                                                        duration);
                        
                        if checkFixBreak == false
                            % Notify Plexon: Eye acquired fixtion on stay option.
                            toplexon(4073);
                            
                            % Fixation was obtained for desired duration.
                            fixation = true;
                            area = 'second';
                            
                            return;
                        else
                            % Notify Plexon: Eye looked away from stay option.
                            toplexon(4072);
                        end
                    end
                end
            else
                % Determine if eye is within the fixation boundary.
                if xCoord >= xBoundMin && xCoord <= xBoundMax && ...
                   yCoord >= yBoundMin && yCoord <= yBoundMax
                    % Notify Plexon: Eye looked at fixation dot.
                    toplexon(4051);
                    
                    % Determine if eye maintained fixation for given duration.
                    checkFixBreak = fix_break_check(xBoundMin, xBoundMax, ...
                                                    yBoundMin, yBoundMax, ...
                                                    duration);
                    
                    if checkFixBreak == false
                        % Notify Plexon: Eye acquired fixation on fixation dot.
                        toplexon(4053);
                        
                        % Fixation was obtained for desired duration.
                        fixation = true;
                        area = 'single';
                        
                        return;
                    else
                        % Notify Plexon: Eye looked away from fixation dot.
                        toplexon(4052);
                    end
                end
            end
        end
        
        % Timeout reached.
        fixation = false;
        area = 'none';
    end
    
    function draw_circle(position, color)
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
        
        Screen('FillOval', window, color, [circleCenterX - hfWidth; ...
                                           circleCenterY - hfWidth; ...
                                           circleCenterX + hfWidth; ...
                                           circleCenterY + hfWidth]);
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
    end
    
    % Draws the fixation point on the screen.
    function draw_fixation_point(color)
        Screen('FillOval', window, color, [centerX - dotRadius; ...
                                           centerY - dotRadius; ...
                                           centerX + dotRadius; ...
                                           centerY + dotRadius]);
        Screen('Flip', window);
    end

    function draw_star(position, color)
        % Calculate star center.
        if strcmp(position, 'left')
            starCenterX = centerX - centerShift;
            starCenterY = centerY + hfWidth;
        elseif strcmp(position, 'right')
            starCenterX = centerX + centerShift;
            starCenterY = centerY + hfWidth;
        elseif strcmp(position, 'top')
            starCenterX = centerX;
            starCenterY = centerY - centerShift;
        end
        
        % Calculate all star points.
        point1  = [starCenterX + hfWidth, starCenterY - starSpacerCeil];
        point2  = [starCenterX + starTopInner, starCenterY - starSpacerCeil];
        point3  = [starCenterX, starCenterY - hfWidth];
        point4  = [starCenterX - starTopInner, starCenterY - starSpacerCeil];
        point5  = [starCenterX - hfWidth, starCenterY - starSpacerCeil];
        point6  = [starCenterX - starBottomInX, starCenterY + starBottomInY];
        point7  = [starCenterX - starSpacerFloor, starCenterY + hfWidth];
        point8  = [starCenterX, starCenterY + starBottomMid];
        point9  = [starCenterX + starSpacerFloor, starCenterY + hfWidth];
        point10 = [starCenterX + starBottomInX, starCenterY + starBottomInY];
        point11 = point1;
        
        % Draw the star.
        Screen('FillPoly', window, color, [point1; point2; point3;
                                           point4; point5; point6;
                                           point7; point8; point9;
                                           point10; point11], 0);
    end
    
    function draw_triangle(position, color)
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
        
        % Calculate all triangle points.
        point1 = [triCenterX + hfWidth, triCenterY + hfWidth];
        point2 = [triCenterX, triCenterY - hfWidth];
        point3 = [triCenterX - hfWidth, triCenterY + hfWidth];
        point4 = point1;
        
        % Draw the triangle.
        Screen('FillPoly', window, color, [point1; point2; ...
                                           point3; point4], 1);
    end
    
    % Checks if the eye breaks fixation bounds before end of duration.
    function fixationBreak = fix_break_check(xBoundMin, xBoundMax, ...
                                             yBoundMin, yBoundMax, ...
                                             duration)
        fixStartTime = GetSecs;
        
        % Keep checking for fixation breaks for the entire duration.
        while duration > (GetSecs - fixStartTime)
            % Check for pressed keys.
            keyPress = key_check;
            key_execute(keyPress);
            
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
        
        xCoord = sampledPosition.gx(trackedEye);
        yCoord = sampledPosition.gy(trackedEye);
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
        
        draw_circle('left', colorBlue);
        draw_triangle('right', colorGreen);
        draw_star('top', colorRed);                                  
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
end