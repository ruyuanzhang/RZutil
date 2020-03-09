function sp=mri_cleanupafterloop(sp, varargin)
% an auxiliary function, close texture and window, close and release kbqueue
% 
% <varargin> is the variable input for all textures made before. before we
% call ptoff, we should first close all textures;

% stop and release the kbqueue
KbQueueStop(sp.deviceNum);
KbQueueRelease(sp.deviceNum);
KbReleaseWait(sp.deviceNum);

% close all textures made before call ptoff
for i=1:numel(varargin)
    Screen('Close', varargin{i}); % you need to close all texture before you call ptoff
end

ptoff(sp.oldclut);
Priority(0);
commandwindow;
ShowCursor;

end