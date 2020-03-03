function sp = mri_updateflipresp(sp)
% An auxiliary function in an MRI exp. This is also the most importatn
% auxiliary mri exp function.
%
% This function is useful to manually to control the flip of each movie
% frame and continously check button responses using KbQueueCheck in a trial. 
%
% To control the flip timing, tt calculates the time for next flip <when>,
% based on required interval <iti>, and update <glitchcnt> information
%
% <flipStruct> is a structure contains follow information
%   <win>: window index;   
%   <when>: when to flip, typically obtained from last update
%   <whendesired>: calculated time to flip
%   <iti>: time interval for next flip
%   <glitchcnt>: count how many glitch
%   <mfi>: time per monitor fresh
%   <frameFlipTime>: a vector to store the frameFlipTime
%   <keys>: a cell vector to store button press
%   <keyPressTime>: a vector to store the time for each button press
%
% Note that <whendesired> is just auxililary variable. The we should focus
% on <when> as the time to set for flip. The whole timing control
% flow/logic is derived from knk's function ptviewmovie.m
%
% Before you use this function, you might need to initialize the struct,
% like
% sp.flipStruct = struct(...
%     'win', sp.win, ...
%     'when', 0, ...
%     'whendesired', 0, ...
%     'iti', sp.frameDur * sp.mfi, ...
%     'mfi', sp.mfi, ...
%     'glitchcnt',0, ...
%     'frameFlipTime', [], ...
%     'keys', {},...
%     'keyPressTime', [] ...
%     );


% give hint to PT that we're done drawing. Can improve timing
Screen('DrawingFinished', sp.win);

flipStruct = sp.flipStruct;

% the while loop, read inpt until we have to flip
didglitch = 0;
while 1
    if flipStruct.when == 0 | GetSecs >= flipStruct.when % in this case, we have to flip
        % issue the flip command and record the empirical time
        VBLTimestamp = Screen('Flip', flipStruct.win, flipStruct.when);
        flipStruct.frameFlipTime = [flipStruct.frameFlipTime VBLTimestamp]; % save the flip time of this frame 
        
        % If we missed, report it
        if flipStruct.when ~=0 && (VBLTimestamp - flipStruct.whendesired) > (flipStruct.mfi * (1/2))
            flipStruct.glitchcnt = flipStruct.glitchcnt + 1;
            didglitch = 1;
        else
            didglitch = 0;
        end
        
        break; % get out of this loop
    
     
    else % otherwise, no need to flip, read input
        
        % 1st approach, suggested by harvard website, 
        % The drawback is not to handle multiple presses of the same key.
        % it only accounts for the 1st press..
        
        % [keyIsDown, time] = KbQueueCheck(sp.deviceNum);
        % keys = KbName(find(keyIsDown));
        % flipStruct.keys = [flipStruct.keys keys];
        % flipStruct.keyPressTime = [keyPressTime find(time)];
        
        
        % 2nd approach, use kbevent, suggested by kbqueuedemo.m
        % check keyboard event, if any, record it
        while KbEventAvail(sp.deviceNum)
            evt = KbEventGet(sp.deviceNum);
            if evt.Pressed
                flipStruct.keyCode = [flipStruct.keyCode evt.Keycode];
                flipStruct.keyPressTime = [flipStruct.keyPressTime evt.Time];
            end
        end
        
        if any(flipStruct.keyCode==KbName('ESCAPE') | flipStruct.keyCode==KbName('q'))
            fprintf('Escape or q key detected.  Exiting prematurely.\n');
            sp.getoutEarly = 1;
            commandwindow;
            break; % break the loop
        end
      
    end
end

% update when to flip next frame, the next frame should be the first frame
% of the first trial
% update when
if didglitch
    % if there were glitches, proceed from our earlier when time.
    % set the when time to 9/10 a frame before the desired frame.
    % notice that the accuracy of the mfi is strongly assumed here.
    flipStruct.whendesired = flipStruct.whendesired + flipStruct.iti ;
else
    % if there were no glitches, just proceed from the last recorded time
    % and set the when time to 9/10 a frame before the desired time.
    % notice that the accuracy of the mfi is only weakly assumed here,
    % since we keep resetting to the empirical VBLTimestamp.
    flipStruct.whendesired = flipStruct.frameFlipTime(end) + flipStruct.iti;
end
flipStruct.when = flipStruct.whendesired - flipStruct.mfi * (9/10);  % should we be less aggressive??
        

% update flip struct        
sp.flipStruct = flipStruct;
end