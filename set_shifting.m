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

function set_shifting(monkeysInitial)
    % ---------------------------------------------- %
    % -------------- Global variables -------------- %
    % ---------------------------------------------- %
    
    % @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ %
    % @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ %
    % @@@@@@@                                @@@@@@@ %
    % @@@@@@@  FREQUENTLY CHANGED VARIABLES  @@@@@@@ %
    % @@@@@@@                                @@@@@@@ %
    % @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ %
    % @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ %
    
      numCorrectToShift   = 20;            % Number correct trials before shift.
      rewardDuration      = 0.12;          % How long the juicer is open.
      stimFlashTime       = 0.4;           % How long a stimulus is flashed during
                                           %         initial stimuli presentation during a
                                           %         staggered stimuli session.
      interStimulusDelay  = 0.6;           % Delay between stimulus presentations
                                           %         during staggered stimuli sessions.
      trackedEye          = 1;             % Values: 1 (left eye), 2 (right eye).
      sessionType         = 'staggered';   % Values: 'staggered' or 'unstaggered'.
      recordWithPlexon    = 1;             % Values: 0 or 1. Sends events and data
                                           %         to Plexon when set to 1.
      experimentType      = 'extraSS';     % Values: 'colorShift', 'shapeShift',
                                           %         'intraSS', or 'extraSS'.
      sessionDimension    = 'random';      % Values: 'color', 'shape', or 'random'.
                                           %         Allows for control of the session
                                           %         dimension (color or shape).
                                           %         NOTE1: This has no effect when
                                           %         'allRandom' is set to 'yes'.
                                           %         NOTE2: This variable only sets the
                                           %         starting dimension in the 'extraSS' task.
      allRandom           = 'yes';         % Values: 'yes' or 'no'. Makes correct 
                                           %         choice, dimension shifted to, 
                                           %         and stimuli positioning random.
                                           %         NOTE: Only works when
                                           %         'experimentType' is set to
                                           %         'intraSS' or 'extraSS'.
      colorShiftNumColors = 3;             % Values: 2 or 3. Number of colors to use.
                                           %         NOTE: Only change this
                                           %         var when 'experimentType is
                                           %         set to 'colorShift'.
      shapeShiftNumShapes = 3;             % Values: 2 or 3. Number of shapes to use.
                                           %         NOTE: Only change this
                                           %         var when 'experimentType is
                                           %         set to 'shapeShift'.
    
    % @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ %
    % @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ %
    % @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ %
    % @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ %
    % @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ %
    % @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ %
    % @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ %
    
    % Colors.
    colorBackground = [0 0 0];
    colorYellow     = [255 255 0]; 
    colorCyan       = [0 255 255];
    colorGreen      = [0 255 0];
    colorMagenta    = [255 0 255];
    colorRed        = [255 0 0];
    colorWhite      = [255 255 255];
    
    % Basic coordinates.
    centerX         = 512;  % X pixel coordinate for the screen center.
    centerY         = 384;  % Y pixel coordinate for the screen center.
    hfWidth         = 88;   % Half the width of the fixation boxes.
    fixAdjCenter    = 62;   % Amount to stretch in fix bound from original.
    fixAdjLRBottom  = 125;  % Amount to stretch down L & R option fix bounnds from original.
    fixAdjLROutside = 175;  % Amount to stretch out L & R option outside sides from original.
    fixAdjLRTop     = 40;   % Amount to stretch up L & R option fix bounds from original.
    fixAdjTTopSide  = 50;   % Amount to stretch up top option fix bounds from original.
    fixAdjTOutside  = 118; %415;  % Amount to stretch out top option outside sides from original.
    
    % Values to calculate fixation boxes.
    fixBoundXMax    = centerX + hfWidth;
    fixBoundXMin    = centerX - hfWidth;
    fixBoundYMax    = centerY + hfWidth;
    fixBoundYMin    = centerY - hfWidth;
    
    leftBoundXMax   = centerX - 152 + fixAdjCenter;
    leftBoundXMin   = centerX - 328 - fixAdjLROutside;
    leftBoundYMax   = centerY + 220 + fixAdjLRBottom;
    leftBoundYMin   = centerY + 44 - fixAdjLRTop;
    
    rightBoundXMax  = centerX + 328 + fixAdjLROutside;
    rightBoundXMin  = centerX + 152 - fixAdjCenter;
    rightBoundYMax  = centerY + 220 + fixAdjLRBottom;
    rightBoundYMin  = centerY + 44 - fixAdjLRTop;
    
    topBoundXMax    = centerX + hfWidth + fixAdjTOutside;
    topBoundXMin    = centerX - hfWidth - fixAdjTOutside;
    topBoundYMax    = centerY - 152 + fixAdjCenter;
    topBoundYMin    = centerY - 328 - fixAdjTTopSide;
    
    % Other Coordinate variables.
    centerShift        = 240;  % Dist. from fix. dot to center of other fix. squares.
    circleAdj          = 22;
    circleBorderHeight = 11;
    circleBorderWidth  = 11;
    dotRadius          = 10;
    fixAdj             = 1;
    starBorderWidth    = 30;
    starHfWidth        = hfWidth + 10;
    starShift          = centerShift - 6;
    triAdj             = 30;
    
    % References.
    monkeyScreen       = 1;        % Number of the screen the monkey sees.
    
    % Saving.
    data               = struct([]);          % Workspace variable where trial data is saved.
    stimOneFlashed     = 'N/A';               % The first staggered stimulus presented.
    stimTwoFlashed     = 'N/A';               % The second staggered stimulus presented.
    stimThreeFlashed   = 'N/A';               % The third staggered stimulus presented.
    saveCommand        = NaN;                 % Command string that will save .mat files.         
    setShiftingData    = '/Data/SetShifting'; % Directory where .mat files are saved.
    varName            = 'data';              % Name of the var to save in the workspace.
    
    % Times.
    feedbackTime       = 0.4;     % Duration of the error state.
    chooseHoldFixTime  = 0.1;     % Duration fixation must be held while targets are on.
    holdFixTime        = 0.75;    % Duration to hold fixation before choosing.
    ITI                = 0.8;     % Intertrial interval.
    minFixTime         = 0.1;     % Min time monkey must fixate to start trial.
    timeToFix          = intmax;  % Amount of time monkey is given to fixate.
    
    % Trial.
    blockPercentCorr   = 0;
    colors             = [{'cyan'}, {'magenta'}, {'yellow'}];
    corrAnsObject      = struct([]);
    currentAnswer      = '';
    currentDim         = '';
    currAnsPosition    = 0;
    currBlockTrial     = 0;
    currIntBlockTrial  = 0;
    currTrial          = 0;
    currTrialAtError   = 1;
    dimension          = [{'color'}, {'shape'}];
    lastCorrPos        = '';
    passedTrial        = true;
    inHoldingState     = true;
    numCorrTrials      = 0;
    positions          = [{'left'}, {'right'}, {'top'}];
    prevStimPresOrder  = [];
    shapes             = [{'circle'}, {'star'}, {'triangle'}];
    totalNumCorrTrials = 0;
    totalPercentCorr   = 0;
    trialCount         = 0;
    trialObject        = struct([]);
    
    % Trial data.
    chosenPosition     = '';
    rewarded           = '';
    shifts             = 0;
    trialOutcome       = '';
    
    % Shared trial info.
    colorOne           = '';
    colorTwo           = '';
    colorThree         = '';
    shapeOne           = '';
    shapeTwo           = '';
    shapeThree         = '';
    lastBlockValue     = '';
    
    % Color shift trial info.
    chosenShape        = '';
    genColorShift      = 0;
    lastBlockColor     = '';
    colorSetUnits      = 0;  % Number of times a set shift unit has occurred.
    
    % Shape shift trial info.
    chosenColor        = '';
    genShapeShift      = 0;
    lastBlockShape     = '';
    shapeSetUnits      = 0;
    
    % IntraSS trial info.
    genDimSetShift    = 0;
    
    % ---------------------------------------------- %
    % ------------------- Setup -------------------- %
    % ---------------------------------------------- %
    
    % Saving.
    prepare_for_saving;
    
    % Window.
    window = setup_window;
    
    % Eyelink.
    setup_eyelink;
    
    % ---------------------------------------------- %
    % ------------ Main experiment loop ------------ %
    % ---------------------------------------------- %
    
    running = true;
    while running
        % Listen for key presses.
        keyPress = key_check;
        key_execute(keyPress);
        
        run_single_trial;
        
        inHoldingState = true;
        
        print_stats();
        
        % Check for pausing or quitting during ITI.
        startingTime = GetSecs;
        while ITI > (GetSecs - startingTime)
            key = key_check;
            
            % Pause experiment.
            if key.pause == 1
                pause(key);
            end
            
            % Exit experiment.
            if key.escape == 1
                running = false;
            end
        end
    end
    
    Screen('CloseAll');
    
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
                    % Notify Plexon that the eye is looking at the fixation dot.
                    if recordWithPlexon
                        toplexon(5051);
                    end
                    
                    % Determine if eye maintained fixation for given duration.
                    checkFixBreak = fix_break_check(fixBoundXMin, fixBoundXMax, ...
                                                    fixBoundYMin, fixBoundYMax, ...
                                                    duration);
                    
                    if checkFixBreak == false
                        % Notify Plexon that fixation on the fixation dot was acquired.
                        if recordWithPlexon
                            toplexon(5053);
                        end
                        
                        % Fixation was obtained for desired duration.
                        fixation = true;
                        area = 'single';
                        
                        return;
                    else
                        % Notify Plexon that the eye looked away from the fixation dot.
                        if recordWithPlexon
                            toplexon(5052);
                        end
                    end
                end
            % Determine if eye is within the left option boundary.
            elseif strcmp(type, 'singleLeft')
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
                        area = 'left';
                        
                        return;
                    end
                end
            % Determine if eye is within the right option boundary.
            elseif strcmp(type, 'singleRight')
                if xCoord >= rightBoundXMin && xCoord <= rightBoundXMax && ...
                   yCoord >= rightBoundYMin && yCoord <= rightBoundYMax
                    % Determine if eye maintained fixation for given duration.
                    checkFixBreak = fix_break_check(rightBoundXMin, rightBoundXMax, ...
                                                    rightBoundYMin, rightBoundYMax, ...
                                                    duration);
                    
                    if checkFixBreak == false
                        % Fixation was obtained for desired duration.
                        fixation = true;
                        area = 'right';
                        
                        return;
                    end
                end
            % Determine if eye is within the top option boundary.
            elseif strcmp(type, 'singleTop')
                if xCoord >= topBoundXMin && xCoord <= topBoundXMax && ...
                   yCoord >= topBoundYMin && yCoord <= topBoundYMax
                    % Determine if eye maintained fixation for given duration.
                    checkFixBreak = fix_break_check(topBoundXMin, topBoundXMax, ...
                                                    topBoundYMin, topBoundYMax, ...
                                                    duration);
                    
                    if checkFixBreak == false
                        % Fixation was obtained for desired duration.
                        fixation = true;
                        area = 'top';
                        
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
                    % Notify Plexon that the eye is looking at the left choice.
                    if recordWithPlexon
                        toplexon(5072);
                    end
                    
                    unstaggered_stimuli('looking;left');
                    
                    % Determine if eye maintained fixation for given duration.
                    checkFixBreak = fix_break_check(leftBoundXMin, leftBoundXMax, ...
                                                    leftBoundYMin, leftBoundYMax, ...
                                                    duration);
                    
                    if checkFixBreak == false
                        % Notify Plexon that fixation was acquired on a choice.
                        if recordWithPlexon
                            toplexon(5075);
                        end
                    
                        % Fixation was obtained for desired duration.
                        fixation = true;
                        area = 'left';
                        
                        return;
                    else
                        % Notify Plexon that fixation on previously looked at choice was lost.
                        if recordWithPlexon
                            toplexon(5074);
                        end
                        
                        unstaggered_stimuli('none;none');
                    end
                % Determine if eye is within the right option boundary.
                elseif xCoord >= rightBoundXMin && xCoord <= rightBoundXMax && ...
                       yCoord >= rightBoundYMin && yCoord <= rightBoundYMax
                    % Notify Plexon that the eye is looking at the right choice.
                    if recordWithPlexon
                        toplexon(5073);
                    end
                    
                    unstaggered_stimuli('looking;right');
                    
                    % Determine if eye maintained fixation for given duration.
                    checkFixBreak = fix_break_check(rightBoundXMin, rightBoundXMax, ...
                                                    rightBoundYMin, rightBoundYMax, ...
                                                    duration);
                    
                    if checkFixBreak == false
                        % Notify Plexon that fixation was acquired on a choice.
                        if recordWithPlexon
                            toplexon(5075);
                        end
                        
                        % Fixation was obtained for desired duration.
                        fixation = true;
                        area = 'right';
                        
                        return;
                    else
                        % Notify Plexon that fixation on previously looked at choice was lost.
                        if recordWithPlexon
                            toplexon(5074);
                        end
                        
                        unstaggered_stimuli('none;none');
                    end 
                % Determine if eye is within the top option boundary.
                elseif xCoord >= topBoundXMin && xCoord <= topBoundXMax && ...
                       yCoord >= topBoundYMin && yCoord <= topBoundYMax
                    % Notify Plexon that the eye is looking at the top choice.
                    if recordWithPlexon
                        toplexon(5071);
                    end
                    
                    unstaggered_stimuli('looking;top');
                    % Determine if eye maintained fixation for given duration.
                    checkFixBreak = fix_break_check(topBoundXMin, topBoundXMax, ...
                                                    topBoundYMin, topBoundYMax, ...
                                                    duration);
                    
                    if checkFixBreak == false
                        % Notify Plexon that fixation was acquired on a choice.
                        if recordWithPlexon
                            toplexon(5075);
                        end
                        
                        % Fixation was obtained for desired duration.
                        fixation = true;
                        area = 'top';
                        
                        return;
                    else
                        % Notify Plexon that fixation on previously looked at choice was lost.
                        if recordWithPlexon
                            toplexon(5074);
                        end
                        
                        unstaggered_stimuli('none;none');
                    end
                end
            else
                disp('Fixation being checked with an illegal value for the "type" parameter.');
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
        Screen('FrameRect', window, colorYellow, [fixBoundXMin fixBoundYMin ...
                                                  fixBoundXMax fixBoundYMax], 1);
        Screen('FrameRect', window, colorYellow, [topBoundXMin topBoundYMin ...
                                                  topBoundXMax topBoundYMax], 1);
        Screen('FrameRect', window, colorYellow, [leftBoundXMin leftBoundYMin ...
                                                  leftBoundXMax leftBoundYMax], 1);
        Screen('FrameRect', window, colorYellow, [rightBoundXMin rightBoundYMin ...
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
                
    % Make a currect answer type for a trial based on experiment type.
    function answer = generate_correct_answer()
        temp = struct([]);
        
        if strcmp(experimentType, 'colorShift')
            % Generate new colorShift values.
            if trialCount == 0 || genColorShift
                % Randomly choose correct color if it's the first trial.
                if trialCount == 0
                    % Choose a color randomly from the total color pool w/o replacement.
                    randValIndex1 = rand_int(2);
                    color1 = char(colors(randValIndex1));
                    % Delete the color just picked from the pool.
                    colors(randValIndex1) = [];

                    % Choose another color randomly from the pool w/o replacement.
                    randValIndex2 = rand_int(1);
                    color2 = char(colors(randValIndex2));
                    colors(randValIndex2) = [];
                    
                    % Choose the final color from the pool.
                    color3 = char(colors(1));

                    % Choose random shape if this is the first trial.
                    if trialCount == 0
                        randValIndex3 = rand_int(2);
                        shape = char(shapes(randValIndex3));
                    else
                        shape = chosenShape;
                    end

                    % Set chosen shape and colors.
                    chosenShape = shape;
                    colorOne = color1;
                    colorTwo = color2;
                    colorThree = color3;

                    % Set the correct answer type.
                    temp(currTrial).type = 'colorShift';
                    temp(currTrial).dimension = 'color';
                    temp(currTrial).value = colorOne;
                    temp(currTrial).shape = chosenShape;

                    % Reset trigger that decides if a full color shift occurs.
                    genColorShift = 0;
                    lastBlockColor = color1;
                % Otherwise make sure correct color isn't last's block's correct color.
                else
                    if strcmp(lastBlockColor, 'cyan')
                        tempColorArray = [{'magenta'}, {'yellow'}];
                    elseif strcmp(lastBlockColor, 'magenta')
                        tempColorArray = [{'cyan'}, {'yellow'}];
                    else
                        tempColorArray = [{'cyan'}, {'magenta'}];
                    end
                    
                    % Choose a color randomly from the small color pool.
                    randIndex = rand_int(1);
                    color1 = char(tempColorArray(randIndex));
                    tempColorArray(randIndex) = [];
                    
                    % Set the remaining colors.
                    color2 = char(tempColorArray(1));
                    color3 = lastBlockColor;
                    
                    % Set chosen colors (shape has already been set).
                    colorOne = color1;
                    colorTwo = color2;
                    colorThree = color3;

                    % Set the correct answer type.
                    temp(currTrial).type = 'colorShift';
                    temp(currTrial).dimension = 'color';
                    temp(currTrial).value = colorOne;
                    temp(currTrial).shape = chosenShape;

                    % Reset trigger that decides if a full color shift occurs.
                    genColorShift = 0;
                    lastBlockColor = colorOne;
                end
            else
                tempColor = colorOne;
                colorOne = colorTwo;
                colorTwo = tempColor;
                
                % Set the correct answer type.
                temp(currTrial).type = 'colorShift';
                temp(currTrial).dimension = 'color';
                temp(currTrial).value = colorOne;
                temp(currTrial).shape = chosenShape;
                
                lastBlockColor = colorOne;
            end
        elseif strcmp(experimentType, 'shapeShift')
            % Generate new shapeShift values.
            if trialCount == 0 || genShapeShift
                % Randomly choose correct shape if it's the first trial.
                if trialCount == 0
                    % Choose a shape randomly from the total shape pool w/o replacement.
                    randValIndex1 = rand_int(2);
                    shape1 = char(shapes(randValIndex1));
                    % Delete the shape just picked from the pool.
                    shapes(randValIndex1) = [];

                    % Choose another color randomly from the pool w/o replacement.
                    randValIndex2 = rand_int(1);
                    shape2 = char(shapes(randValIndex2));
                    shapes(randValIndex2) = [];
                    
                    % Choose the final shape from the pool.
                    shape3 = char(shapes(1));

                    % Choose random color if this is the first trial.
                    if trialCount == 0
                        randValIndex3 = rand_int(2);
                        color = char(colors(randValIndex3));
                    else
                        color = chosenColor;
                    end

                    % Set chosen color and shapes.
                    chosenColor = color;
                    shapeOne = shape1;
                    shapeTwo = shape2;
                    shapeThree = shape3;

                    % Set the correct answer type.
                    temp(currTrial).type = 'shapeShift';
                    temp(currTrial).dimension = 'shape';
                    temp(currTrial).value = shapeOne;
                    temp(currTrial).color = chosenColor;

                    % Reset trigger that decides if a full shape shift occurs.
                    genShapeShift = 0;
                    lastBlockShape = shape1;
                % Otherwise make sure correct shape isn't last's block's correct shape.
                else
                    if strcmp(lastBlockShape, 'circle')
                        tempShapeArray = [{'star'}, {'triangle'}];
                    elseif strcmp(lastBlockShape, 'star')
                        tempShapeArray = [{'circle'}, {'triangle'}];
                    else
                        tempShapeArray = [{'circle'}, {'star'}];
                    end
                    
                    % Choose a shape randomly from the small shape pool.
                    randIndex = rand_int(1);
                    shape1 = char(tempShapeArray(randIndex));
                    tempShapeArray(randIndex) = [];
                    
                    % Select the remaining color.
                    shape2 = char(tempShapeArray(1));
                    
                    shape3 = lastBlockShape;
                    
                    % Set chosen colors (shape has already been set).
                    shapeOne = shape1;
                    shapeTwo = shape2;
                    shapeThree = shape3;

                    % Set the correct answer type.
                    temp(currTrial).type = 'shapeShift';
                    temp(currTrial).dimension = 'shape';
                    temp(currTrial).value = shapeOne;
                    temp(currTrial).color = chosenColor;

                    % Reset trigger that decides if a full shape shift occurs.
                    genShapeShift = 0;
                    lastBlockShape = shapeOne;
                end
            else
                tempShape = shapeOne;
                shapeOne = shapeTwo;
                shapeTwo = tempShape;
                
                % Set the correct answer type.
                temp(currTrial).type = 'shapeShift';
                temp(currTrial).dimension = 'shape';
                temp(currTrial).value = shapeOne;
                temp(currTrial).color = chosenColor;
                
                lastBlockShape = shapeOne;
            end
        elseif strcmp(experimentType, 'intraSS') || strcmp(experimentType, 'extraSS')
            % Generate random correct stimulus if it's the first trial.
            if trialCount == 0
                % Choose a color randomly from the total color pool w/o replacement.
                randValIndex1 = rand_int(2);
                color1 = char(colors(randValIndex1));
                % Delete the color just picked from the pool.
                colors(randValIndex1) = [];

                % Choose another color randomly from the pool w/o replacement.
                randValIndex2 = rand_int(1);
                color2 = char(colors(randValIndex2));
                colors(randValIndex2) = [];

                % Choose the final color from the pool.
                color3 = char(colors(1));

                % Choose a shape randomly from the total shape pool w/o replacement.
                randValIndex1 = rand_int(2);
                shape1 = char(shapes(randValIndex1));
                % Delete the shape just picked from the pool.
                shapes(randValIndex1) = [];

                % Choose another color randomly from the pool w/o replacement.
                randValIndex2 = rand_int(1);
                shape2 = char(shapes(randValIndex2));
                shapes(randValIndex2) = [];

                % Choose the final shape from the pool.
                shape3 = char(shapes(1));

                % Set chosen shape and colors.
                shapeOne = shape1;
                shapeTwo = shape2;
                shapeThree = shape3;
                colorOne = color1;
                colorTwo = color2;
                colorThree = color3;
                
                % Set a random dimension to use for this entire session if requested.
                if strcmp(sessionDimension, 'random') || strcmp(allRandom, 'yes')
                    randIndex = rand_int(1);
                    sessionDimension = char(dimension(randIndex));
                end
                
                % Set the correct answer type.
                if strcmp(sessionDimension, 'color')
                    trialValue = colorOne;
                else
                    trialValue = shapeOne;
                end
                
                temp(currTrial).type = experimentType;
                temp(currTrial).dimension = sessionDimension;
                temp(currTrial).value = trialValue;

                % Reset trigger that decides if a full shift occurs.
                lastBlockValue = trialValue;
            % Generate set-shift stimuli changes.
            elseif genDimSetShift
                % Stimuli choices for a non-repeating stimuli experiment.
                if strcmp(allRandom, 'no')
                    if strcmp(colorOne, 'cyan')
                        tempColorArray = [{'magenta'}, {'yellow'}];
                        lastColor = 'cyan';
                    elseif strcmp(colorOne, 'magenta')
                        tempColorArray = [{'cyan'}, {'yellow'}];
                        lastColor = 'magenta';
                    else
                        tempColorArray = [{'cyan'}, {'magenta'}];
                        lastColor = 'yellow';
                    end

                    if strcmp(shapeOne, 'circle')
                        tempShapeArray = [{'star'}, {'triangle'}];
                        lastShape = 'circle';
                    elseif strcmp(shapeOne, 'star')
                        tempShapeArray = [{'circle'}, {'triangle'}];
                        lastShape = 'star';
                    else
                        tempShapeArray = [{'circle'}, {'star'}];
                        lastShape = 'triangle';
                    end

                    % Choose a color randomly from the small color pool.
                    randIndex = rand_int(1);
                    color1 = char(tempColorArray(randIndex));
                    tempColorArray(randIndex) = [];

                    % Set the remaining colors.
                    color2 = char(tempColorArray(1));
                    color3 = lastColor;

                    % Choose a shape randomly from the small shape pool.
                    randIndex = rand_int(1);
                    shape1 = char(tempShapeArray(randIndex));
                    tempShapeArray(randIndex) = [];

                    % Select the remaining color.
                    shape2 = char(tempShapeArray(1));
                    shape3 = lastShape;
                % Stimuli choices for a random stimuli experiment.
                else
                    % Choose a color randomly from the total color pool w/o replacement.
                    randValIndex1 = rand_int(2);
                    color1 = char(colors(randValIndex1));
                    % Delete the color just picked from the pool.
                    colors(randValIndex1) = [];

                    % Choose another color randomly from the pool w/o replacement.
                    randValIndex2 = rand_int(1);
                    color2 = char(colors(randValIndex2));
                    colors(randValIndex2) = [];

                    % Choose the final color from the pool.
                    color3 = char(colors(1));

                    % Choose a shape randomly from the total shape pool w/o replacement.
                    randValIndex1 = rand_int(2);
                    shape1 = char(shapes(randValIndex1));
                    % Delete the shape just picked from the pool.
                    shapes(randValIndex1) = [];

                    % Choose another color randomly from the pool w/o replacement.
                    randValIndex2 = rand_int(1);
                    shape2 = char(shapes(randValIndex2));
                    shapes(randValIndex2) = [];

                    % Choose the final shape from the pool.
                    shape3 = char(shapes(1));
                end
                
                % Set shapes and colors.
                shapeOne = shape1;
                shapeTwo = shape2;
                shapeThree = shape3;
                colorOne = color1;
                colorTwo = color2;
                colorThree = color3;
                
                % Choose non-random dimension.
                if strcmp(allRandom, 'no')
                    % Set the correct answer types depending on the experiment type.
                    if strcmp(experimentType, 'intraSS')
                        if strcmp(sessionDimension, 'color')
                            sessionDimension = 'color';
                            trialValue = colorOne;
                        else
                            sessionDimension = 'shape';
                            trialValue = shapeOne;
                        end
                    else
                        if strcmp(sessionDimension, 'color')
                            sessionDimension = 'shape';
                            trialValue = shapeOne;
                        else
                            sessionDimension = 'color';
                            trialValue = colorOne;
                        end
                    end
                % Choose random dimension (except for the 'intraSS' task).
                else
                    % Set the correct answer types depending on the experiment type.
                    if strcmp(experimentType, 'intraSS')
                        if strcmp(sessionDimension, 'color')
                            sessionDimension = 'color';
                            trialValue = colorOne;
                        else
                            sessionDimension = 'shape';
                            trialValue = shapeOne;
                        end
                    else
                        randIndex = rand_int(1);
                        sessionDimension = char(dimension(randIndex));
                        
                        if strcmp(sessionDimension, 'color')
                            trialValue = colorOne;
                        else
                            trialValue = shapeOne;
                        end
                    end
                end
                
                % Set the correct answer type.
                temp(currTrial).type = experimentType;
                temp(currTrial).dimension = sessionDimension;
                temp(currTrial).value = trialValue;

                % Reset trigger that decides if a full color shift occurs.
                genDimSetShift = 0;
                lastBlockValue = trialValue;
            % Generate intra-block stimuli changes.
            else
                if strcmp(colorOne, 'cyan')
                    tempColorArray = [{'magenta'}, {'yellow'}];
                    lastColor = 'cyan';
                elseif strcmp(colorOne, 'magenta')
                    tempColorArray = [{'cyan'}, {'yellow'}];
                    lastColor = 'magenta';
                else
                    tempColorArray = [{'cyan'}, {'magenta'}];
                    lastColor = 'yellow';
                end

                if strcmp(shapeOne, 'circle')
                    tempShapeArray = [{'star'}, {'triangle'}];
                    lastShape = 'circle';
                elseif strcmp(shapeOne, 'star')
                    tempShapeArray = [{'circle'}, {'triangle'}];
                    lastShape = 'star';
                else
                    tempShapeArray = [{'circle'}, {'star'}];
                    lastShape = 'triangle';
                end

                % Keep correct color the same; reset all other values.
                if strcmp(sessionDimension, 'color')
                    % Choose a color randomly from the small color pool.
                    color1 = colorOne;
                    randIndex = rand_int(1);
                    color2 = char(tempColorArray(randIndex));
                    tempColorArray(randIndex) = [];

                    % Set the remaining color.
                    color3 = char(tempColorArray(1));
                    
                    % Don't repeat the last value if the randomness setting is off.
                    if strcmp(allRandom, 'no')
                        % Choose a shape randomly from the small shape pool.
                        randIndex = rand_int(1);
                        shape1 = char(tempShapeArray(randIndex));
                        tempShapeArray(randIndex) = [];
                        
                        % Select the remaining shapes.
                        shape2 = char(tempShapeArray(1));
                        shape3 = lastShape;
                    % Pick shapes randomly from all possible shapes.
                    else
                        % Choose a shape randomly from all possible values.
                        randIndex1 = rand_int(2);
                        shape1 = char(shapes(randIndex1));
                        shapes(randIndex1) = [];
                        
                        % Select the remaining shapes randomly.
                        randIndex2 = rand_int(1);
                        shape2 = char(shapes(randIndex2));
                        shapes(randIndex2) = [];
                        shape3 = char(shapes(1));
                    end
                % Keep correct shape the same; reset all other values.
                else
                    % Choose a shape randomly from the small color pool.
                    shape1 = shapeOne;
                    randIndex = rand_int(1);
                    shape2 = char(tempShapeArray(randIndex));
                    tempShapeArray(randIndex) = [];

                    % Set the remaining shape.
                    shape3 = char(tempShapeArray(1));
                    
                    % Don't repeat the last value if the randomness setting is off.
                    if strcmp(allRandom, 'no')
                        % Choose a color randomly from the small shape pool.
                        randIndex = rand_int(1);
                        color1 = char(tempColorArray(randIndex));
                        tempColorArray(randIndex) = [];

                        % Select the remaining colors.
                        color2 = char(tempColorArray(1));
                        color3 = lastColor;
                    % Pick colors randomly from all possible colors.
                    else
                        % Choose a color randomly from all possible values.
                        randIndex1 = rand_int(2);
                        color1 = char(colors(randIndex1));
                        colors(randIndex1) = [];
                        
                        % Select the remaining shapes randomly.
                        randIndex2 = rand_int(1);
                        color2 = char(colors(randIndex2));
                        colors(randIndex2) = [];
                        color3 = char(colors(1));
                    end
                end
                
                % Set shapes and colors.
                shapeOne = shape1;
                shapeTwo = shape2;
                shapeThree = shape3;
                colorOne = color1;
                colorTwo = color2;
                colorThree = color3;
                
                % Set the correct answer type.
                if strcmp(sessionDimension, 'color')
                    trialValue = colorOne;
                else
                    trialValue = shapeOne;
                end
                
                % Set the correct answer type.
                temp(currTrial).type = experimentType;
                temp(currTrial).dimension = sessionDimension;
                temp(currTrial).value = trialValue;
                
                lastBlockValue = trialValue;
            end
        elseif strcmp(experimentType, 'reversal')
            % THIS CONDITION IS NOT CURRENTLY SUPPORTED.
        else
            disp('Error in generate_correct_answer.');
        end
        
        % Reset these global variables.
        colors    = [{'cyan'}, {'magenta'}, {'yellow'}];
        dimension = [{'color'}, {'shape'}];
        shapes    = [{'circle'}, {'star'}, {'triangle'}];
        
        % Sets the current correct response.
        currentAnswer = temp(currTrial).value;
        
        answer = temp;
    end
    
    % Make random stimuli for a trial, making sure correct ans is included.
    function stimuli = generate_trial_stimuli()
        temp = struct([]);
        correctVal = currentAnswer;
        
        if strcmp(experimentType, 'reversal')
            % THIS CONDITION IS NOT CURRENTLY SUPPORTED.
        elseif strcmp(experimentType, 'intraSS') || strcmp(experimentType, 'extraSS')
            % Just generate a random location for the correct choice.
            if currTrial == 1 || strcmp(allRandom, 'yes')
                % Randomly select positions for each stimulus.
                randIndex1 = rand_int(2);
                randIndex2 = rand_int(1);
                correctPos = char(positions(randIndex1));
                positions(randIndex1) = [];
                otherPos1 = char(positions(randIndex2));
                positions(randIndex2) = [];
                otherPos2 = char(positions(1));
                
                % Set those positions.
                if strcmp(correctPos, 'left')
                    leftVal = strcat(shapeOne, ';', colorOne);
                    correctSpot = 'left';
                elseif strcmp(correctPos, 'right')
                    rightVal = strcat(shapeOne, ';', colorOne);
                    correctSpot = 'right';
                elseif strcmp(correctPos, 'top')
                    topVal = strcat(shapeOne, ';', colorOne);
                    correctSpot = 'top';
                end
                
                if strcmp(otherPos1, 'left')
                    leftVal = strcat(shapeTwo, ';', colorTwo);
                elseif strcmp(otherPos1, 'right')
                    rightVal = strcat(shapeTwo, ';', colorTwo);
                elseif strcmp(otherPos1, 'top')
                    topVal = strcat(shapeTwo, ';', colorTwo);
                end
                
                if strcmp(otherPos2, 'left')
                    leftVal = strcat(shapeThree, ';', colorThree);
                elseif strcmp(otherPos2, 'right')
                    rightVal = strcat(shapeThree, ';', colorThree);
                elseif strcmp(otherPos2, 'top')
                    topVal = strcat(shapeThree, ';', colorThree);
                end
                
                % Set the trial values: '<shape>;<color>'.
                temp(currTrial).left  = leftVal;
                temp(currTrial).right = rightVal;
                temp(currTrial).top = topVal;
                
                % Note the location of the correct choice.
                corrAnsObject(currTrial).correct = correctSpot;
                lastCorrPos = correctSpot;
            % Make sure the correct choice is not in the same location.
            else
                if strcmp(lastCorrPos, 'left')
                    tempPosArray = [{'right'}, {'top'}];
                elseif strcmp(lastCorrPos, 'right')
                    tempPosArray = [{'left'}, {'top'}];
                else
                    tempPosArray = [{'left'}, {'right'}];
                end
                
                % Randomly select positions for each stimulus.
                randIndex = rand_int(1);
                correctPos = char(tempPosArray(randIndex));
                tempPosArray(randIndex) = [];
                otherPos1 = char(tempPosArray(1));
                otherPos2 = lastCorrPos;
                
                % Set those positions.
                if strcmp(correctPos, 'left')
                    leftVal = strcat(shapeOne, ';', colorOne);
                    correctSpot = 'left';
                elseif strcmp(correctPos, 'right')
                    rightVal = strcat(shapeOne, ';', colorOne);
                    correctSpot = 'right';
                elseif strcmp(correctPos, 'top')
                    topVal = strcat(shapeOne, ';', colorOne);
                    correctSpot = 'top';
                end
                
                if strcmp(otherPos1, 'left')
                    leftVal = strcat(shapeTwo, ';', colorTwo);
                elseif strcmp(otherPos1, 'right')
                    rightVal = strcat(shapeTwo, ';', colorTwo);
                elseif strcmp(otherPos1, 'top')
                    topVal = strcat(shapeTwo, ';', colorTwo);
                end
                
                if strcmp(otherPos2, 'left')
                    leftVal = strcat(shapeThree, ';', colorThree);
                elseif strcmp(otherPos2, 'right')
                    rightVal = strcat(shapeThree, ';', colorThree);
                elseif strcmp(otherPos2, 'top')
                    topVal = strcat(shapeThree, ';', colorThree);
                end
                
                % Set the trial values: '<shape>;<color>'.
                temp(currTrial).left  = leftVal;
                temp(currTrial).right = rightVal;
                temp(currTrial).top = topVal;

                % Note the location of the correct choice.
                corrAnsObject(currTrial).correct = correctSpot;
                lastCorrPos = correctSpot;
            end
        elseif strcmp(experimentType, 'colorShift')
            % Just generate a random location for the correct choice.
            if currTrial == 1
                if colorShiftNumColors == 2
                    tempColors = [{colorOne}, {colorTwo}, {colorTwo}];
                elseif colorShiftNumColors == 3
                    tempColors = [{colorOne}, {colorTwo}, {colorThree}];
                else
                    disp('The colorShiftNumColors variable has an illegal value.');
                end
                
                % Find left stimulus value.
                randIndex1 = rand_int(2);
                leftValSub = char(tempColors(randIndex1));
                tempColors(randIndex1) = [];

                % Find right stimulus value.
                randIndex2 = rand_int(1);
                rightValSub = char(tempColors(randIndex2));
                tempColors(randIndex2) = [];
                
                % Find top stimulus value.
                topValSub = char(tempColors(1));

                leftVal = strcat(chosenShape, ';', leftValSub);
                rightVal = strcat(chosenShape, ';', rightValSub);
                topVal = strcat(chosenShape, ';', topValSub);

                % Set the trial values: '<shape>;<color>'.
                temp(currTrial).left  = leftVal;
                temp(currTrial).right = rightVal;
                temp(currTrial).top = topVal;
                
                % Determine where the correct choice is located.
                if strcmp(leftValSub, correctVal)
                    correctSpot = 'left';
                elseif strcmp(rightValSub, correctVal)
                    correctSpot = 'right';
                elseif strcmp(topValSub, correctVal)
                    correctSpot = 'top';
                end
                
                % Note the location of the correct choice.
                corrAnsObject(currTrial).correct = correctSpot;
                lastCorrPos = correctSpot;
            % Make sure the correct choice is not in the same location.
            else
                if colorShiftNumColors == 2
                    tempColors = [{colorTwo}, {colorTwo}];
                elseif colorShiftNumColors == 3
                    tempColors = [{colorTwo}, {colorThree}];
                else
                    disp('The colorShiftNumColors variable has an illegal value.');
                end
                
                leftSubVal = '';
                rightSubVal = '';
                topSubVal = '';
                correctSpot = '';
                
                % Choose new correct position from 2 that it wasn't last time.
                if strcmp(lastCorrPos, 'left')
                    tempArray = [{'right'}, {'top'}];
                    randIndex1 = rand_int(1);
                    newCorrPosition = char(tempArray(randIndex1));
                    
                    if strcmp(newCorrPosition, 'right')
                        rightSubVal = colorOne;
                        randIndex2 = rand_int(1);
                        leftSubVal = char(tempColors(randIndex2));
                        tempColors(randIndex2) = [];
                        topSubVal = char(tempColors(1));
                        
                        correctSpot = 'right';
                    else
                        topSubVal = colorOne;
                        randIndex3 = rand_int(1);
                        leftSubVal = char(tempColors(randIndex3));
                        tempColors(randIndex3) = [];
                        rightSubVal = char(tempColors(1));
                        
                        correctSpot = 'top';
                    end
                elseif strcmp(lastCorrPos, 'right')
                    tempArray = [{'left'}, {'top'}];
                    randIndex1 = rand_int(1);
                    newCorrPosition = char(tempArray(randIndex1));
                    
                    if strcmp(newCorrPosition, 'left')
                        leftSubVal = colorOne;
                        randIndex2 = rand_int(1);
                        rightSubVal = char(tempColors(randIndex2));
                        tempColors(randIndex2) = [];
                        topSubVal = char(tempColors(1));
                        
                        correctSpot = 'left';
                    else
                        topSubVal = colorOne;
                        randIndex3 = rand_int(1);
                        leftSubVal = char(tempColors(randIndex3));
                        tempColors(randIndex3) = [];
                        rightSubVal = char(tempColors(1));
                        
                        correctSpot = 'top';
                    end
                elseif strcmp(lastCorrPos, 'top')
                    tempArray = [{'left'}, {'right'}];
                    randIndex1 = rand_int(1);
                    newCorrPosition = char(tempArray(randIndex1));
                    
                    if strcmp(newCorrPosition, 'left')
                        leftSubVal = colorOne;
                        randIndex2 = rand_int(1);
                        rightSubVal = char(tempColors(randIndex2));
                        tempColors(randIndex2) = [];
                        topSubVal = char(tempColors(1));
                        
                        correctSpot = 'left';
                    else
                        rightSubVal = colorOne;
                        randIndex3 = rand_int(1);
                        leftSubVal = char(tempColors(randIndex3));
                        tempColors(randIndex3) = [];
                        topSubVal = char(tempColors(1));
                        
                        correctSpot = 'right';
                    end
                end
                
                leftVal = strcat(chosenShape, ';', leftSubVal);
                rightVal = strcat(chosenShape, ';', rightSubVal);
                topVal = strcat(chosenShape, ';', topSubVal);

                % Set the trial values: '<shape>;<color>'.
                temp(currTrial).left  = leftVal;
                temp(currTrial).right = rightVal;
                temp(currTrial).top = topVal;

                % Note the location of the correct choice.
                corrAnsObject(currTrial).correct = correctSpot;
                lastCorrPos = correctSpot;
            end
        elseif strcmp(experimentType, 'shapeShift')
            % Just generate a random location for the correct choice.
            if currTrial == 1
                if shapeShiftNumShapes == 2
                    tempShapes = [{shapeOne}, {shapeTwo}, {shapeTwo}];
                elseif shapeShiftNumShapes == 3
                    tempShapes = [{shapeOne}, {shapeTwo}, {shapeThree}];
                else
                    disp('The colorShiftNumColors variable has an illegal value.');
                end
                
                % Find left stimulus value.
                randIndex1 = rand_int(2);
                leftValSub = char(tempShapes(randIndex1));
                tempShapes(randIndex1) = [];

                % Find right stimulus value.
                randIndex2 = rand_int(1);
                rightValSub = char(tempShapes(randIndex2));
                tempShapes(randIndex2) = [];

                % Find top stimulus value.
                topValSub = char(tempShapes(1));

                leftVal = strcat(leftValSub, ';', chosenColor);
                rightVal = strcat(rightValSub, ';', chosenColor);
                topVal = strcat(topValSub, ';', chosenColor);

                % Set the trial values: '<shape>;<color>'.
                temp(currTrial).left  = leftVal;
                temp(currTrial).right = rightVal;
                temp(currTrial).top = topVal;
                
                % Determine where the correct choice is located.
                if strcmp(leftValSub, correctVal)
                    correctSpot = 'left';
                elseif strcmp(rightValSub, correctVal)
                    correctSpot = 'right';
                elseif strcmp(topValSub, correctVal)
                    correctSpot = 'top';
                end
                
                % Note the location of the correct choice.
                corrAnsObject(currTrial).correct = correctSpot;
                lastCorrPos = correctSpot;
            % Make sure the correct choice is not in the same location.
            else
                if shapeShiftNumShapes == 2
                    tempShapes = [{shapeTwo}, {shapeTwo}];
                elseif shapeShiftNumShapes == 3
                    tempShapes = [{shapeTwo}, {shapeThree}];
                else
                    disp('The shapeShiftNumShapes variable has an illegal value.');
                end
                
                leftSubVal = '';
                rightSubVal = '';
                topSubVal = '';
                correctSpot = '';
                
                % Choose new correct position from 2 that it wasn't last time.
                if strcmp(lastCorrPos, 'left')
                    tempArray = [{'right'}, {'top'}];
                    randIndex1 = rand_int(1);
                    newCorrPosition = char(tempArray(randIndex1));
                    
                    if strcmp(newCorrPosition, 'right')
                        rightSubVal = shapeOne;
                        randIndex2 = rand_int(1);
                        leftSubVal = char(tempShapes(randIndex2));
                        tempShapes(randIndex2) = [];
                        topSubVal = char(tempShapes(1));
                        
                        correctSpot = 'right';
                    else
                        topSubVal = shapeOne;
                        randIndex3 = rand_int(1);
                        leftSubVal = char(tempShapes(randIndex3));
                        tempShapes(randIndex3) = [];
                        rightSubVal = char(tempShapes(1));
                        
                        correctSpot = 'top';
                    end
                elseif strcmp(lastCorrPos, 'right')
                    tempArray = [{'left'}, {'top'}];
                    randIndex1 = rand_int(1);
                    newCorrPosition = char(tempArray(randIndex1));
                    
                    if strcmp(newCorrPosition, 'left')
                        leftSubVal = shapeOne;
                        randIndex2 = rand_int(1);
                        rightSubVal = char(tempShapes(randIndex2));
                        tempShapes(randIndex2) = [];
                        topSubVal = char(tempShapes(1));
                        
                        correctSpot = 'left';
                    else
                        topSubVal = shapeOne;
                        randIndex3 = rand_int(1);
                        leftSubVal = char(tempShapes(randIndex3));
                        tempShapes(randIndex3) = [];
                        rightSubVal = char(tempShapes(1));
                        
                        correctSpot = 'top';
                    end
                elseif strcmp(lastCorrPos, 'top')
                    tempArray = [{'left'}, {'right'}];
                    randIndex1 = rand_int(1);
                    newCorrPosition = char(tempArray(randIndex1));
                    
                    if strcmp(newCorrPosition, 'left')
                        leftSubVal = shapeOne;
                        randIndex2 = rand_int(1);
                        rightSubVal = char(tempShapes(randIndex2));
                        tempShapes(randIndex2) = [];
                        topSubVal = char(tempShapes(1));
                        
                        correctSpot = 'left';
                    else
                        rightSubVal = shapeOne;
                        randIndex3 = rand_int(1);
                        leftSubVal = char(tempShapes(randIndex3));
                        tempShapes(randIndex3) = [];
                        topSubVal = char(tempShapes(1));
                        
                        correctSpot = 'right';
                    end
                end
                
                leftVal = strcat(leftSubVal, ';', chosenColor);
                rightVal = strcat(rightSubVal, ';', chosenColor);
                topVal = strcat(topSubVal, ';', chosenColor);

                % Set the trial values: '<shape>;<color>'.
                temp(currTrial).left  = leftVal;
                temp(currTrial).right = rightVal;
                temp(currTrial).top = topVal;

                % Note the location of the correct choice.
                corrAnsObject(currTrial).correct = correctSpot;
                lastCorrPos = correctSpot;
            end
        end
        
        % Reset these global variables. MAKE THIS BETTER.
        colors = [{'cyan'}, {'magenta'}, {'yellow'}];
        positions = [{'left'}, {'right'}, {'top'}];
        shapes = [{'circle'}, {'star'}, {'triangle'}];
        
        stimuli = temp;
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
        pauseKey = KbName('RightControl');
        
        % Make sure default values of key are zero.
        key.pressed = 0;
        key.escape = 0;
        key.pause = 0;
        
        % Get info about any key that was just pressed.
        [keyIsDown, secs, keyCode] = KbCheck;
        
        % Check pressed key against the keyCode array of 256 key codes.
        if keyCode(stopKey)
            key.escape = 1;
            key.pressed = 1;
        end
        
        if keyCode(pauseKey)
            key.pause = 1;
            key.pressed = 1;
        end
    end
    
    % Execute a passsed key command.
    function key_execute(keyRef)
        % Stop task at end of current trial.
        if keyRef.escape == true
            running = false;
        end
    end
    
    function k = pause(k)
        disp('             ');
        disp('\\\\\\\\\\\\\\\\\\\\\\\\\\\\          /////////////////////////////');
        disp(' \\\\\\\\\\\\\\\\\\\\\\\\\\\\ PAUSED /////////////////////////////');
        disp('  |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||');
        
        while k.pressed == 1
            k = key_check;
        end
        
        pause = 1;
        while pause == 1 && k.escape ~= 1
            k = key_check;
            
            if k.pause == 1
                pause = 0;
            end
        end
        
        while k.pressed == 1
            k = key_check;
        end
        
        disp('             ');
        disp('  ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||');
        disp(' /////////////////////////// UNPAUSED \\\\\\\\\\\\\\\\\\\\\\\\\\\');
        disp('///////////////////////////            \\\\\\\\\\\\\\\\\\\\\\\\\\\');
        disp('             ');
    end
    
    % Makes a folder and file where data will be saved.
    function prepare_for_saving()
        cd(setShiftingData);
        
        % Check if cell ID was passed in with monkey's initial.
        if numel(monkeysInitial) == 1
            initial = monkeysInitial;
            cell = '';
        else
            initial = monkeysInitial(1);
            cell = monkeysInitial(2);
        end
        
        dateStr = datestr(now, 'yymmdd');
        filename = [initial dateStr '.' cell '1.SS.mat'];
        folderNameDay = [initial dateStr];
        
        % Make and/or enter a folder where trial block folders are located.
        if exist(folderNameDay, 'dir') == 7
            cd(folderNameDay);
        else
            mkdir(folderNameDay);
            cd(folderNameDay);
        end
        
        % Make sure the filename for the .mat file is not already used.
        fileNum = 1;
        while fileNum ~= 0
            if exist(filename, 'file') == 2
                fileNum = fileNum + 1;
                filename = [initial dateStr '.' cell num2str(fileNum) '.SS.mat'];
            else
                fileNum = 0;
            end
        end
        
        saveCommand = ['save ' filename ' ' varName];
    end
    
    % Prints current trial stats.
    function print_stats()
        % Convert percentages to strings.
        blockPercentCorrStr  = strcat(num2str(blockPercentCorr), '%');
        totalPercentCorrStr  = strcat(num2str(totalPercentCorr), '%');
        currBlockTrialStr    = num2str(currBlockTrial);
        trialCountStr        = num2str(trialCount);
        
        home;
        disp('             ');
        disp('****************************************');
        disp('             ');
        fprintf('Block trials: % s', currBlockTrialStr);
        disp('             ');
        fprintf('Total trials: % s', trialCountStr);
        disp('             ');
        disp('             ');
        disp('----------------------------------------');
        disp('             ');
        fprintf('Block correct: % s', blockPercentCorrStr);
        disp('             ');
        fprintf('Total correct: % s', totalPercentCorrStr);
        disp('             ');
        disp('             ');
        disp('****************************************');
    end
    
    % Returns a random int between 1 (inclusive) and integer + 1 (inclusive).
    function randInt = rand_int(integer)
        randInt = round(rand(1) * integer + 1);
    end
    
    % Rewards monkey using the juicer with the passed duration.
    function reward(rewardDuration)
        if rewardDuration ~= 0
            % Get a reference the juicer device and set reward duration.
            daq = DaqDeviceIndex;
            
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
        % Notify Plexon that a new trial is starting.
        if recordWithPlexon
            toplexon(4000);
        end
        
        currTrial = currTrial + 1;
        currIntBlockTrial = currIntBlockTrial + 1;
        
        % Fixation dot appears.
        draw_fixation_point(colorYellow);
        
        % Notify Plexon that the fixation dot appeared.
        if recordWithPlexon
            toplexon(5001);
        end
        
        % Check for fixation.
        [fixating, ~] = check_fixation('single', minFixTime, timeToFix);
        
        if fixating
            % Make sure correct answer is set at start of the session.
            if trialCount == 0
                corrAnsObject = generate_correct_answer;
            end
            
            % Genererate correct trial answer.
            if (strcmp(experimentType, 'intraSS') || strcmp(experimentType, 'extraSS')) && ...
                trialCount ~= 0 && numCorrTrials ~= numCorrectToShift && passedTrial
                corrAnsObject = generate_correct_answer;
            end
            
            % Reset correct answer if shift needs to occur.
            if numCorrTrials == numCorrectToShift
                % Updates.
                currBlockTrial = 0;
                numCorrTrials = 0;
                shifts = shifts + 1;
                currIntBlockTrial = 1;
                
                % Increment a shift counter.
                if strcmp(experimentType, 'colorShift')
                    colorSetUnits = colorSetUnits + 1;
                elseif strcmp(experimentType, 'shapeShift')
                    shapeSetUnits = shapeSetUnits + 1;
                end
                
                % Schedule full color shift update at the 2nd shift.
                if (mod(colorSetUnits, 2) == 0 || colorShiftNumColors == 3) && ...
                    strcmp(experimentType, 'colorShift')
                    genColorShift = 1;
                end
                
                % Schedule full color shift update at the 2nd shift.
                if (mod(shapeSetUnits, 2) == 0 || shapeShiftNumShapes == 3) && ...
                    strcmp(experimentType, 'shapeShift')
                    genShapeShift = 1;
                end
                
                % Schedule a full intradimensional shift.
                if strcmp(experimentType, 'intraSS') || strcmp(experimentType, 'extraSS')
                    genDimSetShift = 1;
                end
                
                corrAnsObject = generate_correct_answer;
            end
            
            % Check experiment type.
            if strcmp(experimentType, 'reversal')
                % THIS CONDITION IS NOT CURRENTLY SUPPORTED.
                trialObject = generate_trial_stimuli; % Make sure to generate some stimuli!
            elseif strcmp(experimentType, 'intraSS') || ...
                   strcmp(experimentType, 'extraSS') || ...
                   strcmp(experimentType, 'colorShift') || ...
                   strcmp(experimentType, 'shapeShift')
                % Only make new stimuli if the trial is passed.
                if passedTrial
                    trialObject = generate_trial_stimuli;
                else
                    newObj = struct([]);
                    newObj(currTrial).left = trialObject(currTrial - 1).left;
                    newObj(currTrial).right = trialObject(currTrial - 1).right;
                    newObj(currTrial).top = trialObject(currTrial - 1).top;
                    trialObject = newObj;
                end
                
                % Run a staggered stimuli presentation session.
                if strcmp(sessionType, 'unstaggered')
                    unstaggered_stimuli('none;none');
                    
                    % Make sure fixation is held before a target is chosen.
                    fixationBreak = fix_break_check(fixBoundXMin, fixBoundXMax, ...
                                                    fixBoundYMin, fixBoundYMax, ...
                                                    chooseHoldFixTime);
                    
                    if fixationBreak
                        % Start trial over because fixation wasn't held.
                        run_single_trial;
                    else
                        inHoldingState = false;
                        unstaggered_stimuli('none;none');
                    end
                % Run an unstaggered stimuli presentation session.
                elseif strcmp(sessionType, 'staggered')
                    staggered_stimuli;
                    
                    % Use unstaggered function to draw all 3 options at once with required fixation.
                    unstaggered_stimuli('none;none');
                    
                    % Notify Plexon that all three options appeared.
                    if recordWithPlexon
                        toplexon(5009);
                    end
                    
                    % Check for fixation.
                    [refixating, ~] = check_fixation('single', minFixTime, timeToFix);
                    
                    if ~refixating
                        % Start trial over because fixation wasn't held.
                        run_single_trial;
                    else
                        inHoldingState = false;
                        unstaggered_stimuli('none;none');
                    end
                end
                
                fixatingOnTarget = false;
                while ~fixatingOnTarget
                    % Check for fixation on any three targets.
                    [fixatingOnTarget, area] = check_fixation('triple', holdFixTime, timeToFix);
                    
                    if fixatingOnTarget
                        % Fetch correct location.
                        if passedTrial
                            currTrialNumForObj = currTrial;
                        else
                            currTrialNumForObj = currTrialAtError;
                        end
                        
                        correctSpot = corrAnsObject(currTrialNumForObj).correct;
                        currAnsPosition = correctSpot;
                        
                        if strcmp(area, correctSpot)
                            % Display feedback stimuli.
                            unstaggered_stimuli(strcat('correct', ';', area));
                            
                            % Give reward.
                            reward(rewardDuration);
                            
                            % Notify Plexon that correct feedback has been given.
                            if recordWithPlexon
                                toplexon(5010);
                            end
                            
                            WaitSecs(feedbackTime);
                            
                            % Clear screen.
                            Screen('FillRect', window, colorBackground, ...
                                   [0 0 (centerX * 2) (centerY * 2)]);
                            Screen('Flip', window);
                            
                            % Notify Plexon that all stimuli are gone.
                            if recordWithPlexon
                                toplexon(5012);
                            end
                            
                            % Update.
                            chosenPosition = area;
                            currentDim = char(corrAnsObject(currTrialNumForObj).dimension);
                            numCorrTrials = numCorrTrials + 1;
                            passedTrial = true;
                            rewarded = 'yes';
                            totalNumCorrTrials = totalNumCorrTrials + 1;
                            trialOutcome = 'correct';
                            trialCount = trialCount + 1;
                            currBlockTrial = currBlockTrial + 1;
                            
                            % Calculate percentages.
                            blockPercentCorr = round((numCorrTrials / currBlockTrial) * 100);
                            totalPercentCorr = round((totalNumCorrTrials / trialCount) * 100);
                            
                            % Save trial data.
                            send_and_save;
                        else
                            % Display feedback stimuli.
                            unstaggered_stimuli(strcat('incorrect', ';', area));
                            
                            % Notify Plexon that incorrect feedback has been given.
                            if recordWithPlexon
                                toplexon(5011);
                            end
                            
                            WaitSecs(feedbackTime);
                            
                            % Clear screen.
                            Screen('FillRect', window, colorBackground, ...
                                   [0 0 (centerX * 2) (centerY * 2)]);
                            Screen('Flip', window);
                            
                            % Notify Plexon that all stimuli are gone.
                            if recordWithPlexon
                                toplexon(5012);
                            end
                            
                            % Only reset error trial tracker if this is the first error in a row.
                            if passedTrial
                                currTrialAtError = currTrial;
                            end
                            
                            % Update.
                            chosenPosition = area;
                            currentDim = char(corrAnsObject(currTrialNumForObj).dimension);
                            passedTrial = false;
                            rewarded = 'no';
                            trialOutcome = 'incorrect';
                            trialCount = trialCount + 1;
                            currBlockTrial = currBlockTrial + 1;
                            
                            % Calculate percentages.
                            blockPercentCorr = round((numCorrTrials / currBlockTrial) * 100);
                            totalPercentCorr = round((totalNumCorrTrials / trialCount) * 100);
                            
                            % Save trial data.
                            send_and_save;
                        end
                    end
                end
            else
                disp('Experiment started with an illegal value for the "experimentType" parameter.');
            end
        else
            % Redo this trial since monkey failed to start it.
            run_single_trial;
        end
        
        % Notify Plexon that the trial has ended.
        if recordWithPlexon
            toplexon(8000);
        end
    end
    
    % Saves trial data to a .mat file.
    function send_and_save()
        % Convert correct answer position into a code.
        if strcmp(currAnsPosition, 'left')
            corrPosCode = 2;
        elseif strcmp(currAnsPosition, 'right')
            corrPosCode = 3;
        elseif strcmp(currAnsPosition, 'top')
            corrPosCode = 1;
        end
        
        % Convert current dimension into a code.
        if strcmp(currentDim, 'color')
            currentDimCode = 1;
        elseif strcmp(currentDim, 'shape')
            currentDimCode = 2;
        end
        
        if recordWithPlexon
            % Prepare data for being sent to Plexon.
            if strcmp(trialOutcome, 'correct')
                correctStatus = 1;
            else
                correctStatus = 0;
            end
            
            if strcmp(chosenPosition, 'left')
                selectedOption = 2;
            elseif strcmp(chosenPosition, 'right')
                selectedOption = 3;
            elseif strcmp(chosenPosition, 'top')
                selectedOption = 1;
            end
            
            leftOption = trialObject(currTrial).left;
            rightOption = trialObject(currTrial).right;
            topOption = trialObject(currTrial).top;
            
            if strcmp(topOption, 'circle;cyan')
                topOptionCode = 11;
            elseif strcmp(topOption, 'circle;magenta')
                topOptionCode = 12;
            elseif strcmp(topOption, 'circle;yellow')
                topOptionCode = 13;
            elseif strcmp(topOption, 'star;cyan')
                topOptionCode = 21;
            elseif strcmp(topOption, 'star;magenta')
                topOptionCode = 22;
            elseif strcmp(topOption, 'star;yellow')
                topOptionCode = 23;
            elseif strcmp(topOption, 'triangle;cyan')
                topOptionCode = 31;
            elseif strcmp(topOption, 'triangle;magenta')
                topOptionCode = 32;
            elseif strcmp(topOption, 'triangle;yellow')
                topOptionCode = 33;
            end

            if strcmp(leftOption, 'circle;cyan')
                leftOptionCode = 11;
            elseif strcmp(leftOption, 'circle;magenta')
                leftOptionCode = 12;
            elseif strcmp(leftOption, 'circle;yellow')
                leftOptionCode = 13;
            elseif strcmp(leftOption, 'star;cyan')
                leftOptionCode = 21;
            elseif strcmp(leftOption, 'star;magenta')
                leftOptionCode = 22;
            elseif strcmp(leftOption, 'star;yellow')
                leftOptionCode = 23;
            elseif strcmp(leftOption, 'triangle;cyan')
                leftOptionCode = 31;
            elseif strcmp(leftOption, 'triangle;magenta')
                leftOptionCode = 32;
            elseif strcmp(leftOption, 'triangle;yellow')
                leftOptionCode = 33;
            end

            if strcmp(rightOption, 'circle;cyan')
                rightOptionCode = 11;
            elseif strcmp(rightOption, 'circle;magenta')
                rightOptionCode = 12;
            elseif strcmp(rightOption, 'circle;yellow')
                rightOptionCode = 13;
            elseif strcmp(rightOption, 'star;cyan')
                rightOptionCode = 21;
            elseif strcmp(rightOption, 'star;magenta')
                rightOptionCode = 22;
            elseif strcmp(rightOption, 'star;yellow')
                rightOptionCode = 23;
            elseif strcmp(rightOption, 'triangle;cyan')
                rightOptionCode = 31;
            elseif strcmp(rightOption, 'triangle;magenta')
                rightOptionCode = 32;
            elseif strcmp(rightOption, 'triangle;yellow')
                rightOptionCode = 33;
            end
            
            if strcmp(stimOneFlashed, 'top')
                flashedFirst = 1;
            elseif strcmp(stimOneFlashed, 'left')
                flashedFirst = 2;
            elseif strcmp(stimOneFlashed, 'right')
                flashedFirst = 3;
            end
            
            if strcmp(stimTwoFlashed, 'top')
                flashedSecond = 1;
            elseif strcmp(stimTwoFlashed, 'left')
                flashedSecond = 2;
            elseif strcmp(stimTwoFlashed, 'right')
                flashedSecond = 3;
            end
            
            if strcmp(stimThreeFlashed, 'top')
                flashedThird = 1;
            elseif strcmp(stimThreeFlashed, 'left')
                flashedThird = 2;
            elseif strcmp(stimThreeFlashed, 'right')
                flashedThird = 3;
            end
            
            if strcmp(rewarded, 'yes')
                rewardedCode = 1;
            else
                rewardedCode = 0;
            end
            
            %{
            if timeToFix == intmax
                maxFixTime = 15000;
            else
                if timeToFix < 1
                    maxFixTime = timeToFix * 1000;
                else
                    maxFixTime = timeToFix;
                end
            end
            
            if minFixTime < 1
                fixTimeMin = minFixTime * 1000;
            else
                fixTimeMin = minFixTime;
            end
            
            if feedbackTime < 1
                feedbackDuration = feedbackTime * 1000;
            else
                feedbackDuration  = feedbackTime;
            end
            
            if ITI < 1
                intertrialInterval = ITI * 1000;
            else
                intertrialInterval = ITI;
            end
            
            if stimFlashTime < 1
                stimFlashTimeCode = stimFlashTime * 1000;
            else
                stimFlashTimeCode = stimFlashTime;
            end
            
            if interStimulusDelay < 1
                interStimulusDelayCode = interStimulusDelay * 1000;
            else
                interStimulusDelayCode = interStimulusDelay;
            end
            %}
            
            if strcmp(experimentType, 'intraSS')
                experimentTypeCode = 1;
            elseif strcmp(experimentType, 'extraSS')
                experimentTypeCode = 2;
            elseif strcmp(experimentType, 'reversal')
                experimentTypeCode = 3;
            end
            
            %{
            if strcmp(sessionType, 'unstaggered')
                sessionTypeCode = 1;
            elseif strcmp(sessionType, 'staggered')
                sessionTypeCode = 2;
            end
            %}
            
            % Send flag to Plexon to indicate trial data is going to be sent next.
            toplexon(6000);

            % Send trial data to Plexon.
            toplexon(currTrial);
            toplexon(currIntBlockTrial);
            toplexon(correctStatus);
            toplexon(selectedOption);
            toplexon(corrPosCode);
            toplexon(blockPercentCorr);
            toplexon(totalPercentCorr);
            toplexon(topOptionCode);
            toplexon(leftOptionCode);
            toplexon(rightOptionCode);
            toplexon(flashedFirst);
            toplexon(flashedSecond);
            toplexon(flashedThird);
            toplexon(rewardedCode);
            toplexon(experimentTypeCode);
            toplexon(currentDimCode);
            toplexon(numCorrectToShift);
            
            % Send flag to Plexon to indicate trial data sending has stopped.
            toplexon(7000);
        end
        
        % Save variables to a .mat file.
        data(currTrial).trial = currTrial;                   % The trial number for this trial.
        data(currTrial).currBlockTrial = currIntBlockTrial;  % Current trial number within a block.
        data(currTrial).trialOutcome = trialOutcome;         % Whether the choice was correct or not.
        data(currTrial).choiceMade = chosenPosition;         % Location on screen that was chosen.
        data(currTrial).corrAnsPos = corrPosCode;            % The position of the correct answer.
        data(currTrial).blockPercentCorr = blockPercentCorr; % Total percent correct for this block.
        data(currTrial).totalPercentCorr = totalPercentCorr; % Total percent correct for this experiment.
        data(currTrial).trialStimuli = trialObject(currTrial); % All stimuli and their positions.
        data(currTrial).firstFlashedStim = stimOneFlashed;   % The first staggered stimulus presented.
        data(currTrial).secondFlashedStim = stimTwoFlashed;  % The second staggered stimulus presented.
        data(currTrial).thirdFlashedStim = stimThreeFlashed; % The third staggered stimulus presented.
        data(currTrial).rewarded = rewarded;                 % Whether or not a reward was given.
        data(currTrial).timeToFixate = timeToFix;            % Max allowed for all fixations.
        data(currTrial).minFixTimeToStart = minFixTime;      % Fixatin time needed to start task.
        data(currTrial).holdFixTime = holdFixTime;           % Fixation duration to select an object.
        data(currTrial).feedbackTime = feedbackTime;         % Feedback duration.
        data(currTrial).ITI = ITI;                           % Intertrial interval.
        data(currTrial).stimFlashTime = stimFlashTime;       % Time stimulus is flashed during initial stimuli presentation.
        data(currTrial).interStimDelay = interStimulusDelay; % Time between stimulus flashes during initial stimuli presentation.
        data(currTrial).experimentType = experimentType;     % What version of the task this session was.
        data(currTrial).currentRuleType = currentDim;        % What the current rule is: color or shape.
        data(currTrial).sessionType = sessionType;           % Whether this was staggered or unstaggered.
        data(currTrial).correctToShift = numCorrectToShift;  % Number of correct trials before a shift.
        data(currTrial).numberOfShifts = shifts;             % Total number of shifts made.
        data(currTrial).trackedEye = trackedEye;             % The eye being tracked.
        
        eval(saveCommand);
    end
    
    % Sets up the Eyelink system.
    function setup_eyelink()
        abortSetup = false;
        setupMode = 2;
        
        % Connect Eyelink to computer if unconnected.
        if ~Eyelink('IsConnected')
            Eyelink('Initialize');
        end
        
        % Start recording eye position.
        Eyelink('StartRecording');
        
        % Preferences (not sure I want to keep).
        Eyelink('Command', 'randomize_calibration_order = NO');
        Eyelink('Command', 'force_manual_accept = YES');
        
        Eyelink('StartSetup');
        
        % Wait until Eyelink actually enters setup mode.
        while ~abortSetup && Eyelink('CurrentMode') ~= setupMode
            [keyIsDown, ~, keyCode] = KbCheck;
            
            if keyIsDown && keyCode(KbName('ESCAPE'))
                abortSetup = true;
                disp('Aborted while waiting for Eyelink!');
            end
        end
        
        % Put Eyelink in output mode.
        Eyelink('SendKeyButton', double('o'), 0, 10);
        
        % Start recording.
        Eyelink('SendKeyButton', double('o'), 0, 10);
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
    
    function staggered_stimuli()
        left = strsplit(trialObject(currTrial).left, ';');
        right = strsplit(trialObject(currTrial).right, ';');
        top = strsplit(trialObject(currTrial).top, ';');
        
        % Take the fixation dot off the screen.
        Screen('FillOval', window, colorBackground, [centerX - dotRadius + fixAdj; ...
                                                     centerY - dotRadius; ...
                                                     centerX + dotRadius - fixAdj; ...
                                                     centerY + dotRadius]);
        Screen('Flip', window);
        
        % Notify Plexon that the fixation dot disappeared.
        if recordWithPlexon
            toplexon(5002);
        end
        
        % Make sure stimuli are presented in same order if prev trial failed.
        if passedTrial
            randIndices = randperm(3);
            prevStimPresOrder = randIndices;
        else
            randIndices = prevStimPresOrder;
        end
        
        % Store the order stimuli were flashed.
        stimOneFlashed = char(positions(randIndices(1)));
        stimTwoFlashed = char(positions(randIndices(2)));
        stimThreeFlashed = char(positions(randIndices(3)));
        
        % Display stimuli in a random order.
        for index = 1:3
            % Get a random index to choose a random stimulus presentation position.
            randIndex = randIndices(index);
            
            if strcmp(char(positions(randIndex)), 'left')
                % Draw a CIRCLE in LEFT position if needed.
                if strcmp(left(1), 'circle')
                    if strcmp(left(2), 'cyan')
                        colorFill = colorCyan;
                    elseif strcmp(left(2), 'magenta')
                        colorFill = colorMagenta;
                    else
                        colorFill = colorYellow;
                    end
                    
                    % Display circle.
                    draw_circle('left', 'solid', colorFill, 'none');
                    Screen('Flip', window);
                    
                    % Notify Plexon that an option appeared.
                    if recordWithPlexon
                        if index == 1
                            toplexon(5003);
                        elseif index == 2
                            toplexon(5005);
                        elseif index == 3
                            toplexon(5007);
                        end
                    end
                    
                    % Flash choice on screen and send Plexon info if needed.
                    timeStart = GetSecs;
                    enteredSpot = 0;
                    while stimFlashTime > (GetSecs - timeStart)
                        [xCoord, yCoord] = get_eye_coords;
                        
                        % Determine if eye is within the left option boundary.
                        if xCoord >= leftBoundXMin && xCoord <= leftBoundXMax && ...
                           yCoord >= leftBoundYMin && yCoord <= leftBoundYMax
                            if enteredSpot == 0
                                if recordWithPlexon
                                    if index == 1
                                        toplexon(5061);
                                    elseif index == 2
                                        toplexon(5063);
                                    elseif index == 3
                                        toplexon(5065);
                                    end
                                    
                                    enteredSpot = 1;
                                end
                            end
                        elseif enteredSpot
                            enteredSpot = 0;
                            
                            if recordWithPlexon
                                if index == 1
                                    toplexon(5062);
                                elseif index == 2
                                    toplexon(5064);
                                elseif index == 3
                                    toplexon(5066);
                                end
                            end
                        end
                    end
                    
                    % Hide circle.
                    draw_circle('left', 'solid', colorBackground, 'none');
                    Screen('Flip', window);
                    
                    % Notify Plexon that an option disappeared.
                    if recordWithPlexon
                        if index == 1
                            toplexon(5004);
                        elseif index == 2
                            toplexon(5006);
                        elseif index == 3
                            toplexon(5008);
                        end
                    end
                end
                
                % Draw a STAR in LEFT position if needed.
                if strcmp(left(1), 'star')
                    if strcmp(left(2), 'cyan')
                        colorFill = colorCyan;
                    elseif strcmp(left(2), 'magenta')
                        colorFill = colorMagenta;
                    else
                        colorFill = colorYellow;
                    end
                    
                    % Display star.
                    draw_star('left', 'solid', colorFill, 'none');
                    Screen('Flip', window);
                    
                    % Notify Plexon that an option appeared.
                    if recordWithPlexon
                        if index == 1
                            toplexon(5003);
                        elseif index == 2
                            toplexon(5005);
                        elseif index == 3
                            toplexon(5007);
                        end
                    end
                    
                    % Flash choice on screen and send Plexon info if needed.
                    timeStart = GetSecs;
                    enteredSpot = 0;
                    while stimFlashTime > (GetSecs - timeStart)
                        [xCoord, yCoord] = get_eye_coords;
                        
                        % Determine if eye is within the left option boundary.
                        if xCoord >= leftBoundXMin && xCoord <= leftBoundXMax && ...
                           yCoord >= leftBoundYMin && yCoord <= leftBoundYMax
                            if enteredSpot == 0
                                if recordWithPlexon
                                    if index == 1
                                        toplexon(5061);
                                    elseif index == 2
                                        toplexon(5063);
                                    elseif index == 3
                                        toplexon(5065);
                                    end
                                    
                                    enteredSpot = 1;
                                end
                            end
                        elseif enteredSpot
                            enteredSpot = 0;
                            
                            if recordWithPlexon
                                if index == 1
                                    toplexon(5062);
                                elseif index == 2
                                    toplexon(5064);
                                elseif index == 3
                                    toplexon(5066);
                                end
                            end
                        end
                    end
                    
                    % Hide star.
                    draw_star('left', 'solid', colorBackground, 'none');
                    Screen('Flip', window);
                    
                    % Notify Plexon that an option disappeared.
                    if recordWithPlexon
                        if index == 1
                            toplexon(5004);
                        elseif index == 2
                            toplexon(5006);
                        elseif index == 3
                            toplexon(5008);
                        end
                    end
                end
                
                % Draw a TRIANGLE in LEFT position if needed.
                if strcmp(left(1), 'triangle')
                    if strcmp(left(2), 'cyan')
                        colorFill = colorCyan;
                    elseif strcmp(left(2), 'magenta')
                        colorFill = colorMagenta;
                    else
                        colorFill = colorYellow;
                    end
                    
                    % Display triangle.
                    draw_triangle('left', 'solid', colorFill, 'none');
                    Screen('Flip', window);
                    
                    % Notify Plexon that an option appeared.
                    if recordWithPlexon
                        if index == 1
                            toplexon(5003);
                        elseif index == 2
                            toplexon(5005);
                        elseif index == 3
                            toplexon(5007);
                        end
                    end

                    % Flash choice on screen and send Plexon info if needed.
                    timeStart = GetSecs;
                    enteredSpot = 0;
                    while stimFlashTime > (GetSecs - timeStart)
                        [xCoord, yCoord] = get_eye_coords;
                        
                        % Determine if eye is within the left option boundary.
                        if xCoord >= leftBoundXMin && xCoord <= leftBoundXMax && ...
                           yCoord >= leftBoundYMin && yCoord <= leftBoundYMax
                            if enteredSpot == 0
                                if recordWithPlexon
                                    if index == 1
                                        toplexon(5061);
                                    elseif index == 2
                                        toplexon(5063);
                                    elseif index == 3
                                        toplexon(5065);
                                    end
                                    
                                    enteredSpot = 1;
                                end
                            end
                        elseif enteredSpot
                            enteredSpot = 0;
                            
                            if recordWithPlexon
                                if index == 1
                                    toplexon(5062);
                                elseif index == 2
                                    toplexon(5064);
                                elseif index == 3
                                    toplexon(5066);
                                end
                            end
                        end
                    end
                    
                    % Hide triangle.
                    draw_triangle('left', 'solid', colorBackground, 'none');
                    Screen('Flip', window);
                    
                    % Notify Plexon that an option disappeared.
                    if recordWithPlexon
                        if index == 1
                            toplexon(5004);
                        elseif index == 2
                            toplexon(5006);
                        elseif index == 3
                            toplexon(5008);
                        end
                    end
                end
            elseif strcmp(char(positions(randIndex)), 'right')
                % Draw a CIRCLE in RIGHT position if needed.
                if strcmp(right(1), 'circle')
                    if strcmp(right(2), 'cyan')
                        colorFill = colorCyan;
                    elseif strcmp(right(2), 'magenta')
                        colorFill = colorMagenta;
                    else
                        colorFill = colorYellow;
                    end
                    
                    % Display circle.
                    draw_circle('right', 'solid', colorFill, 'none');
                    Screen('Flip', window);
                    
                    % Notify Plexon that an option appeared.
                    if recordWithPlexon
                        if index == 1
                            toplexon(5003);
                        elseif index == 2
                            toplexon(5005);
                        elseif index == 3
                            toplexon(5007);
                        end
                    end
                    
                    % Flash choice on screen and send Plexon info if needed.
                    timeStart = GetSecs;
                    enteredSpot = 0;
                    while stimFlashTime > (GetSecs - timeStart)
                        [xCoord, yCoord] = get_eye_coords;
                        
                        % Determine if eye is within the left option boundary.
                        if xCoord >= rightBoundXMin && xCoord <= rightBoundXMax && ...
                           yCoord >= rightBoundYMin && yCoord <= rightBoundYMax
                            if enteredSpot == 0
                                if recordWithPlexon
                                    if index == 1
                                        toplexon(5061);
                                    elseif index == 2
                                        toplexon(5063);
                                    elseif index == 3
                                        toplexon(5065);
                                    end
                                    
                                    enteredSpot = 1;
                                end
                            end
                        elseif enteredSpot
                            enteredSpot = 0;
                            
                            if recordWithPlexon
                                if index == 1
                                    toplexon(5062);
                                elseif index == 2
                                    toplexon(5064);
                                elseif index == 3
                                    toplexon(5066);
                                end
                            end
                        end
                    end
                    
                    % Hide circle.
                    draw_circle('right', 'solid', colorBackground, 'none');
                    Screen('Flip', window);
                    
                    % Notify Plexon that an option disappeared.
                    if recordWithPlexon
                        if index == 1
                            toplexon(5004);
                        elseif index == 2
                            toplexon(5006);
                        elseif index == 3
                            toplexon(5008);
                        end
                    end
                end
                
                % Draw a STAR in RIGHT position if needed.
                if strcmp(right(1), 'star')
                    if strcmp(right(2), 'cyan')
                        colorFill = colorCyan;
                    elseif strcmp(right(2), 'magenta')
                        colorFill = colorMagenta;
                    else
                        colorFill = colorYellow;
                    end
                    
                    % Display star.
                    draw_star('right', 'solid', colorFill, 'none');
                    Screen('Flip', window);
                    
                    % Notify Plexon that an option appeared.
                    if recordWithPlexon
                        if index == 1
                            toplexon(5003);
                        elseif index == 2
                            toplexon(5005);
                        elseif index == 3
                            toplexon(5007);
                        end
                    end

                    % Flash choice on screen and send Plexon info if needed.
                    timeStart = GetSecs;
                    enteredSpot = 0;
                    while stimFlashTime > (GetSecs - timeStart)
                        [xCoord, yCoord] = get_eye_coords;
                        
                        % Determine if eye is within the left option boundary.
                        if xCoord >= rightBoundXMin && xCoord <= rightBoundXMax && ...
                           yCoord >= rightBoundYMin && yCoord <= rightBoundYMax
                            if enteredSpot == 0
                                if recordWithPlexon
                                    if index == 1
                                        toplexon(5061);
                                    elseif index == 2
                                        toplexon(5063);
                                    elseif index == 3
                                        toplexon(5065);
                                    end
                                    
                                    enteredSpot = 1;
                                end
                            end
                        elseif enteredSpot
                            enteredSpot = 0;
                            
                            if recordWithPlexon
                                if index == 1
                                    toplexon(5062);
                                elseif index == 2
                                    toplexon(5064);
                                elseif index == 3
                                    toplexon(5066);
                                end
                            end
                        end
                    end
                    
                    % Hide star.
                    draw_star('right', 'solid', colorBackground, 'none');
                    Screen('Flip', window);
                    
                    % Notify Plexon that an option disappeared.
                    if recordWithPlexon
                        if index == 1
                            toplexon(5004);
                        elseif index == 2
                            toplexon(5006);
                        elseif index == 3
                            toplexon(5008);
                        end
                    end
                end
                
                % Draw a TRIANGLE in RIGHT position if needed.
                if strcmp(right(1), 'triangle')
                    if strcmp(right(2), 'cyan')
                        colorFill = colorCyan;
                    elseif strcmp(right(2), 'magenta')
                        colorFill = colorMagenta;
                    else
                        colorFill = colorYellow;
                    end
                    
                    % Display triangle.
                    draw_triangle('right', 'solid', colorFill, 'none');
                    Screen('Flip', window);
                    
                    % Notify Plexon that an option appeared.
                    if recordWithPlexon
                        if index == 1
                            toplexon(5003);
                        elseif index == 2
                            toplexon(5005);
                        elseif index == 3
                            toplexon(5007);
                        end
                    end
                    
                    % Flash choice on screen and send Plexon info if needed.
                    timeStart = GetSecs;
                    enteredSpot = 0;
                    while stimFlashTime > (GetSecs - timeStart)
                        [xCoord, yCoord] = get_eye_coords;
                        
                        % Determine if eye is within the left option boundary.
                        if xCoord >= rightBoundXMin && xCoord <= rightBoundXMax && ...
                           yCoord >= rightBoundYMin && yCoord <= rightBoundYMax
                            if enteredSpot == 0
                                if recordWithPlexon
                                    if index == 1
                                        toplexon(5061);
                                    elseif index == 2
                                        toplexon(5063);
                                    elseif index == 3
                                        toplexon(5065);
                                    end
                                    
                                    enteredSpot = 1;
                                end
                            end
                        elseif enteredSpot
                            enteredSpot = 0;
                            
                            if recordWithPlexon
                                if index == 1
                                    toplexon(5062);
                                elseif index == 2
                                    toplexon(5064);
                                elseif index == 3
                                    toplexon(5066);
                                end
                            end
                        end
                    end
                    
                    % Hide triangle.
                    draw_triangle('right', 'solid', colorBackground, 'none');
                    Screen('Flip', window);
                    
                    % Notify Plexon that an option disappeared.
                    if recordWithPlexon
                        if index == 1
                            toplexon(5004);
                        elseif index == 2
                            toplexon(5006);
                        elseif index == 3
                            toplexon(5008);
                        end
                    end
                end
            elseif strcmp(char(positions(randIndex)), 'top')
                % Draw a CIRCLE in TOP position if needed.
                if strcmp(top(1), 'circle')
                    if strcmp(top(2), 'cyan')
                        colorFill = colorCyan;
                    elseif strcmp(top(2), 'magenta')
                        colorFill = colorMagenta;
                    else
                        colorFill = colorYellow;
                    end
                    
                    % Display circle.
                    draw_circle('top', 'solid', colorFill, 'none');
                    Screen('Flip', window);
                    
                    % Notify Plexon that an option appeared.
                    if recordWithPlexon
                        if index == 1
                            toplexon(5003);
                        elseif index == 2
                            toplexon(5005);
                        elseif index == 3
                            toplexon(5007);
                        end
                    end
                    
                    % Flash choice on screen and send Plexon info if needed.
                    timeStart = GetSecs;
                    enteredSpot = 0;
                    while stimFlashTime > (GetSecs - timeStart)
                        [xCoord, yCoord] = get_eye_coords;
                        
                        % Determine if eye is within the left option boundary.
                        if xCoord >= topBoundXMin && xCoord <= topBoundXMax && ...
                           yCoord >= topBoundYMin && yCoord <= topBoundYMax
                            if enteredSpot == 0
                                if recordWithPlexon
                                    if index == 1
                                        toplexon(5061);
                                    elseif index == 2
                                        toplexon(5063);
                                    elseif index == 3
                                        toplexon(5065);
                                    end
                                    
                                    enteredSpot = 1;
                                end
                            end
                        elseif enteredSpot
                            enteredSpot = 0;
                            
                            if recordWithPlexon
                                if index == 1
                                    toplexon(5062);
                                elseif index == 2
                                    toplexon(5064);
                                elseif index == 3
                                    toplexon(5066);
                                end
                            end
                        end
                    end
                    
                    % Hide circle.
                    draw_circle('top', 'solid', colorBackground, 'none');
                    Screen('Flip', window);
                    
                    % Notify Plexon that an option disappeared.
                    if recordWithPlexon
                        if index == 1
                            toplexon(5004);
                        elseif index == 2
                            toplexon(5006);
                        elseif index == 3
                            toplexon(5008);
                        end
                    end
                end
                
                % Draw a STAR in TOP position if needed.
                if strcmp(top(1), 'star')
                    if strcmp(top(2), 'cyan')
                        colorFill = colorCyan;
                    elseif strcmp(top(2), 'magenta')
                        colorFill = colorMagenta;
                    else
                        colorFill = colorYellow;
                    end
                    
                    % Display star.
                    draw_star('top', 'solid', colorFill, 'none');
                    Screen('Flip', window);
                    
                    % Notify Plexon that an option appeared.
                    if recordWithPlexon
                        if index == 1
                            toplexon(5003);
                        elseif index == 2
                            toplexon(5005);
                        elseif index == 3
                            toplexon(5007);
                        end
                    end
                    
                    % Flash choice on screen and send Plexon info if needed.
                    timeStart = GetSecs;
                    enteredSpot = 0;
                    while stimFlashTime > (GetSecs - timeStart)
                        [xCoord, yCoord] = get_eye_coords;
                        
                        % Determine if eye is within the left option boundary.
                        if xCoord >= topBoundXMin && xCoord <= topBoundXMax && ...
                           yCoord >= topBoundYMin && yCoord <= topBoundYMax
                            if enteredSpot == 0
                                if recordWithPlexon
                                    if index == 1
                                        toplexon(5061);
                                    elseif index == 2
                                        toplexon(5063);
                                    elseif index == 3
                                        toplexon(5065);
                                    end
                                    
                                    enteredSpot = 1;
                                end
                            end
                        elseif enteredSpot
                            enteredSpot = 0;
                            
                            if recordWithPlexon
                                if index == 1
                                    toplexon(5062);
                                elseif index == 2
                                    toplexon(5064);
                                elseif index == 3
                                    toplexon(5066);
                                end
                            end
                        end
                    end
                    
                    % Hide star.
                    draw_star('top', 'solid', colorBackground, 'none');
                    Screen('Flip', window);
                    
                    % Notify Plexon that an option disappeared.
                    if recordWithPlexon
                        if index == 1
                            toplexon(5004);
                        elseif index == 2
                            toplexon(5006);
                        elseif index == 3
                            toplexon(5008);
                        end
                    end
                end
                
                % Draw a TRIANGLE in TOP position if needed.
                if strcmp(top(1), 'triangle')
                    if strcmp(top(2), 'cyan')
                        colorFill = colorCyan;
                    elseif strcmp(top(2), 'magenta')
                        colorFill = colorMagenta;
                    else
                        colorFill = colorYellow;
                    end
                    
                    % Display triangle.
                    draw_triangle('top', 'solid', colorFill, 'none');
                    Screen('Flip', window);
                    
                    % Notify Plexon that an option appeared.
                    if recordWithPlexon
                        if index == 1
                            toplexon(5003);
                        elseif index == 2
                            toplexon(5005);
                        elseif index == 3
                            toplexon(5007);
                        end
                    end

                    % Flash choice on screen and send Plexon info if needed.
                    timeStart = GetSecs;
                    enteredSpot = 0;
                    while stimFlashTime > (GetSecs - timeStart)
                        [xCoord, yCoord] = get_eye_coords;
                        
                        % Determine if eye is within the left option boundary.
                        if xCoord >= topBoundXMin && xCoord <= topBoundXMax && ...
                           yCoord >= topBoundYMin && yCoord <= topBoundYMax
                            if enteredSpot == 0
                                if recordWithPlexon
                                    if index == 1
                                        toplexon(5061);
                                    elseif index == 2
                                        toplexon(5063);
                                    elseif index == 3
                                        toplexon(5065);
                                    end
                                    
                                    enteredSpot = 1;
                                end
                            end
                        elseif enteredSpot
                            enteredSpot = 0;
                            
                            if recordWithPlexon
                                if index == 1
                                    toplexon(5062);
                                elseif index == 2
                                    toplexon(5064);
                                elseif index == 3
                                    toplexon(5066);
                                end
                            end
                        end
                    end
                    
                    % Hide triangle.
                    draw_triangle('top', 'solid', colorBackground, 'none');
                    Screen('Flip', window);
                    
                    % Notify Plexon that an option disappeared.
                    if recordWithPlexon
                        if index == 1
                            toplexon(5004);
                        elseif index == 2
                            toplexon(5006);
                        elseif index == 3
                            toplexon(5008);
                        end
                    end
                end
            end
            
            % Delay between stimulus presentations.
            WaitSecs(interStimulusDelay);
        end
    end
    
    function points = star_points(centerColVector, armLength)
        innerPoints   = zeros(2, 5);        % Preallocate space for inner points.
        outerPoints   = zeros(2, 5);        % Preallocate space for outer points.
        rotationAngle = 0;                  % Rotation angle in degrees.
        rotationInner = 108;                % First rotation angle (deg) for inner points.
        rotationOuter = 72;                 % Rotation angle (deg) between points.
        starPoints    = zeros(11, 2);       % Preallocate space for all star points.
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
    end

    function unstaggered_stimuli(lookingStatus)
        input = strsplit(lookingStatus, ';');
        status = input(1);
        spot = input(2);
        
        left = strsplit(trialObject(currTrial).left, ';');
        right = strsplit(trialObject(currTrial).right, ';');
        top = strsplit(trialObject(currTrial).top, ';');
        
        if inHoldingState
            Screen('FillOval', window, colorYellow, [centerX - dotRadius + fixAdj; ...
                                                     centerY - dotRadius; ...
                                                     centerX + dotRadius - fixAdj; ...
                                                     centerY + dotRadius]);
        else
            Screen('FillOval', window, colorBackground, [centerX - dotRadius + fixAdj; ...
                                                         centerY - dotRadius; ...
                                                         centerX + dotRadius - fixAdj; ...
                                                         centerY + dotRadius]);
        end
        
        % Draw a CIRCLE in LEFT position if needed.
        if strcmp(left(1), 'circle')
            if strcmp(left(2), 'cyan')
                colorFill = colorCyan;
            elseif strcmp(left(2), 'magenta')
                colorFill = colorMagenta;
            else
                colorFill = colorYellow;
            end
            
            % Draw shape with feedback outline if needed.
            if strcmp(status, 'looking') && strcmp(spot, 'left')
                draw_circle('left', 'outline', colorFill, colorWhite);
            elseif strcmp(status, 'correct') && strcmp(spot, 'left')
                draw_circle('left', 'outline', colorFill, colorGreen);
            elseif strcmp(status, 'incorrect') && strcmp(spot, 'left')
                draw_circle('left', 'outline', colorFill, colorRed);
            else
                draw_circle('left', 'solid', colorFill, 'none');
            end
        end
        
        % Draw a CIRCLE in RIGHT position if needed.
        if strcmp(right(1), 'circle')
            if strcmp(right(2), 'cyan')
                colorFill = colorCyan;
            elseif strcmp(right(2), 'magenta')
                colorFill = colorMagenta;
            else
                colorFill = colorYellow;
            end
            
            % Draw shape with feedback outline if needed.
            if strcmp(status, 'looking') && strcmp(spot, 'right')
                draw_circle('right', 'outline', colorFill, colorWhite);
            elseif strcmp(status, 'correct') && strcmp(spot, 'right')
                draw_circle('right', 'outline', colorFill, colorGreen);
            elseif strcmp(status, 'incorrect') && strcmp(spot, 'right')
                draw_circle('right', 'outline', colorFill, colorRed);
            else
                draw_circle('right', 'solid', colorFill, 'none');
            end
        end
        
        % Draw a CIRCLE in TOP position if needed.
        if strcmp(top(1), 'circle')
            if strcmp(top(2), 'cyan')
                colorFill = colorCyan;
            elseif strcmp(top(2), 'magenta')
                colorFill = colorMagenta;
            else
                colorFill = colorYellow;
            end
            
            % Draw shape with feedback outline if needed.
            if strcmp(status, 'looking') && strcmp(spot, 'top')
                draw_circle('top', 'outline', colorFill, colorWhite);
            elseif strcmp(status, 'correct') && strcmp(spot, 'top')
                draw_circle('top', 'outline', colorFill, colorGreen);
            elseif strcmp(status, 'incorrect') && strcmp(spot, 'top')
                draw_circle('top', 'outline', colorFill, colorRed);
            else
                draw_circle('top', 'solid', colorFill, 'none');
            end
        end
        
        % Draw a STAR in LEFT position if needed.
        if strcmp(left(1), 'star')
            if strcmp(left(2), 'cyan')
                colorFill = colorCyan;
            elseif strcmp(left(2), 'magenta')
                colorFill = colorMagenta;
            else
                colorFill = colorYellow;
            end
            
            % Draw shape with feedback outline if needed.
            if strcmp(status, 'looking') && strcmp(spot, 'left')
                draw_star('left', 'outline', colorFill, colorWhite);
            elseif strcmp(status, 'correct') && strcmp(spot, 'left')
                draw_star('left', 'outline', colorFill, colorGreen);
            elseif strcmp(status, 'incorrect') && strcmp(spot, 'left')
                draw_star('left', 'outline', colorFill, colorRed);
            else
                draw_star('left', 'solid', colorFill, 'none');
            end
        end
        
        % Draw a STAR in RIGHT position if needed.
        if strcmp(right(1), 'star')
            if strcmp(right(2), 'cyan')
                colorFill = colorCyan;
            elseif strcmp(right(2), 'magenta')
                colorFill = colorMagenta;
            else
                colorFill = colorYellow;
            end
            
            % Draw shape with feedback outline if needed.
            if strcmp(status, 'looking') && strcmp(spot, 'right')
                draw_star('right', 'outline', colorFill, colorWhite);
            elseif strcmp(status, 'correct') && strcmp(spot, 'right')
                draw_star('right', 'outline', colorFill, colorGreen);
            elseif strcmp(status, 'incorrect') && strcmp(spot, 'right')
                draw_star('right', 'outline', colorFill, colorRed);
            else
                draw_star('right', 'solid', colorFill, 'none')
            end
        end
        
        % Draw a STAR in TOP position if needed.
        if strcmp(top(1), 'star')
            if strcmp(top(2), 'cyan')
                colorFill = colorCyan;
            elseif strcmp(top(2), 'magenta')
                colorFill = colorMagenta;
            else
                colorFill = colorYellow;
            end
            
            % Draw shape with feedback outline if needed.
            if strcmp(status, 'looking') && strcmp(spot, 'top')
                draw_star('top', 'outline', colorFill, colorWhite);
            elseif strcmp(status, 'correct') && strcmp(spot, 'top')
                draw_star('top', 'outline', colorFill, colorGreen);
            elseif strcmp(status, 'incorrect') && strcmp(spot, 'top')
                draw_star('top', 'outline', colorFill, colorRed);
            else
                draw_star('top', 'solid', colorFill, 'none');
            end
        end
        
        % Draw a TRIANGLE in LEFT position if needed.
        if strcmp(left(1), 'triangle')
            if strcmp(left(2), 'cyan')
                colorFill = colorCyan;
            elseif strcmp(left(2), 'magenta')
                colorFill = colorMagenta;
            else
                colorFill = colorYellow;
            end
            
            % Draw shape with feedback outline if needed.
            if strcmp(status, 'looking') && strcmp(spot, 'left')
                draw_triangle('left', 'outline', colorFill, colorWhite);
            elseif strcmp(status, 'correct') && strcmp(spot, 'left')
                draw_triangle('left', 'outline', colorFill, colorGreen);
            elseif strcmp(status, 'incorrect') && strcmp(spot, 'left')
                draw_triangle('left', 'outline', colorFill, colorRed);
            else
                draw_triangle('left', 'solid', colorFill, 'none');
            end
        end
        
        % Draw a TRIANGLE in RIGHT position if needed.
        if strcmp(right(1), 'triangle')
            if strcmp(right(2), 'cyan')
                colorFill = colorCyan;
            elseif strcmp(right(2), 'magenta')
                colorFill = colorMagenta;
            else
                colorFill = colorYellow;
            end
            
            % Draw shape with feedback outline if needed.
            if strcmp(status, 'looking') && strcmp(spot, 'right')
                draw_triangle('right', 'outline', colorFill, colorWhite);
            elseif strcmp(status, 'correct') && strcmp(spot, 'right')
                draw_triangle('right', 'outline', colorFill, colorGreen);
            elseif strcmp(status, 'incorrect') && strcmp(spot, 'right')
                draw_triangle('right', 'outline', colorFill, colorRed);
            else
                draw_triangle('right', 'solid', colorFill, 'none');
            end
        end
        
        % Draw a TRIANGLE in TOP position if needed.
        if strcmp(top(1), 'triangle')
            if strcmp(top(2), 'cyan')
                colorFill = colorCyan;
            elseif strcmp(top(2), 'magenta')
                colorFill = colorMagenta;
            else
                colorFill = colorYellow;
            end
            
            % Draw shape with feedback outline if needed.
            if strcmp(status, 'looking') && strcmp(spot, 'top')
                draw_triangle('top', 'outline', colorFill, colorWhite);
            elseif strcmp(status, 'correct') && strcmp(spot, 'top')
                draw_triangle('top', 'outline', colorFill, colorGreen);
            elseif strcmp(status, 'incorrect') && strcmp(spot, 'top')
                draw_triangle('top', 'outline', colorFill, colorRed);
            else
                draw_triangle('top', 'solid', colorFill, 'none');
            end
        end
        
        Screen('Flip', window);
    end
end

function terms = strsplit(s, delimiter)
%STRSPLIT Splits a string into multiple terms
%
%   terms = strsplit(s)
%       splits the string s into multiple terms that are separated by
%       white spaces (white spaces also include tab and newline).
%
%       The extracted terms are returned in form of a cell array of
%       strings.
%
%   terms = strsplit(s, delimiter)
%       splits the string s into multiple terms that are separated by
%       the specified delimiter. 
%   
%   Remarks
%   -------
%       - Note that the spaces surrounding the delimiter are considered
%         part of the delimiter, and thus removed from the extracted
%         terms.
%
%       - If there are two consecutive non-whitespace delimiters, it is
%         regarded that there is an empty-string term between them.         
%
%   Examples
%   --------
%       % extract the words delimited by white spaces
%       ts = strsplit('I am using MATLAB');
%       ts <- {'I', 'am', 'using', 'MATLAB'}
%
%       % split operands delimited by '+'
%       ts = strsplit('1+2+3+4', '+');
%       ts <- {'1', '2', '3', '4'}
%
%       % It still works if there are spaces surrounding the delimiter
%       ts = strsplit('1 + 2 + 3 + 4', '+');
%       ts <- {'1', '2', '3', '4'}
%
%       % Consecutive delimiters results in empty terms
%       ts = strsplit('C,Java, C++ ,, Python, MATLAB', ',');
%       ts <- {'C', 'Java', 'C++', '', 'Python', 'MATLAB'}
%
%       % When no delimiter is presented, the entire string is considered
%       % as a single term
%       ts = strsplit('YouAndMe');
%       ts <- {'YouAndMe'}
%

%   History
%   -------
%       - Created by Dahua Lin, on Oct 9, 2008
%
    %% parse and verify input arguments

    assert(ischar(s) && ndims(s) == 2 && size(s,1) <= 1, ...
        'strsplit:invalidarg', ...
        'The first input argument should be a char string.');

    if nargin < 2
        by_space = true;
    else
        d = delimiter;
        assert(ischar(d) && ndims(d) == 2 && size(d,1) == 1 && ~isempty(d), ...
            'strsplit:invalidarg', ...
            'The delimiter should be a non-empty char string.');

        d = strtrim(d);
        by_space = isempty(d);
    end

    %% main

    s = strtrim(s);

    if by_space
        w = isspace(s);            
        if any(w)
            % decide the positions of terms        
            dw = diff(w);
            sp = [1, find(dw == -1) + 1];     % start positions of terms
            ep = [find(dw == 1), length(s)];  % end positions of terms

            % extract the terms        
            nt = numel(sp);
            terms = cell(1, nt);
            for i = 1 : nt
                terms{i} = s(sp(i):ep(i));
            end                
        else
            terms = {s};
        end

    else    
        p = strfind(s, d);
        if ~isempty(p)        
            % extract the terms        
            nt = numel(p) + 1;
            terms = cell(1, nt);
            sp = 1;
            dl = length(delimiter);
            for i = 1 : nt-1
                terms{i} = strtrim(s(sp:p(i)-1));
                sp = p(i) + dl;
            end         
            terms{nt} = strtrim(s(sp:end));
        else
            terms = {s};
        end        
    end
end

function toplexon(num)          % CES 2/22/12
if(num<15625)                   % Sends any number 0-15624 (inclusive) to Plexon with a timestamp
    daq=DaqDeviceIndex;         % To access data:
    DaqDConfigPort(daq(1),0,0);
    DaqDOut(daq,0,(2^5));       % 1) Have PlexControl send EVT01-EVT06 to Matlab
    pause(0.000001);          	% 2) Save Matlab Workspace as .mat
    DaqDOut(daq,0,0);           % 3) 'load' .mat
    pause(0.000001);            % 4) Run 'getstrobes()' on EVT01-EVT06
    base5 = str2num(dec2base(num, 5));
    evt(1) = floor(base5/100000);
    evt(2) = floor((base5-(evt(1)*100000))/10000);
    evt(3) = floor((base5-((evt(1)*100000)+(evt(2)*10000)))/1000);
    evt(4) = floor((base5-((evt(1)*100000)+(evt(2)*10000)+(evt(3)*1000)))/100);
    evt(5) = floor((base5-((evt(1)*100000)+(evt(2)*10000)+(evt(3)*1000)+(evt(4)*100)))/10);
    evt(6) = base5-((evt(1)*100000)+(evt(2)*10000)+(evt(3)*1000)+(evt(4)*100)+(evt(5)*10));
    for i=1:6
        if(evt(i)==0), DaqDOut(daq,0,(2^0));end
        if(evt(i)==1), DaqDOut(daq,0,(2^1));end
        if(evt(i)==2), DaqDOut(daq,0,(2^2));end
        if(evt(i)==3), DaqDOut(daq,0,(2^3));end
        if(evt(i)==4), DaqDOut(daq,0,(2^4));end
        pause(0.000001);
        DaqDOut(daq,0,0);
        pause(0.000001);
    end
else
    disp('toplexon needs a smaller #!');
end
end