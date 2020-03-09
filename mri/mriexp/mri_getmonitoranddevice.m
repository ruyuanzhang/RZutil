function sp=mri_getmonitoranddevice(sp, deviceIdx)
% an auxilinary function for a MRI experiment, read the monitor information
% and input device. <sp>, exp info structure. <deviceIdx>, you can specify
% the input devide index. if not supplied, 
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
    sp.deviceNum = deviceIdx; % devicenumber to record input
    sp.deviceName = sp.deviceName{sp.deviceNum==deviceIdx};
end

% set basic color
sp.COLOR_BLACK = 0;
sp.COLOR_GRAY = 127;
sp.COLOR_WHITE = 254;

end