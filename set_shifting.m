function set_shifting(sessionType )
    
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
    
    % Draws the fixation point on the screen.
    function draw_fixation_point(color)
        Screen('FillOval', window, color, [(centerX - dotRadius) ...
                                           (centerY - dotRadius) ...
                                           (centerX + dotRadius) ...
                                           (centerY + dotRadius)]);
        Screen('Flip', window);
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
        fprintf('Trials completed:% 3u', trialCount);
        disp('             ');
        disp('             ');
        disp('****************************************');
        
        if trialCount == trialTotal
            pause(2);
        end
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
end