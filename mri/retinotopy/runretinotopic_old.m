%function runretinotopic_old(expNo, subjNo)
% This is the program to run retinotopic mapping conventional checkerboard
% method. Check runretinotopic.m written by KK for more advanced PRF
% approach. 
% 
% This code can run both pure wedge, pure ring, or both wedge and
% ring. This function can also run counter-clockwise (CCW), pure
% clockwise(CW), or both CCW and CW wedge. This function can also run pure
% expand (EXP), pure contraction (CTR) or both EXP and CTR rings.
%
% In the default settings, there are <nWedgeStep, 8> wedge steps and
% <nRingStep, 8> ring steps. Each stimulus lasts <stimDur, 8> secs. One
% lasts 8*8=64 secs. There is <cycleITI, 4> secs blank between two cycles.
% There are <nCycle, 4> cycles in each run. The order and format of the 4
% cycles depends on <expNo>. A <blankBeginEnd, 16> secs blank is also added
% to the beginning and the end of each run. A run lasts 300s = 5min.
%
% Checkerboard is default 1080 x 1080 pixels. But we set movieRect dimension
% as height of a monitor (i.e., sp.winRect(4)). CheckerBoard flickers at
% <flickerRate, 5> HZ. by default. There are <nCheckerRing, 16> rings and 
% <nCheckerWedge, 16> steps of wedges on the checkerboard.
% 
% The wedge masks we create starts from the wedge at the vertial-up
% position, and CCW rotate. The ring masks starts from fovea to periphary.
%
% We create disk checkerboard stimuli using 'creatediskcheckerboard.m'
% function and wedge and ring masks using 'createwedgeringmask.m' function.
% We generate stimulus presentation orders using 'createframeorder.m'
% function.
% 
% We assume monitor freshRate is 60 HZ.
%
% The only input is <expNo>. Now can be input for number 1-7, as follows
% expNo=1, CCW and CW wedges, order is CCW-CW-CCW-CW
% expNo=2, EXP and CTR rings, order is EXP-CTR-EXP-CTR
% expNo=3, CCW only wedges,   order is CCW-CCW-CCW-CCW
% expNo=4, CW only wedges,    order is CW-CW-CW-CW
% expNo=5, EXP only rings,    order is EXP-EXP-EXP-EXP
% expNo=6, CTR only rings,    order is CTR-CTR-CTR-CTR
% expNo=7, wedges and rings,  order is CCW-CW-EXP-CTR
% 
% We output one figure show the duration of each movie frame, and one
% figure illustrating the onset of fixation target and behavior response.
% We also save the data as usual formats.
%
% We now analyze behavioral data using 'analyzebehaviorretinotopic.m'
% function
%
% To do:
%   1. Make the stimulus shorter and more cycles?? better need to
%   2. Make the wedge or ring steps, stimulus duration as functions??
%   3. Write about output.
%
% History:
%   20200303 RZ change the code to used mri_xxx auxiliary functions
%   20200228 RZ fixed some bugs in auxililary function. Also set default
%       dimension to 1080 and default ring numbers <sp.nCheckerRing> on
%       checkerboard images to 16;
%   20200227 RZ almost completed the first version. RZ fix stimulus
%       duration and number of wedge and ring steps.


if notDefined('expNo')
    expNo = 7; % default to both wedge and ring
end
if notDefined('subjNo')
    subjNo = 99;
end

sp.triggerKey = 't'; % the key to start the experiment

sp.expNo = expNo;
sp.subjNo = subjNo;

%% Some high-level controls

% Experiment 
sp.stimDur = 8; % secs, duration for each stimulus;
sp.nCycle = 4; % How many wedge or ring cycles, should be times of 4
% This number should be even for this experiment as we alternate CCW and CW cycles
sp.blankBeginEnd = 16; % secs, blank at begining and end
sp.cycleITI = 4; % secs, interval between two consecutive cycles

% How many monitor freshes per movie frame.
sp.flickerRate = 5; % HZ, how many flickers in a secs.
sp.freshRate = 60; % monitor refresh rate
% note that here we fixed stimDur and cycles to make sure the whole
% experiment lasts 300 secs

% Stimulus parameters
sp.nWedgeStep = 8; % how many steps for the wedge mask, from upper vertical to CCW direction
sp.nRingStep = 8; % how many steps for the ring mask, from fovea to peripery
sp.dim = 1080; % default dimensions, you can set it as the height of the monitor

% how many checkerboard Ring, note this is not no of ring masks, better to
% set it to the same or times of sp.nRingStep
sp.nCheckerRing = 16;

% How many wedges in the checkerboard stimuli, better to set it to the same
% or times of sp.nWedgeStep
sp.nCheckerWedge = 32; % how many checkerboard Ring, note this is not No of ring masks

