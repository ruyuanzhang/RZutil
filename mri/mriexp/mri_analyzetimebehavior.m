function sp=mri_analyzetimebehavior(sp)
% an auxiliary function to analyze timing and behavior after loop
% 
% Here we analyze the frame flip timing in the experiment, extract
% behavioral responses, analyze RT and visualize them.
%
% IMPORTANT, you must create <sp.targetFrameOnset> as indicating the onset
% frane of each target.

%% analyze movie frame timing
sp.frameFlipTime = sp.flipStruct.frameFlipTime;
sp.expStartTime = sp.frameFlipTime(1);
sp.frameFlipTime = sp.frameFlipTime - sp.expStartTime(1); % referece to the onset time of the first frame
sp.realRunTime = sp.frameFlipTime(end) + sp.frameDur * sp.mfi;
fprintf('\nThis run took %.4f secs, the desired time is %.4f secs \n', sp.realRunTime, sp.totalSecs);

% visualize flip duration of all movie frames.
figure;
set(gcf, 'Units','normalized', 'Position', [0.2 0.5 0.5 0.2]);
myplot(1:length(sp.frameFlipTime)-1, diff(sp.frameFlipTime));
xlabel('Frame#');ylabel('Frame duration (secs)');

%% analyze behavioral data
sp.keyCode = sp.flipStruct.keyCode;
sp.keyPressTime = sp.flipStruct.keyPressTime;
sp.keyPressTime = sp.keyPressTime - sp.expStartTime; % reference to the onset of the first movie frame
sp.keys = KbName(sp.keyCode);

% Remove trigger key, if any
idx = find(~strcmp(sp.triggerKey, sp.keys));
if ~isempty(idx)
    sp.keys = sp.keys(idx);
    sp.keyPressTime = sp.keyPressTime(idx);
else
    sp.keys = {};
    sp.keyPressTime =[];
end
assert(numel(sp.keys)==numel(sp.keyPressTime), sprintf('%d keys do not match %d keyPressTime', numel(sp.keys), numel(sp.keyPressTime)));

% allowed time window to reponse after stimulus onset, otherwise count as miss.
reactWindow = 3; % secs.

targetFrameIdx = find(sp.targetFrameOnset); 
% note that you need to specify the sp.targetFrameIdx ahead when
% creating frameorder

nTarget = length(targetFrameIdx); % How many total index;

keyPressTimeTmp = sp.keyPressTime; % to save a temporary variable
keysTmp = sp.keys;

sp.targetFlipTime = sp.frameFlipTime(targetFrameIdx);

nHit = 0;
nMiss = 0;
RT = [];
for i = targetFrameIdx
    flipTime = sp.frameFlipTime(i); % flip time of that frame
    
    keyIdx = find(keyPressTimeTmp>flipTime & keyPressTimeTmp<= flipTime+reactWindow);
    
    if isempty(keyIdx)
        nMiss = nMiss + 1; % no response in this time window
    else
        
        % ====== This part can be modified ==============
        % in this task, no need to judge the which key to press. In other
        % exp, you might want to judge whether key is correct. Then
        % calculate
        nHit = nHit + 1;
                
        % get the RT, keyPressTime - flipTime. We only consider the 1st
        % button press within the window.
        RT = [RT keyPressTimeTmp(keyIdx(1))-flipTime];
        
        % and then we delete this key press to avoid it can be then counted
        % in another trial. So the earlier responses should assgined to
        % early trials.
        keyPressTimeTmp = deleteel(keyPressTimeTmp, keyIdx(1));
        keysTmp = deleteel(keysTmp, keyIdx(1));
        
        % ====== This part can be modified ==============
    end
end
fprintf('\nWe have %02d targets, %02d hits, %02d misses\n', nTarget, nHit, nMiss);
fprintf('Min RT is %.3f ms, max RT is %.3f ms, median RT is %.3f ms\n', min(RT)*1000, max(RT)*1000, median(RT)*1000);

% Visualize target onset and behavioral response
figure();
set(gcf, 'Units','normalized', 'Position', [0.2 0.3 0.5 0.2]);
straightline(sp.targetFlipTime, 'v', 'r-');
text(sp.keyPressTime, ones(1,length(sp.keyPressTime)) , sp.keys);
xlim([0 sp.realRunTime]); xlabel('Exp time (secs)');