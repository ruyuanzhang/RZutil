function sp=mri_cleanupafterloop(sp)
% an auxiliary function, close texture and window, close and release kbqueue 

% stop and release the kbqueue
KbQueueStop(sp.deviceNum);
KbQueueRelease(sp.deviceNum);
KbReleaseWait(sp.deviceNum);

ptoff(sp.oldclut, sp.win);
Priority(0);
commandwindow;
ShowCursor;

end