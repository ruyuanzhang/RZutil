function sp=mri_getmonitoranddevice(sp, deviceIdx)
% an auxilinary function for a MRI experiment, read the monitor information
% and input device. <sp>, exp info structure. <deviceIdx>, you can specify
% the <deviceIdx> th device we should listen to, if not supplied, default
% to the last one returned by GetKeyboardIndices.
%
%
if notDefined('deviceIdx')
    deviceIdx = [];
end

mp = getmonitorparams(sp.place);
sp.mp = mp;

[sp.deviceNum, sp.deviceName]= GetKeyboardIndices; % devicenumber to record input

if isempty(deviceIdx)
    sp.deviceNum = sp.deviceNum(end); % devicenumber to record input
    sp.deviceName = sp.deviceName{end};
else
    sp.deviceNum = sp.deviceNum(deviceIdx); % devicenumber to record input
    sp.deviceName = sp.deviceName{deviceIdx};
end

% set basic color
sp.COLOR_BLACK = 0;
sp.COLOR_GRAY = 127;
sp.COLOR_WHITE = 254;

end