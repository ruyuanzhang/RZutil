function sp=mri_showwelcometext(sp)
% An auxililary function. It will show welcome text, print out some
% diagnoistic information, and waiting for subject trigger the experiment.

% show welcome text or instruction
Screen('FillRect', sp.win, sp.COLOR_BLACK, sp.winRect);
Screen('TextSize', sp.win, 30);Screen('TextFont', sp.win,'Arial');

% becareful, some monitor or psychtoolbox version might not allowed
% DrawFormattedText2
DrawFormattedText2(...
    sp.welcomeTxt,...
    'win', sp.win,'sx','center','sy','center','xalign','center','yalign','center','xlayout','center');

Screen('Flip', sp.win);


%% print some diagnostic information
fprintf('\nThe expName is %s \n', sp.expName);
fprintf('The whole run will last %d secs.\n', sp.totalSecs);
fprintf('%.3f s per movie frame.\n', 1/sp.nFramePerSec);
fprintf('We listen input from device No. %d, %s \n', sp.deviceNum, sp.deviceName);

% print window information
fprintf('\nOpen window No. %d, winRect width %d height %d pixels. \n', sp.win, sp.winRect(3), sp.winRect(4));
fprintf('Monitor flip interval is %.6f. \n', sp.mfi);

fprintf('\npress a key to begin the movie. (make sure to turn off network, energy saver, spotlight, software updates! mirror mode on!)\n');

%% trigger the exp
getkeyresp(sp.triggerKey, -3); % get key respond and proceed
fprintf('Experiment starts!\n');
Screen('Flip', sp.win);
% issue the trigger and record it

end