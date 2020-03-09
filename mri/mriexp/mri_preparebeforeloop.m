function sp = mri_preparebeforeloop(sp)
% an auxiliary function. Set priority and initiate the flipstructure.
%
sp.getoutEarly = 0; % a flag to exit the program.

Priority(MaxPriority(sp.win));

% this structure control the movie flip timing
sp.flipStruct = struct(...
    'win', sp.win, ...
    'whendesired', 0, ...
    'when', 0, ...
    'iti', sp.frameDur * sp.mfi, ...
    'mfi', sp.mfi, ...
    'glitchcnt',0, ...
    'frameFlipTime', [], ...
    'keyCode', [], ...
    'keyPressTime', []...
    );

% initialize the kbQueue
KbEventFlush(sp.deviceNum);
KbQueueCreate(sp.deviceNum);
KbQueueStart(sp.deviceNum);

end