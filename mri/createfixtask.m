function [dColor, colors, fixTargetOnset] = createfixtask(nFrame, nColor, fixRate, targetInterVal, targetProb)
% Create fixation task of random color changes.
% This is useful for frame-based fMRI experiment. We update fix color every frame
% But not that "frame" here does not refer to as the monitor fresh frame.
%   
% Input:
%   <nFrame>: integer, number of frames in a fMRI run.
%   <nColor>: integer, how many distinct color you want.
%   <fixRate>: integer, how many frames to present one color. (default:1)
%   <targetInterVal>: interger, how many movie frames at least the two adjacent
%       targets should be apart. (default: 2);
%   <targetProb>: integer, the probablity of occurance of target should be
%       1/targetProb. default: targetProb = nColor; Typically we input a number
%       larger than <nColor>
%    
% Output:
%   <dColor>: a vector indexing color presentation sequence,refering the row number in color list <color>.
%   <colors> is the n*3 matrix of color list, the row number n refers to <targetProb>
%   <fixTargetOnset>: the index of the onset of each target. This is useful
%       for subsequent behavioral analysis.
% 
% Notes
% 1. We assumed the target color is always red (the first one in the color
% 2. We set <nColor> as how many UNIQUE colors in the color list. We set
% <targetProb> to manipulate the probablity of target occurance. These two
% are independent. We repeat some of colors in the color list to adjust the
% target probability. The output <colors> should be <targetProb> x 3. So
% there are <targetProb> colors in the <colors>, but only <nColor> unique
% colors. Some colors are repeated. If you want, say, one target every 30
% frames, there should be at ceil(30/fixRate);
% 3. Note that <targetInterVal> and <targetProb> jointly determine the
% probility of the target. Larger <targetInterVal> and larger <targetProb>
% lower target probility.
% 
% i.e.
% [dColor, colors] = createfixtask(nFrame)
%
% History.
% 02/28/20  RZ fixed the bug when setting the least interval between two
%           targets
% 02/28/20  RZ add <fixTargetOnset> as output for subsequent behavioral
%           analysis
% 02/27/20  RZ add <targetProb> to control the target probability
% 02/26/20  RZ add <targetInterVal> to avoid two adjacent target
% 02/25/20  RZ add nColor and fixRate as input
% 02/23/16  RZ added variable nColor to index number of colors
%           RZ added variable fixRate to index fixation color changing rate

if notDefined('nFrame')
    error('You should input how many frame to generate!');
end

if notDefined('nColor')
    nColor = 5;
end
if notDefined('fixRate')
    fixRate = 6;
end
if notDefined('targetInterVal')
    targetInterVal = fixRate;
end
if notDefined('targetProb')
    targetProb = nColor;
end
    
% Make color list
colors = hsv(nColor).*255;% those different colors we want.

% make red (the target) half as likely as the others
colors = vertcat(colors);


% total size(colors,1) color items in this color list, so the target rate will be every
% fixRate * size(colors,1) per target.If you want to change the target rate, simple
% delete or add more repeated colors using code above. Let's say you want
% one target every 30 frame, then there should be ceil(30/fixRate) items in
% color list, just handly add or delete some colors 
% i.e. 
%        colors = vertcat(colors, colors(2:3));
% or     colors = vertcat(colors,colors(2:end),colors(2:end));

if targetProb < nColor
    colors = colors(1:targetProb, :);
elseif targetProb > nColor
    tmp = ceil(targetProb/(nColor-1));
    colortmp = repmat(colors(2:end,:), [tmp 1]);
    colors = [colors(1,:); colortmp];
    colors = colors(1:targetProb,:);
end

% ========== dealing with targets interval problem =============
% This part is boring.. deal

% Here is the fixation

targititemp = ceil(targetInterVal/fixRate);

nFrameTmp = ceil(nFrame/fixRate);
dColor = ones(1, nFrameTmp);
nColorInList = size(colors, 1); % how many colors in the list, note some colors are repeated
dColor(1) = randi(nColorInList);

i=2;
while i <= nFrameTmp
    if dColor(i-1) == 1 % previous frame is target
        dColor(i:i+targititemp) = randi([2 nColorInList], 1, targititemp+1);
        i = i + targititemp + 1;
    else % previous frame is not target
        dColor(i) = randi(nColorInList);
        i = i + 1;
    end
end     

%% expand dColor for fixRate
dColor = repmat(dColor, fixRate, 1);
dColor = reshape(dColor,[],size(dColor,1)*size(dColor,2));
dColor = dColor(1:nFrame);

%% calculate the onset of each stimulus, this variable is useful for
% behavioral analysis
tmp = find(dColor==1);
fixTargetOnset = zeros(1, nFrame);
fixTargetOnset(tmp(diff(tmp)~=1)-(fixRate-1)) = 1;

% Add numbers so it matches KNK's format
%dColor = [-1 -dColor -1 1];