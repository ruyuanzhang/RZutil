function [dcolor, colors] = CreateFixationTask_LDT(nFrames,fixRate,nLum)
% [dcolor, colors] = CreateFixationTask_Luminance(nFrames)
% Create fixation task of detect luminance increment or decrement
% Inputs:
%       nFrames:    number of frames total you want the color sequence
%   optional:
%       fixRate:    how many frames you want to change the luminance, (default: 5)
%       nLum:       how many luminance levels you want. (default: 5)
% 
% Output:
%       dcolor:     a nrun * frames matrix indexing colors
%       colors:     a nLum * 3 (RGB) of color list
% 
%i.e.
% [dcolor, colors] = CreateFixationTask(nFrames)
%
% History.
% 02/24/16, RZ created it based on function CreateFixationTask.m from Jason Yeatman 
%           

if ~exist('nFrames','var')||isempty('nFrames')
    error('please input the number of frames you want');
end

if ~exist('fixRate','var')||isempty('fixRate')
    fixRate = 5; % default, change luminance every 5 frames.
end

if ~exist('nLum','var')||isempty('nLum')
    nLum = 5; %default, 5 luminance levels;
end

color =[255 255 0] ;% color for detecting. default is red [255 0 0];
colors=[linspace(color(1),40,nLum)' linspace(color(2),40,nLum)' linspace(color(3),0,nLum)'];

% Here is the fixation
dcolor = ceil(rand(1, ceil(nFrames/fixRate)).*size(colors,1));
dcolor = repmat(dcolor,fixRate,1);
dcolor = reshape(dcolor,[],size(dcolor,1)*size(dcolor,2));
dcolor = dcolor(1:nFrames);

% Add numbers so it matches KNK's format
dcolor = [-1 -dcolor -1 1];