function sp=createframeorderretinotopic(sp)
% calculate frameorder based on the stimulus parameters. The key here is to
% Create <sp.maskframeorder>, <sp.checkerframeorder>. and variables for
% fixation task <sp.fixColorOrder>, <sp.fixColors>, <sp.fixTargetOnset>
%
% Wedge, CCW:counter-clock wise, CW: clockwise
% Ring, EXP: expansion, CTR: contraction
%
% To do:
%   1: implement the stimulus flag


%% Key here, create mask frame order 
% do some stimulus calculations
tmpCCW = flatten(repmat(1:sp.nWedgeStep, [sp.nFramePerSec * sp.stimDur, 1]));
tmpCW = flatten(repmat([1 sp.nWedgeStep:-1:2], [sp.nFramePerSec * sp.stimDur, 1]));
tmpEXP = flatten(repmat(1:sp.nRingStep, [sp.nFramePerSec * sp.stimDur, 1]));
tmpCTR = flatten(repmat(sp.nRingStep:-1:1, [sp.nFramePerSec * sp.stimDur, 1]));

tmpITI = zeros(1, sp.nFramePerSec * sp.cycleITI);
tmpBlank = zeros(1, sp.nFramePerSec * sp.blankBeginEnd);

if sp.expNo == 1 % wedge (CCW and CW)
    sp.expName = 'wedgeCCWCW';
    sp.masks = sp.masks{1};
    sp.totalSecs = sp.blankBeginEnd * 2 + sp.stimDur * sp.nWedgeStep * sp.nCycle + sp.cycleITI*(sp.nCycle-1);
    % assemble them, the sequence is  CCW-CW-CCW-CW
    sp.maskFrameOrder = repmat([tmpCCW tmpITI tmpCW tmpITI], [1, sp.nCycle/2]); % note here we alternate CCW and CW
    
    
elseif sp.expNo == 2 % ring (expand and contraction)
    sp.expName = 'ringEXPCTR';
    sp.masks = sp.masks{2};
    sp.totalSecs = sp.blankBeginEnd * 2 + sp.stimDur * sp.nRingStep * sp.nCycle + sp.cycleITI*(sp.nCycle-1);
    % assemble them, the sequence is  EXP-CTR-EXP-CTR
    sp.maskFrameOrder = repmat([tmpEXP tmpITI tmpCTR tmpITI], [1, sp.nCycle/2]); % note here we alternate CCW and CW

elseif sp.expNo == 3
    sp.expName = 'wedgeCCW';
    sp.masks = sp.masks{1};
    sp.totalSecs = sp.blankBeginEnd * 2 + sp.stimDur * sp.nWedgeStep * sp.nCycle + sp.cycleITI*(sp.nCycle-1);
    % assemble them, the sequence is  CCW-CCW-CCW-CCW
    sp.maskFrameOrder = repmat([tmpCCW tmpITI tmpCCW tmpITI], [1, sp.nCycle/2]); % note here we alternate CCW and CW
    
elseif sp.expNo == 4
    sp.expName = 'wedgeCW';
    sp.masks = sp.masks{1};
    sp.totalSecs = sp.blankBeginEnd * 2 + sp.stimDur * sp.nWedgeStep * sp.nCycle + sp.cycleITI*(sp.nCycle-1);
    % assemble them, CW-CW-CW-CW
    sp.maskFrameOrder = repmat([tmpCW tmpITI tmpCW tmpITI], [1, sp.nCycle/2]); % note here we alternate CCW and CW
    
elseif sp.expNo == 5
    sp.expName = 'ringEXP';
    sp.masks = sp.masks{2};
    sp.totalSecs = sp.blankBeginEnd * 2 + sp.stimDur * sp.nRingStep * sp.nCycle + sp.cycleITI*(sp.nCycle-1);
    % assemble them, EXP-EXP-EXP-EXP
    sp.maskFrameOrder = repmat([tmpEXP tmpITI tmpEXP tmpITI], [1, sp.nCycle/2]); % note here we alternate CCW and CW
    
elseif sp.expNo == 6
    sp.expName = 'ringCTR'; % CTR-CTR-CTR-CTR
    sp.masks = sp.masks{2};
    sp.totalSecs = sp.blankBeginEnd * 2 + sp.stimDur * sp.nRingStep * sp.nCycle + sp.cycleITI*(sp.nCycle-1);
    sp.maskFrameOrder = repmat([tmpCTR tmpITI tmpCTR tmpITI], [1, sp.nCycle/2]); % note here we alternate CCW and CW
    
elseif sp.expNo == 7
    sp.expName = 'wedge&ring'; % CCW-CW-EXP-CTR
    sp.masks = cat(3, sp.masks{:});
    sp.totalSecs = sp.blankBeginEnd * 2 + sp.stimDur * (sp.nWedgeStep+sp.nRingStep) * sp.nCycle/2 + sp.cycleITI*(sp.nCycle-1);
    sp.maskFrameOrder = repmat([tmpCCW tmpITI tmpCW tmpITI tmpEXP+sp.nWedgeStep tmpITI tmpCTR+sp.nWedgeStep], [1, sp.nCycle/4]); % note here we alternate CCW and CW
end

%
sp.nFrame = sp.nFramePerSec * sp.totalSecs;

% manually remove the last iti
sp.maskFrameOrder = sp.maskFrameOrder(1:end-length(tmpITI));

% add blank at beginning and end
sp.maskFrameOrder = [tmpBlank sp.maskFrameOrder tmpBlank];


%% Create checkerboard frame order, no matter what experiment.
tmpIdx = find(sp.maskFrameOrder~=0);
tmpChecker = ones(1, length(tmpIdx));
tmpChecker(2:2:end) = 2;
sp.checkerFrameOrder = zeros(1, sp.nFrame);
sp.checkerFrameOrder(tmpIdx) = tmpChecker;

% make stimulus onset flag to ease the subsequent trial analysis


%% Create fixation task
sp.fixRate = 10; % 10 movie frames per fixation
sp.fixNColor = 5; % number of unique fix colors
sp.fixTargetAprt = 30; % two consecutive targets should be at
% least 30 frames apart
[sp.fixColorOrder, sp.fixColors]=createfixtask(sp.nFrame, 5, 10, 30, 20);
% 20 color items, which lead to on average 20 * 10 (fixrate) = 200 frames = 20s per target.

% Create a target flag for behavioral analysis
tmp = find(sp.fixColorOrder==1);
sp.fixTargetOnset = zeros(1,sp.nFrame);
sp.fixTargetOnset(tmp(diff(tmp)~=1)-(sp.fixRate-1)) = 1;

