function [keys, keyPressTime, keyCode] = getkeyboardevent(deviceIdx, triggerKey)
% This function is to extract all button press after running KbQueue
% functions during a fMRI experiment. This function should be called after
% KbQueueStop() and before KbQueueRelease().
%
% We remove triggerKey if <triggerKey> is supplied. <triggerKey> should be
% a string, like '5', we convert it to triggerCode
%
% We input the keyboard or response <deviceIdx> and output the <keyCode>, a
% vector of keycode, and <keyPressTime>, a vector of press timing, and
% <keys>, a cell vector of buttons being pressed.
% 
% Note that we ignore the key release events as we only care the key press.
% And <keyPressTime> is the machine time returned by GetSecs. To get
% reaction time, they should be substructed an reference time point.
%
% 20200303 RZ now seperate this functionality to mri_updateflipresp and
% mri_analyzetimebehavior

if notDefined('deviceIdx')
    error('You must provide the device index used in kbqueue!');
end
if notDefined('triggerKey') % optional
    triggerKey='';
end

assert(ischar(triggerKey), 'triggerKey should be a string, like "5" ');

keys = {};
keyCode = [];
keyPressTime = [];
while KbEventAvail(deviceIdx)
    evt = KbEventGet(deviceIdx);
    if evt.Pressed
        keys = [keys {KbName(evt.Keycode)}];
        keyCode = [keyCode evt.Keycode];
        keyPressTime = [keyPressTime evt.Time];
    end
end
n = KbEventFlush(deviceIdx);
assert(n==0, 'KbEventFlush did not flush all events, need manual check!');


% Remove MRI triggerKey
if ~isempty(KbName(triggerKey))
    idx = find(keyCode~=KbName(triggerKey));
    keyCode = keyCode(idx);
    keys = keys(idx);
    keyPressTime = keyPressTime(idx);
end






end