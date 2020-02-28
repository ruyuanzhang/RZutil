function runretinotopic_old(expNo)
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
% Checkerboard is default 768 x 768 pixels. But we set movieRect dimension
% as height of a monitor (i.e., winRect(4)). CheckerBoard flickers at
% <flickerRate, 5> HZ. by default. There are <nCheckerRing, 8> rings and 
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
% We output one figure
%
% To do:
%   1. Make the stimulus shorter and more cycles?? 
%   2. Make the wedge or ring steps, stimulus duration as functions??
%   3. optimize welcome text
%   4. write about output.
%
% History:
%   20200227 RZ almost completed the first version. RZ fix stimulus
%       duration and number of wedge and ring steps.


%% Some high-level controls

% experiment 
sp.expNo = expNo;
sp.blankBeginEnd = 16; % secs, blank at begining and end
sp.cycleITI = 4; % secs, interval between two consecutive cycles
% How many monitor freshes per movie frame.
sp.flickerRate = 5; % HZ, how many flickers in a secs.
sp.freshRate = 60; % monitor refresh rate
% note that here we fixed stimDur and cycles to make sure the whole
% experiment lasts 300 secs
sp.stimDur = 8; % secs, duration for each stimulus;
sp.nCycle = 4; % How many wedge or ring cycles.
% This number should be even for this experiment as we alternate CCW and CW cycles

% Stimulus parameters
sp.nWedgeStep = 8; % how many steps for the wedge mask, from upper vertical to CCW direction
sp.nRingStep = 8; % how many steps for the ring mask, from fovea to peripery
sp.dim = 768; % default dimensions, you can set it as the height of the monitor

% how many checkerboard Ring, note this is not no of ring masks, better to
% set it to the same or times of sp.nRingStep
sp.nCheckerRing = 8;

% How many wedges in the checkerboard stimuli, better to set it to the same
% or times of sp.nWedgeStep
sp.nCheckerWedge = 16; % how many checkerboard Ring, note this is not no of ring masks


%% Some calculations and setup
sp.frameDur = 1/sp.flickerRate / 2 * sp.freshRate; % how many freshes per movie frame
sp.nFramePerSec = sp.freshRate / sp.frameDur; % How many movie frames per sec

[sp.deviceNum, sp.deviceName] = GetKeyboardIndices;
[sp.deviceNum, sp.deviceName] = deal(sp.deviceNum(end), sp.deviceName{end});

sp.fixSize = sp.dim * 0.02; % pixes

sp.COLOR_BLACK = 0;
sp.COLOR_GRAY = 127;
sp.COLOR_WHITE = 254;

sp.wantFormattedString = 1;
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
sp = createframeorder(sp);

% We output some auxilllary information about the experiment.
fprintf('The expName is %s \n', sp.expName);
fprintf('Each stimulus is %d sec, %d cycles in total. %d s between two cycles, %ds blank at beginning and end.\n',sp.stimDur, sp.nCycle, sp.cycleITI, sp.blankBeginEnd);
fprintf('The whole run will last %d secs.\n', sp.totalSecs);
fprintf('Checkerboard will flicker at %d HZ.\n', sp.flickerRate);
fprintf('%.3f s per movie frame.\n', 1/sp.nFramePerSec);
fprintf('We listen input from device No. %d, %s \n', sp.deviceNum, sp.deviceName);


