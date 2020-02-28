function [dColor, colors] = createfixtask(nFrame, nColor, fixRate, targetInterVal, targetProb)
% Create fixation task of random color changes.
% This is useful for frame-based fMRI experiment. We update fix color every frame
% But not that "frame" here does not refer to as the monitor fresh frame.
%   
% Input:
%   <nFrame>: integer, number of frames in a fMRI run.
%   <nColor>: integer, how many distinct color you want.
%   <fixRate>: integer, how many frames to present one color. (default:1)
%   <targetInterVal>: interger, how many movie frames at least the two adjacent
%   targets should be apart. (default: 2);
%   <targetProb>: integer, the probablity of occurance of target should be
%   1/targetProb. default: targetProb = nColor; Typically we input a number
%   larger than <nColor>
%    
% Output:
%   <dColor>: a vector indexing color presentation sequence,refering the row number in color list <color>.
%   <colors> is the n*3 matrix of color list, the row number n refers to <targetProb>
% 
% Notes
% 1. We assumed the target color is always red (the first one in the color
% 2. We set <nColor> as how many UNIQUE colors in the color list. We set
% <targetProb> to manipulate the probablity of target occurance. These two
% are independent. We repeat some of colors in the color list to adjust the
% target probability. The output <colors> should be <targetProb> x 3. So
% there are <targetProb> colors in the <colors>, but only <nColor> unique
% colors. Some colors are repeated. If you want, say, one target every 30
% frames, there should be at ceil(30/fixRate)
% 
% i.e.
% [dColor, colors] = createfixtask(nFrame)
%
% History.
% 02/27/20  RZ add <targetProb> to control the target probability
% 02/26/20  RZ add <targetInterVal> to avoid two adjacent target
% 02/25/20, RZ add nColor and fixRate as input
% 02/23/16, RZ added variable nColor to index number of colors
%           RZ added variable fixRate to index fixation color changing rate

if notDefined('nColor')
    nColor = 5;
end
if notDefined('fixRate')
    fixRate = 1;
end
if notDefined('targetInterVal')
    targetInterVal = 2;
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


% Create a random vector indexing into the colors

%dColor = ceil(rand(1, nFrame).*size(colors,1);

% Here is the fixation
targititemp = ceil(targetInterVal/fixRate);
while 1
    dColor = ceil(rand(1, ceil(nFrame/fixRate)).*size(colors,1));
    idx = find(dColor==1); % assume the 1st color as target color,
    if all(diff(idx)>=targititemp) % the position between two targets should at least be targititemp
        break;
    end
end

dColor = repmat(dColor, fixRate, 1);
dColor = reshape(dColor,[],size(dColor,1)*size(dColor,2));
dColor = dColor(1:nFrame);



% Add numbers so it matches KNK's format
%dColor = [-1 -dColor -1 1];