function [rs_keys, secs] = getkeyresp(targetKeys,KbNum)
% function [rs_keys, secs] = getkeyresp(targetKeys,KbNum)
% Wait for key press and then proceed to next step. Note that we can input
% a key list 
% 
% Input:
%   <targetKeys>: a cell of strings that indicate the keys we want to check. As
%       long as one of the keys being pressed, we proceed.
%   <kbNum>(optional): keyboard number for KbCheck function, default:-1, receive
%       input from all devices
%   <wantKeyIdx>(optional): integer, which key you want to output. If kbCheck detect multiple
%       key press,
%       0: output all pressed keys
%       n: output the n-th key in the list
%       default:1, output the 1st key
% Output:
%   <rs_keys>: pressed keys
%   <secs>: reaction time report from KbCheck, but basically useless
% 
% Note that we first filter the pressed keys if multiple keys are pressed
% then compared pressed keys to <targetKeys>

if notDefined('targetKeys')
    error('You must define target keys, like "LeftArrow"');
end
if notDefined('KbNum')
    KbNum = -1;
end
if notDefined('wantKeyIdx')
    wantKeyIdx = 1; % output the 1st element
end

if ~iscell(targetKeys)
    targetKeys={targetKeys};
end
targetKeys = cellfun(@KbName, targetKeys); % convert keys from string to numbers

% go to the main loop
FlushEvents('keyDown');
while 1
    [keyIsDown, secs, keyCode] = KbCheck(KbNum);
    if keyIsDown
        rs_key = find(keyCode == 1);
        % if multiple key presses, we might need only one key
        if wantKeyIdx ~= 0                
            rs_key=rs_key(wantKeyIdx);
        end
        % check keys
        rs_keys=intersect(rs_key, targetKeys);
        if ~isempty(rs_keys)
            break;
        end
        
    end
end
rs_keys = KbName(rs_keys);
FlushEvents('keyDown');
end