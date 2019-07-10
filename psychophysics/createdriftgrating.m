function p = createdriftgrating(res, varargin)
% function p = createdriftgrating(res, varargin)
% 
% Inputs:
%   res:     pixels in one dimension, assuming a square image
%
% Optional Inputs:
%   orientation:    orientation of grating,in deg, default:0 deg, vertical
%   cpfov:          cycles per field of view
%   TF_step: angles per frame, can calculate as (2*pi*speed*SF)/frame_rate
%           default:0.4189, it is corresponded to SF = 1 cycles/deg,
%           speed=4deg/sec, frame_rate=60hz;
%   contrast:       0~1, contrast, default:1, full contrast
%   amplitude:      0~127, default,127
%   maskType:       'cosine'(default), 2D cosine;
%                   'gaussian',which is 2D gaussian evenlop;
%                   'circular', a 2D circular envelope
%   gaussianStdev: pixels, default: 0.7*res/2, only useful if we set
%       'maskType' to 'gaussian'
%   mvLen: how many frames to present the stimulus, default:60
%   temporalMask: (default, all 1) temporal modulation mask vector (0-1), should be the same length
%       as mvLen 
%   windowPtr: window pointer, if supplied, we directly make the image into
%       a texture and return the index of the texture
%
% Example;
%   gratings = createDriftGrating(100,'orientation',90);
%   gratings = createDriftGrating(100,'orientation',90,'cpfov',4);
%   gratings = createDriftGrating(100,'orientation',90,'cpfov',4,'windowPtr',w);
%
% Notes
%  1. We input TF_step deg/frame instead of speed (deg/sec) to indicate the
%   speed. You can easily calculate by (2*pi*speed*SF)/frame_rate
%  2. We initial the phase as random

%% define default and error signal
if(~exist('res','var') || isempty(res))
    error('Please input the dimension of the grating');
end

%% parse and merge input
p = struct(...
        'orientation', 0,...
        'cpfov',8,... 
        'TFstep',0.4189,... % 
        'contrast',1,...
        'amplitude',127,...
        'background',127,...
        'maskType','cosine',...
        'gaussianStdev', 0.7*res/2,...
        'mvLength',60,...
        'temporalMask',[],...
        'windowPtr',[]);
input_opts=mergestruct(varargin{:});
fn=fieldnames(input_opts);
for f = 1:numel(fn)
    opt=input_opts.(fn{f});
    if ~(isnumeric(opt) && isempty(opt)) && isfield(p,fn{f})
        p.(fn{f})=input_opts.(fn{f});
    else
        error('You might input wrong variable: %s', fn{f});
    end
end 
            
%% create the spatial mask
if strcmp(p.maskType,'gaussian')
    spatialMask = createmask(res,'maskType',p.maskType,'gaussianStd',p.gaussianStd);
else
    spatialMask = createmask(res,'maskType', p.maskType);
end
spatialMask = 1-spatialMask(:,:,2);

%% deal with temporal Mask
if isempty(p.temporalMask)
    p.temporalMask=ones(1,p.mvLength);
else
    assert(length(p.temporalMask)==p.mvLength,'The length of thetemporal mask should be mvLen!');
end
%% generating drift grating images
f=p.cpfov * 2 * pi;
a=cosd(p.orientation)*f; b=sind(p.orientation)*f;
p.amplitude = p.amplitude*p.contrast;
driftGratingImg = zeros(res,res,p.mvLength);
[xx,yy]=calcunitcoordinates(res);
motion_step = rand*2*pi * ones(1, p.mvLength);
p.motion_step = (0:p.mvLength-1)*p.TFstep + motion_step;

for i = 1:p.mvLength
    driftGratingImg(:,:,i) = round(((sin(a*xx+b*yy+p.motion_step(i)).*spatialMask*p.amplitude*p.temporalMask(i))+p.background));
    if ~isempty(p.windowPtr)
        driftGratingMovie{i}=Screen('MakeTexture', p.windowPtr, driftGratingImg(:,:,i));
    end
end
%% output should be a struct
p.driftGratingImg = driftGratingImg;
if ~isempty(p.windowPtr)
    p.driftGratingMovie = driftGratingMovie;
end
end
