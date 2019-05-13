
function p = creategrating(res, varargin)
% grating = createGrating(radius,varargin)
% 
% Inputs:
%   res:     pixels in one dimension, assuming a square image

% Optional Inputs:
%   orientation:    orientation of grating,in deg, default:0 deg, vertical
%   cpfov:          cycles per field of view
%   contrast:       0~1, contrast, default:1, full contrast
%   amplitude:      0~127, default,127
%   maskType:        'cosine'(default), 2D cosine;
%                   'gaussian',which is 2D gaussian evenlop;
%                   'circular', a 2D circular envelope
%   gaussianStdev: pixels, default: 0.7*res/2
%   mvLen: how many frames to present the stimulus, default:1
%   temporalModu: (default, all 1) temporal modulation mask vector (0-1), should be the same length
%       as mvLen 
%   windowPtr: window pointer, if supplied, we directly make the image into
%       a texture and return the index of the texture

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Example;
%gratings = createGrating(100,'orientation',90);
%gratings = createGrating(100,'orientation',90,'cpfov',4);
%gratings = createGrating(100,'orientation',90,'cpfov',4,'windowPtr',w);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Things to do

%% define default and error signal
if(~exist('res','var') || isempty(res))
    error('Please input the dimension of the grating');
end

%% parse and merge input
p = struct(...
        'orientation', 0,...
        'cpfov',8,...
        'contrast',1,...
        'amplitude',127,...
        'background',127,...
        'maskType','cosine',...
        'gaussianStdev', 0.7*res/2,...
        'mvLength',1,...
        'temporalMask',[],...
        'windowPtr',[]);
input_opts=mergestruct(varargin{:});
fn=fieldnames(input_opts);
for f = 1:numel(fn)
    opt=input_opts.(fn{f});
    if(~(isnumeric(opt) && isempty(opt))) && isfield(p,fn{f})
        p.(fn{f})=input_opts.(fn{f});
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
%% generating grating images
f=p.cpfov * 2 * pi;
a=cosd(p.orientation)*f; b=sind(p.orientation)*f;
p.amplitude = p.amplitude*p.contrast;
gratingImg = zeros(res,res,p.mvLength);
[xx,yy]=calcunitcoordinates(res);
for i = 1:p.mvLength
    gratingImg(:,:,i) = round(((sin(a*xx+b*yy).*spatialMask*p.amplitude*p.temporalMask(i))+p.background));
    if ~isempty(p.windowPtr)
        gratingMovie{i}=Screen('MakeTexture', p.windowPtr, gratingImg(:,:,i));
    end
end

%% output should be a struct
p.gratingImg = gratingImg;
if ~isempty(p.windowPtr)
    p.gratingMovie = gratingMovie;
end
end