%% ========= window setup ===========
commandwindow;
HideCursor;
%[win, winRect, oldclut] = pton([],[],[],1);
[win, winRect, oldclut] = pton([],0.5,[],1);
Screen('BlendFunction',win,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
mfi = Screen('GetFlipInterval',win);  % re-use what was found upon initialization!

% calculate movieRect and fixation Rect
movieRect = [0 0 winRect(4) winRect(4)]; % note here we default to set the dimension to monitor height
sp.movieRect = CenterRect(movieRect,winRect);
sp.fixRect = [winRect(3)/2-sp.fixSize/2 winRect(4)/2-sp.fixSize/2 winRect(3)/2+sp.fixSize/2 winRect(4)/2+sp.fixSize/2];
sp.winRect = winRect;

% We can premake the checkerboard texture because we only have a few images
texture = zeros(1, size(sp.checkerBoard, 3));
for iImg = 1:size(sp.checkerBoard, 3)
    texture(iImg) = Screen('MakeTexture', win, sp.checkerBoard(:,:,iImg));
end
% We can also premake the mask texture
maskTex = zeros(1, size(sp.masks, 3));
for iImg = 1:size(sp.masks, 3)
    grayImg = uint8(ones(size(sp.masks,1),size(sp.masks,2))*sp.COLOR_GRAY);
    tmp = cat(3, grayImg, uint8(255-sp.masks(:,:,iImg)*255));
    maskTex(iImg) = Screen('MakeTexture', win, tmp);
end


%% MRI related preparation
% some auxillary variables
sp.frameFlipTime = [];
sp.triggerKey = '5%'; % the key to start the experiment

welcomeText = '<color=1.,1.,1.>Press "5" to start the experiment\n Press "1" to respond when the ring turns red';

% show welcome text or instruction
Screen('FillRect', win, sp.COLOR_GRAY, winRect);
Screen('TextSize',win,30);Screen('TextFont',win,'Arial');
if sp.wantFormattedString
    DrawFormattedText2(...
         welcomeText,...
        'win',win,'sx','center','sy','center','xalign','center','yalign','center','xlayout','center');
end
Screen('Flip',win);

fprintf('press a key to begin the movie. (make sure to turn off network, energy saver, spotlight, software updates! mirror mode on!)\n');
getkeyresp(sp.triggerKey, -3); % get key respond and proceed
fprintf('Experiment starts!\n');
Screen('Flip',win);
% issue the trigger and record it
 
%% now run the experiment
flipStruct = struct(...
    'win', win, ...
    'when', 0, ...
    'whendesired', 0, ...
    'iti', sp.frameDur * mfi, ...
    'mfi', mfi, ...
    'glitchcnt',0 ...
    );

% initiate the kbQueue
KbQueueCreate(sp.deviceNum);
KbQueueStart(sp.deviceNum);

% do it;
for iFrame = 1 :sp.nFrame
    
    % draw fixation
    Screen('FillOval', win, sp.fixColors(sp.fixColorOrder(iFrame), :), sp.fixRect);
    
    % draw images
    if sp.checkerFrameOrder(iFrame) ~= 0
        Screen('DrawTexture', win, texture(sp.checkerFrameOrder(iFrame)), [], sp.movieRect, 0, [], 1);
        % apply mask
        Screen('DrawTexture', win, maskTex(sp.maskFrameOrder(iFrame)), [], sp.movieRect, 0, [], 1);
        
    end
       
    % flip the window and update the flipStruct   
    [flipTime, flipStruct] = updateflip(flipStruct);
    sp.frameFlipTime = [sp.frameFlipTime flipTime]; % record the frameFlipTime
    
%     % save images to make demo video
%     if sp.wantFrameFiles
%         image=Screen('GetImage', win, sp.movieRect);
%         imwrite(image,sprintf('./frameimg/frame%03d.png',iFrame));
%     end
    
end
KbQueueStop(sp.deviceNum); % stop listen the keyboard

%%
Screen('Close', texture); % you need to close all texture before you call ptoff
ptoff(oldclut);
% extract keyboard event
[sp.keys, sp.keyPressTime, sp.keyCode] = getkeyboardevent(sp.deviceNum); % remember to extract the event before release kbqueue

KbQueueRelease(sp.deviceNum); % release KbQueueRelease
KbReleaseWait(sp.deviceNum);

sp.keyPressTime = sp.keyPressTime - sp.frameFlipTime(1); % reference to the onset of the first movie frame
sp.frameFlipTime = sp.frameFlipTime - sp.frameFlipTime(1);
sp.realRunTime = sp.frameFlipTime(end) + sp.frameDur * mfi;
fprintf('\nThis run took %.4f secs, the desired time is %.4f secs \n', sp.realRunTime, sp.secPerRun);

% visualize timing information
myplot(1:length(sp.frameFlipTime)-1, diff(sp.frameFlipTime));
xlabel('Frame');ylabel('Frame duration');

% analyze behavioral data
%analyzebehaviorMRI;

%% clean up and save data
filename=sprintf('%s_retinotopy%s_subj%02d', datestr(now, 'yyyymmddHHMMSS'), sp.expName, sp.subj);
save(filename); % save everything to the file;

end