%% Some calculations and setup
sp.frameDur = 1/sp.flickerRate / 2 * sp.freshRate; % how many freshes per movie frame
sp.nFramePerSec = sp.freshRate / sp.frameDur; % How many movie frames per sec

% no need to get the monitor parameter here
[sp.deviceNum, sp.deviceName] = GetKeyboardIndices;
[sp.deviceNum, sp.deviceName] = deal(sp.deviceNum(end), sp.deviceName{end});
sp.COLOR_GRAY = 127;
sp.COLOR_WHITE = 254;
sp.COLOR_BLACK = 0;

sp.wantFrameFiles = 0; % 1, save some pictures for making demo video; 0, do not save

%% Create stimuli
fprintf('Create stimuli and masks...\n');
sp.checkerBoard = creatediskcheckerboard(sp.dim, sp.nCheckerWedge, sp.nCheckerRing);
sp.checkerBoard = cat(3, sp.checkerBoard{:});
sp.checkerBoard = uint8(sp.checkerBoard*127+127);
sp.masks = createwedgeringmask(sp.dim, sp.nWedgeStep, sp.nRingStep);
fprintf('done\n');

%% ======== key part=================
% In this step, We create the 
% sp.maskFrameOrder and sp.checkerFrameOrder to present stimulus
% sp.fixColorOrder and sp.colors for fixation task
sp = createframeorderretinotopic(sp);

%% ========= window setup ===========
[sp.win, sp.winRect, sp.oldclut, sp.mfi] = pton([],[],[],1); % for debug
sp.fixSize = sp.winRect(4) * 0.015;

% calculate movieRect and fixation Rect
movieRectSize = min(sp.winRect(4), size(sp.checkerBoard, 1));
movieRect = [0 0 movieRectSize movieRectSize]; % note here we default to set the dimension to monitor height
sp.movieRect = CenterRect(movieRect,sp.winRect);
sp.fixRect = [sp.winRect(3)/2-sp.fixSize/2 sp.winRect(4)/2-sp.fixSize/2 sp.winRect(3)/2+sp.fixSize/2 sp.winRect(4)/2+sp.fixSize/2];

% We can premake the checkerboard texture because we only have a few images
texture = zeros(1, size(sp.checkerBoard, 3));
for iImg = 1:size(sp.checkerBoard, 3)
    texture(iImg) = Screen('MakeTexture', sp.win, sp.checkerBoard(:,:,iImg));
end
% We can also premake the mask texture
maskTex = zeros(1, size(sp.masks, 3));
for iImg = 1:size(sp.masks, 3)
    grayImg = uint8(ones(size(sp.masks,1),size(sp.masks,2))*sp.COLOR_GRAY);
    tmp = cat(3, grayImg, uint8(255-sp.masks(:,:,iImg)*255));
    maskTex(iImg) = Screen('MakeTexture', sp.win, tmp);
end

% make sure to input the texture you make here to mri_cleanupafterloop.m
% in order to close all of them.

%% Show welcome interface
sp.welcomeTxt = sprintf(['<color=1,1,1>Press "%s" key to start the experiment.\n Press button when fixation turns red\n', ...
'IMPORTANT!Please keep your eye on the fixation throughout the entire experiment!'], sp.triggerKey);
sp=mri_showwelcometext(sp);
 
%% now run the experiment
sp = mri_preparebeforeloop(sp);
% do it;
for iFrame = 1 :sp.nFrame
    
    if sp.getoutEarly
        sca;
        commandwindow;
        ShowCursor;
        return;
    end
    
    Screen('FillRect', sp.win, sp.COLOR_GRAY, sp.winRect);
    % draw images
    if sp.checkerFrameOrder(iFrame) ~= 0
        Screen('DrawTexture', sp.win, texture(sp.checkerFrameOrder(iFrame)), [], sp.movieRect, 0, [], 1);
        % apply mask
        Screen('DrawTexture', sp.win, maskTex(sp.maskFrameOrder(iFrame)), [], sp.movieRect, 0, [], 1);
        
    end
    
    % draw fixation
    Screen('FillOval', sp.win, sp.fixColors(sp.fixColorOrder(iFrame), :), sp.fixRect);
    
    % control flip and get response
    sp = mri_updateflipresp(sp);
    
%     % save images to make demo video
%     if sp.wantFrameFiles
%         image=Screen('GetImage', sp.win, sp.movieRect);
%         imwrite(image,sprintf('./frameimg/frame%03d.png',iFrame));
%     end
    
end
sp=mri_cleanupafterloop(sp, texture, maskTex); % should input all texture index so we can close

%% analyze timing and behavioral resonse
sp=mri_analyzetimebehavior(sp);

%% clean up and save data
filename=sprintf('%s_retinotopy%s_subj%02d', datestr(now, 'yyyymmddHHMMSS'), sp.expName, sp.subjNo);
save(filename); % save everything to the file;

%end
