function [VBLTimestamp, flipStruct] = updateflip(flipStruct)
%% 
% This function is useful to manually code the stimulus timing information
% in a trial. It can calculate the time for next flip <when>, based on
% required interval <iti>, and update <glitchcnt> information
%
% <flipStruct> is a structure contains follow information
%   <win>: window index;   
%   <when>: when to flip, typically obtained from last update
%   <whendesired>: calculated time to flip
%   <iti>: time interval for next flip
%   <glitchcnt>: count how many glitch
%   <mfi>: time per monitor fresh
%
% Note that <whendesired> is just auxililary variable. The we should focus
% on <when> as the time to set for flip
%
% Before you use this function, you might need to initialize the struct,
% like
% flipStruct = struct(...
%     'win', win, ...
%     'when', 0, ...
%     'whendesired', 0, ...
%     'iti', sp.frameDur, ...
%     'mfi', mfi, ...
%     'glitchcnt',0 ...
%     );


%issue the flip command and record the empirical time
[VBLTimestamp,~,~,Missed,~] = Screen('Flip', flipStruct.win, flipStruct.when);

%if we missed, report it
if flipStruct.when ~=0 && (VBLTimestamp - flipStruct.whendesired) > (flipStruct.mfi * (1/2))
    flipStruct.glitchcnt = flipStruct.glitchcnt + 1;
    didglitch = 1;
else
    didglitch = 0;
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
    flipStruct.whendesired = VBLTimestamp + flipStruct.iti;
end
flipStruct.when = flipStruct.whendesired - flipStruct.mfi * (9/10);  % should we be less aggressive??



end