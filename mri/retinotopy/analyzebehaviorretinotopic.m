% This script is a demo to quickly analyze behavioral data. To analyze, we
% need all target frame index, all key presses and all key press timings.
%
%
% To do:
%   1. implement false alarm??
%

reactWindow = 3; % secs, allowed time window to reponse after stimulus onset, other wise count as miss.
fixTargetIdx = find(sp.fixTargetOnset);

nTarget = length(fixTargetIdx); % How many total index;

nHit = 0;
nMiss = 0;
RT = [];
sp.fixTargetFlipTime = sp.frameFlipTime(fixTargetIdx);

for i = fixTargetIdx
    flipTime = sp.frameFlipTime(i); % flip time of that frame
    keyIdx = find(sp.keyPressTime>flipTime & sp.keyPressTime<= flipTime+reactWindow);
    if isempty(keyIdx)
        nMiss = nMiss + 1; % no response in this time window
    else
        
        % ====== This part can be modified ==============
        % in this task, no need to judge the which key to press. In other
        % exp, you might want to judge whether key is correct. Then
        % calculate hit, miss, false alarm
        nHit = nHit + 1;
                
        % get the RT, keyPressTime - flipTime. We only consider the 1st
        % button press within the window.
        RT = [RT sp.keyPressTime(keyIdx(1))-flipTime];
        
        % ====== This part can be modified ==============
    end
end
fprintf('\nWe have %02d targets, %02d hits, %02d misses\n', nTarget, nHit, nMiss);
fprintf('Min RT is %.3f ms, max RT is %.3f ms, median RT is %.3f ms\n', min(RT)*1000, max(RT)*1000, median(RT)*1000);

%% Visualize target onset and behavioral response
f2 = figure;
text(sp.keyPressTime, ones(1,length(sp.keyPressTime)) , sp.keys);
straightline(sp.fixTargetFlipTime, 'v', 'r-');
xlim([0 sp.realRunTime]); xlabel('Time (secs)');