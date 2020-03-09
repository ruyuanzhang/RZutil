%% KbQueue fMRI demo
% This demo shows how to record all button press and retrive in the
% background while running stimulus. We record all keys and press timing
% posthocly. This is useful for the experiment no need to present stimulus
% based on subjects responses. If you need only monitoring subjects
% responses. Use KbQueueCheck()

%
cl;

keyboardindex = GetKeyboardIndices;
keyboardindex = keyboardindex(2);

commandwindow;
%% before you running all your
KbQueueCreate(keyboardindex);
KbQueueStart(keyboardindex); % 
startTime = GetSecs;

WaitSecs(10); % here is the for loop you should present your stimulus

KbQueueStop(keyboardindex); % stop to deliever key events

%% now posthocly retrive all events
fprintf('During the test interval, %i events were recorded.\n', KbEventAvail(keyboardindex));
% note that any key press involves two events, press and release, We can
% only focus on key press
%
% this part now can be replaced by function
% getkeyboardevent(keyboardindex). check RZutil/mri

keyPressTime = [];
keyCode = [];

while KbEventAvail(keyboardindex)
    [evt, n] = KbEventGet(keyboardindex);
    if evt.Pressed
        keyPressTime = [keyPressTime  evt.Time]; % note this time is the OBSOLUTE machine time, very large
        keyCode = [keyCode  evt.Keycode];
    end
end
% add we can get the press time as reference the starting point
keyPressTime = keyPressTime-startTime;

% Note that we should release the Queue at very end after we retrive all
% events
KbQueueRelease(keyboardindex); % release KbQueueRelease
KbReleastWait(keyboardindex);


