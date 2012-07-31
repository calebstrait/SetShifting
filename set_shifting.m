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
    
      numCorrectToShift = 10;             % Num correct trials before shift.
      rewardDuration    = 1.2;            % How long the juicer is open.
      trackedEye        = 1;              % Tracked eye (left: 1, right: 2).
      sessionType       = 'behavior';     % Values: 'behavior' or 'recording'.
      experimentType    = 'colorShift';   % Value: 'colorShift'.
    
    % @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ %
    % @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ %
    % @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ %
    % @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ %
    % @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ %
    % @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ %
    % @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ %
    
    % Colors.
    colorBackground = [0 0 0];
    colorFixDot     = [255 255 0];
    colorBlue       = [5 61 245];  
    colorCyan       = [0 253 254];
    colorGreen      = [0 248 79];
    colorRed        = [255 30 24];
    colorWhite      = [255 255 255];
    
    % Basic coordinates.
    centerX         = 512;            % X pixel coordinate for the screen center.
    centerY         = 384;            % Y pixel coordinate for the screen center.
    hfWidth         = 88;             % Half the width of the fixation boxes.
    
    % Values to calculate fixation boxes.
    fixBoundXMax    = centerX + hfWidth;
    fixBoundXMin    = centerX - hfWidth;
    fixBoundYMax    = centerY + hfWidth;
    fixBoundYMin    = centerY - hfWidth;
    
    leftBoundXMax   = centerX - 152;
    leftBoundXMin   = centerX - 328;
    leftBoundYMax   = centerY + 220;
    leftBoundYMin   = centerY + 44;
    
    rightBoundXMax  = centerX + 328;
    rightBoundXMin  = centerX + 152;
    rightBoundYMax  = centerY + 220;
    rightBoundYMin  = centerY + 44;
    
    topBoundXMax    = centerX + hfWidth;
    topBoundXMin    = centerX - hfWidth;
    topBoundYMax    = centerY - 152;
    topBoundYMin    = centerY - 328;
    
    % Other Coordinate variables.
    centerShift         = 240;  % Dist. from fix. dot to center of other fix. squares.
    circleAdj           = 22;
    circleBorderHeight  = 11;
    circleBorderWidth   = 11;
    dotRadius           = 10;
    fixAdj              = 1;
    starBorderWidth     = 30;
    starHfWidth         = hfWidth + 10;
    starShift           = centerShift - 6;
    triAdj              = 30;
    
    % References.
    monkeyScreen    = 1;        % Number of the screen the monkey sees.
    
    % Saving.
    data            = struct([]);          % Workspace variable where trial data is saved.
    saveCommand     = NaN;                 % Command string that will save .mat files.         
    setShiftingData = '/Data/SetShifting'; % Directory where .mat files are saved.
    varName         = 'data';              % Name of the var to save in the workspace.
    
    % Times.
    feedbackTime    = 0.4;     % Duration of the error state.
    holdFixTime     = 0.5;     % Duration to hold fixation before choosing.
    ITI             = 0.8;     % Intertrial interval.
    minFixTime      = 0.1;     % Min time monkey must fixate to start trial.
    timeToFix       = intmax;  % Amount of time monkey is given to fixate.
    
    % Trial.
    colors          = [{'blue'}, {'green'}, {'red'}];
    corrAnsObject   = struct([]);
    currentAnswer   = '';
    currTrial       = 0;
    dimension       = [{'color'}, {'shape'}];
    numCorrTrials   = 0;
    shapes          = [{'circle'}, {'star'}, {'triangle'}];
    trialCount      = 0;
    trialObject     = struct([]);
    
    % Trial data.
    chosenPosition  = '';
    rewarded        = '';
    shifts          = 0;
    trialOutcome    = '';
    
    % Color shift trial info.
    chosenShape     = '';
    colorOne        = '';
    colorTwo        = '';
    genColorShift   = 0;
    setUnits        = 0;  % Number of times a set shift unit has occurred.
    
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
        trialCount = trialCount + 1;
        print_stats();
        WaitSecs(ITI);
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
                    unstaggered_stimuli('looking;left');
                    % Determine if eye maintained fixation for given duration.
                    checkFixBreak = fix_break_check(leftBoundXMin, leftBoundXMax, ...
                                                    leftBoundYMin, leftBoundYMax, ...
                                                    duration);
                    
                    if checkFixBreak == false
                        % Fixation was obtained for desired duration.
                        fixation = true;
                        area = 'left';
                        
                        return;
                    else
                        unstaggered_stimuli('none;none');
                    end
                % Determine if eye is within the right option boundary.
                elseif xCoord >= rightBoundXMin && xCoord <= rightBoundXMax && ...
                       yCoord >= rightBoundYMin && yCoord <= rightBoundYMax
                    unstaggered_stimuli('looking;right');
                    % Determine if eye maintained fixation for given duration.
                    checkFixBreak = fix_break_check(rightBoundXMin, rightBoundXMax, ...
                                                    rightBoundYMin, rightBoundYMax, ...
                                                    duration);
                    
                    if checkFixBreak == false
                        % Fixation was obtained for desired duration.
                        fixation = true;
                        area = 'right';
                        
                        return;
                    else
                        unstaggered_stimuli('none;none');
                    end 
                % Determine if eye is within the top option boundary.
                elseif xCoord >= topBoundXMin && xCoord <= topBoundXMax && ...
                       yCoord >= topBoundYMin && yCoord <= topBoundYMax
                    unstaggered_stimuli('looking;top');
                    % Determine if eye maintained fixation for given duration.
                    checkFixBreak = fix_break_check(topBoundXMin, topBoundXMax, ...
                                                    topBoundYMin, topBoundYMax, ...
                                                    duration);
                    
                    if checkFixBreak == false
                        % Fixation was obtained for desired duration.
                        fixation = true;
                        area = 'top';
                        
                        return;
                    else
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
                
    % Make a currect answer type for a trial based on experiment type.
    function answer = generate_correct_answer()
        temp = struct([]);
        
        if strcmp(experimentType, 'colorShift')
            % Generate new colorShift values.
            if trialCount == 0 || genColorShift
                % Choose a color randomly from the total color pool w/o replacement.
                randValIndex1 = rand_int(2);
                color1 = char(colors(randValIndex1));
                colors(randValIndex1) = [];

                % Choose another color randomly from the total color pool.
                randValIndex2 = rand_int(1);
                color2 = char(colors(randValIndex2));

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

                % Set the correct answer type.
                temp(currTrial).type = 'colorShift';
                temp(currTrial).dimension = 'color';
                temp(currTrial).value = color1;
                temp(currTrial).shape = shape;
                
                % Reset trigger.
                genColorShift = 0;
            else
                tempColor = colorOne;
                colorOne = colorTwo;
                colorTwo = tempColor;
                
                % Set the correct answer type.
                temp(currTrial).type = 'colorShift';
                temp(currTrial).dimension = 'color';
                temp(currTrial).value = colorOne;
                temp(currTrial).shape = chosenShape;
            end
        elseif strcmp(experimentType, 'shapeShift')
            disp('Shape shift answer generated here.');
        elseif strcmp(experimentType, 'intraSS')
            % Choose a color randomly.
            randValIndex = rand_int(2);
            value = char(colors(randValIndex));
            
            % Set the correct answer type.
            temp(currTrial).type  = 'intraSS';
            temp(currTrial).dimension = 'color';
            temp(currTrial).value = value;
        elseif strcmp(experimentType, 'extraSS')
            % Choose a dimension.
            randIndex = rand_int(1);
            dim = char(dimension(randIndex));
            
            % Choose a value for that dimension.
            randValIndex = rand_int(2);
            if strcmp(dim, 'color')
                value = char(colors(randValIndex));
            elseif strcmp(dim, 'shape')
                value = char(shapes(randValIndex));
            end
            
            % Set the correct answer type.
            temp(currTrial).type  = 'extraSS';
            temp(currTrial).dimension = dim;
            temp(currTrial).value = value;
        % THIS PART BELOW IS NOT CURRENTLY WORKING (reversal).
        elseif strcmp(experimentType, 'reversal')
            randValIndex1 = rand_int(2);
            randValIndex2 = rand_int(2);

            % Choose a correct answer value for the reversal experiment.
            tempColor = colors(randValIndex1);
            tempShape = shapes(randValIndex2);
            val = strcat(char(tempShape), ';', char(tempColor));
            
            
            % Set the correct answer type.
            temp(currTrial).type  = 'reversal';
            temp(currTrial).dimension = 'both';
            temp(currTrial).value = val;
        else
            disp('Error in generate_correct_answer.');
        end
        
        % Reset these global variables. MAKE THIS BETTER.
        colors = [{'blue'}, {'green'}, {'red'}];
        shapes = [{'circle'}, {'star'}, {'triangle'}];
        
        % Sets the current correct response.
        currentAnswer = temp(currTrial).value;
        
        answer = temp;
    end
    
    % Make random stimuli for a trial, making sure correct ans is included.
    function stimuli = generate_trial_stimuli()
        temp = struct([]);
        correctVal = currentAnswer;
        
        if strcmp(experimentType, 'reversal')
            % THIS CONDITION NOT CURRENTLY SUPPORTED.
        elseif strcmp(experimentType, 'intraSS') || strcmp(experimentType, 'extraSS')
            % Find left stimulus value.
            randIndex1 = rand_int(2);
            leftValSub1 = char(shapes(randIndex1));
            shapes(randIndex1) = [];
            randIndex2 = rand_int(2);
            leftValSub2 = char(colors(randIndex2));
            colors(randIndex2) = [];
            leftVal = strcat(leftValSub1, ';', leftValSub2);
            
            if strcmp(leftValSub1, correctVal) || strcmp(leftValSub2, correctVal)
                correctSpot = 'left';
            end
            
            % Find right stimulus value.
            randIndex1 = rand_int(1);
            rightValSub1 = char(shapes(randIndex1));
            shapes(randIndex1) = [];
            randIndex2 = rand_int(1);
            rightValSub2 = char(colors(randIndex2));
            colors(randIndex2) = [];
            rightVal = strcat(rightValSub1, ';', rightValSub2);
            
            if strcmp(rightValSub1, correctVal) || strcmp(rightValSub2, correctVal)
                correctSpot = 'right';
            end
            
            % Find top stimulus value.
            topValSub1 = char(shapes(1));
            topValSub2 = char(colors(1));
            topVal = strcat(topValSub1, ';', topValSub2);
            
            if strcmp(topValSub1, correctVal) || strcmp(topValSub2, correctVal)
                correctSpot = 'top';
            end
            
            % Set the trial values: '<shape>;<color>'.
            temp(currTrial).left  = leftVal;
            temp(currTrial).right = rightVal;
            temp(currTrial).top = topVal;
            
            % Note the location of the correct choice.
            corrAnsObject(currTrial).correct = correctSpot;
        elseif strcmp(experimentType, 'colorShift')
            tempColors = [{colorOne}, {colorTwo}, {colorTwo}];
            
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
            
            % Determin where the correct choice is located.
            if strcmp(leftValSub, correctVal)
                correctSpot = 'left';
            elseif strcmp(rightValSub, correctVal)
                correctSpot = 'right';
            elseif strcmp(topValSub, correctVal)
                correctSpot = 'top';
            end
            
            % Note the location of the correct choice.
            corrAnsObject(currTrial).correct = correctSpot;
        end
        
        % Reset these global variables. MAKE THIS BETTER.
        colors = [{'blue'}, {'green'}, {'red'}];
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
        home;
        disp('             ');
        disp('****************************************');
        disp('             ');
        fprintf('Trials completed:% 4u', trialCount);
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
        currTrial = currTrial + 1;
        
        % Fixation dot appears.
        draw_fixation_point(colorFixDot);
        
        % Check for fixation.
        [fixating, ~] = check_fixation('single', minFixTime, timeToFix);
        
        if fixating
            % Make sure correct answer is set at start of the session.
            if trialCount == 0
                corrAnsObject = generate_correct_answer;
            end
            
            % Reset correct answer if shift needs to occur.
            if mod(numCorrTrials, numCorrectToShift) == 0 && ...
               trialCount ~= 0
                % Update shift counter.
                shifts = shifts + 1;
                    
                % Increment the shift color shift counter.
                if strcmp(experimentType, 'colorShift')
                    setUnits = setUnits + 1;
                end
                
                % Schedule full color shift update at the 2nd shift.
                if mod(setUnits, 2) == 0
                    genColorShift = 1;
                end
                
                corrAnsObject = generate_correct_answer;
            end
            
            % Check experiment type.
            if strcmp(experimentType, 'reversal')
                % REVERSAL CURRENTLY NOT WORKING.
                trialObject = generate_trial_stimuli; % Make sure to generate some stimuli!
            elseif strcmp(experimentType, 'intraSS') || ...
                   strcmp(experimentType, 'extraSS') || ...
                   strcmp(experimentType, 'colorShift')
                trialObject = generate_trial_stimuli;
                
                if strcmp(sessionType, 'behavior')
                    unstaggered_stimuli('none;none');
                    
                    fixatingOnTarget = false;
                    while ~fixatingOnTarget
                        % Check for fixation on any three targets.
                        [fixatingOnTarget, area] = check_fixation('triple', holdFixTime, timeToFix);

                        if fixatingOnTarget
                            % Fetch correct location.
                            correctSpot = corrAnsObject(currTrial).correct;

                            if strcmp(area, correctSpot)
                                % Display feedback stimuli and give reward.
                                unstaggered_stimuli(strcat('correct', ';', area));
                                reward(rewardDuration);
                                WaitSecs(feedbackTime);
                                
                                % Update.
                                chosenPosition = area;
                                numCorrTrials = numCorrTrials + 1;
                                rewarded = 'yes';
                                trialOutcome = 'correct';
                                
                                % Save trial data.
                                send_and_save;
                                
                                % Reset.
                                corrAnsObject = struct([]);
                                trialObject = struct([]);
                            else
                                % Display feedback stimuli.
                                unstaggered_stimuli(strcat('incorrect', ';', area));
                                WaitSecs(feedbackTime);
                                
                                % Update.
                                chosenPosition = area;
                                rewarded = 'no';
                                trialOutcome = 'incorrect';
                                
                                % Save trial data.
                                send_and_save;
                                
                                % Reset.
                                corrAnsObject = struct([]);
                                trialObject = struct([]);
                            end
                        end
                    end
                else
                    % THIS PORTION CURRENTLY NOT WORKING (reversal).
                    staggered_stimuli;
                end
            else
                disp('Experiment started with an illegal value for the "experimentType" parameter.');
            end
        else
            % Redo this trial since monkey failed to start it.
            run_single_trial;
        end
    end
    
    % Saves trial data to a .mat file.
    function send_and_save()
        % Save variables to a .mat file.
        data(currTrial).trial = currTrial;                   % The trial number for this trial.
        data(currTrial).trialOutcome = trialOutcome;         % Whether the choice was correct or not.
        data(currTrial).choiceMade = chosenPosition;         % Location on screen that was chosen.
        data(currTrial).trialStimuli = trialObject;          % All stimuli and their positions.
        data(currTrial).correctChoiceInfo = corrAnsObject;   % Info about the correct choice.
        data(currTrial).rewarded = rewarded;                 % Whether or not a reward was given.
        data(currTrial).rewardDuration = rewardDuration;     % Duration that juicer was open.
        data(currTrial).timeToFixate = timeToFix;            % Max allowed for all fixations.
        data(currTrial).minFixTimeToStart = minFixTime;      % Fixatin time needed to start task.
        data(currTrial).holdFixTime = holdFixTime;           % Fixation duration to select an object.
        data(currTrial).feedbackTime = feedbackTime;         % Feedback duration.
        data(currTrial).ITI = ITI;                           % Intertrial interval.
        data(currTrial).experimentType = experimentType;     % What version of the task this session was.
        data(currTrial).sessionType = sessionType;           % Whether this was behavior or recording.
        data(currTrial).correctToShift = numCorrectToShift;  % Number of correct trials before a shift.
        data(currTrial).numberOfShifts = shifts;             % Total number of shifts made.
        data(currTrial).trackedEye = trackedEye;             % The eye being tracked.
        data(currTrial).colors = colors;                     % All the possible colors used.
        data(currTrial).shapes = shapes;                     % All the possible shapes used.
        
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

    function unstaggered_stimuli(outerColor)
        input = strsplit(outerColor, ';');
        status = input(1);
        spot = input(2);
        
        left = strsplit(trialObject(currTrial).left, ';');
        right = strsplit(trialObject(currTrial).right, ';');
        top = strsplit(trialObject(currTrial).top, ';');
        
        Screen('FillOval', window, colorBackground, [centerX - dotRadius + fixAdj; ...
                                                     centerY - dotRadius; ...
                                                     centerX + dotRadius - fixAdj; ...
                                                     centerY + dotRadius]);
        
        if strcmp(left(1), 'circle')
            if strcmp(left(2), 'blue')
                colorFill = colorBlue;
            elseif strcmp(left(2), 'green')
                colorFill = colorGreen;
            else
                colorFill = colorRed;
            end
            
            if strcmp(status, 'looking') && strcmp(spot, 'left')
                draw_circle('left', 'outline', colorFill, colorWhite);
            elseif strcmp(status, 'correct') && strcmp(spot, 'left')
                draw_circle('left', 'outline', colorFill, colorCyan);
            elseif strcmp(status, 'incorrect') && strcmp(spot, 'left')
                draw_circle('left', 'outline', colorFill, colorFixDot);
            else
                draw_circle('left', 'solid', colorFill, 'none');
            end
        end
        
        if strcmp(right(1), 'circle')
            if strcmp(right(2), 'blue')
                colorFill = colorBlue;
            elseif strcmp(right(2), 'green')
                colorFill = colorGreen;
            else
                colorFill = colorRed;
            end
            
            if strcmp(status, 'looking') && strcmp(spot, 'right')
                draw_circle('right', 'outline', colorFill, colorWhite);
            elseif strcmp(status, 'correct') && strcmp(spot, 'right')
                draw_circle('right', 'outline', colorFill, colorCyan);
            elseif strcmp(status, 'incorrect') && strcmp(spot, 'right')
                draw_circle('right', 'outline', colorFill, colorFixDot);
            else
                draw_circle('right', 'solid', colorFill, 'none');
            end
        end
        
        if strcmp(top(1), 'circle')
            if strcmp(top(2), 'blue')
                colorFill = colorBlue;
            elseif strcmp(top(2), 'green')
                colorFill = colorGreen;
            else
                colorFill = colorRed;
            end
            
            if strcmp(status, 'looking') && strcmp(spot, 'top')
                draw_circle('top', 'outline', colorFill, colorWhite);
            elseif strcmp(status, 'correct') && strcmp(spot, 'top')
                draw_circle('top', 'outline', colorFill, colorCyan);
            elseif strcmp(status, 'incorrect') && strcmp(spot, 'top')
                draw_circle('top', 'outline', colorFill, colorFixDot);
            else
                draw_circle('top', 'solid', colorFill, 'none');
            end
        end
        
        if strcmp(left(1), 'star')
            if strcmp(left(2), 'blue')
                colorFill = colorBlue;
            elseif strcmp(left(2), 'green')
                colorFill = colorGreen;
            else
                colorFill = colorRed;
            end
            
            if strcmp(status, 'looking') && strcmp(spot, 'left')
                draw_star('left', 'outline', colorFill, colorWhite);
            elseif strcmp(status, 'correct') && strcmp(spot, 'left')
                draw_star('left', 'outline', colorFill, colorCyan);
            elseif strcmp(status, 'incorrect') && strcmp(spot, 'left')
                draw_star('left', 'outline', colorFill, colorFixDot);
            else
                draw_star('left', 'solid', colorFill, 'none');
            end
        end
        
        if strcmp(right(1), 'star')
            if strcmp(right(2), 'blue')
                colorFill = colorBlue;
            elseif strcmp(right(2), 'green')
                colorFill = colorGreen;
            else
                colorFill = colorRed;
            end
            
            if strcmp(status, 'looking') && strcmp(spot, 'right')
                draw_star('right', 'outline', colorFill, colorWhite);
            elseif strcmp(status, 'correct') && strcmp(spot, 'right')
                draw_star('right', 'outline', colorFill, colorCyan);
            elseif strcmp(status, 'incorrect') && strcmp(spot, 'right')
                draw_star('right', 'outline', colorFill, colorFixDot);
            else
                draw_star('right', 'solid', colorFill, 'none')
            end
        end
        
        if strcmp(top(1), 'star')
            if strcmp(top(2), 'blue')
                colorFill = colorBlue;
            elseif strcmp(top(2), 'green')
                colorFill = colorGreen;
            else
                colorFill = colorRed;
            end
            
            if strcmp(status, 'looking') && strcmp(spot, 'top')
                draw_star('top', 'outline', colorFill, colorWhite);
            elseif strcmp(status, 'correct') && strcmp(spot, 'top')
                draw_star('top', 'outline', colorFill, colorCyan);
            elseif strcmp(status, 'incorrect') && strcmp(spot, 'top')
                draw_star('top', 'outline', colorFill, colorFixDot);
            else
                draw_star('top', 'solid', colorFill, 'none');
            end
        end
        
        if strcmp(left(1), 'triangle')
            if strcmp(left(2), 'blue')
                colorFill = colorBlue;
            elseif strcmp(left(2), 'green')
                colorFill = colorGreen;
            else
                colorFill = colorRed;
            end
            
            if strcmp(status, 'looking') && strcmp(spot, 'left')
                draw_triangle('left', 'outline', colorFill, colorWhite);
            elseif strcmp(status, 'correct') && strcmp(spot, 'left')
                draw_triangle('left', 'outline', colorFill, colorCyan);
            elseif strcmp(status, 'incorrect') && strcmp(spot, 'left')
                draw_triangle('left', 'outline', colorFill, colorFixDot);
            else
                draw_triangle('left', 'solid', colorFill, 'none');
            end
        end
        
        if strcmp(right(1), 'triangle')
            if strcmp(right(2), 'blue')
                colorFill = colorBlue;
            elseif strcmp(right(2), 'green')
                colorFill = colorGreen;
            else
                colorFill = colorRed;
            end
            
            if strcmp(status, 'looking') && strcmp(spot, 'right')
                draw_triangle('right', 'outline', colorFill, colorWhite);
            elseif strcmp(status, 'correct') && strcmp(spot, 'right')
                draw_triangle('right', 'outline', colorFill, colorCyan);
            elseif strcmp(status, 'incorrect') && strcmp(spot, 'right')
                draw_triangle('right', 'outline', colorFill, colorFixDot);
            else
                draw_triangle('right', 'solid', colorFill, 'none');
            end
        end
        
        if strcmp(top(1), 'triangle')
            if strcmp(top(2), 'blue')
                colorFill = colorBlue;
            elseif strcmp(top(2), 'green')
                colorFill = colorGreen;
            else
                colorFill = colorRed;
            end
            
            if strcmp(status, 'looking') && strcmp(spot, 'top')
                draw_triangle('top', 'outline', colorFill, colorWhite);
            elseif strcmp(status, 'correct') && strcmp(spot, 'top')
                draw_triangle('top', 'outline', colorFill, colorCyan);
            elseif strcmp(status, 'incorrect') && strcmp(spot, 'top')
                draw_triangle('top', 'outline', colorFill, colorFixDot);
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