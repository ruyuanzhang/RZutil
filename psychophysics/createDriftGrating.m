
function grating = createDriftGrating(radius,varargin)
% grating = createDriftGrating(radius,varargin)
%   Quickly gerenate drifting grating for motion study
%
%
% Inputs:
%   radius:     radius of grating, in pixel
%
% 
% Outputs:
%   grating:    an N by N martrix with 0~254
%
%
%
% Optional Inputs:
%   orientation:    orientation of grating,in deg, default:0 deg, vertical
%   sf:             spatial frequency in cyc/deg, default: 1 cycle/deg
%   contrast:       contrast, default:1, full contrast
%   speed:          how fast things move,default, 4 deg/sec
%   direction:      direction of motion,default,1,left motion;
%   amplitude:      maximal amplitude allowed for the shine wave,
%                   default,:127
%   background:     gray value of backgrou, default,127;
%   frameRate:      frame rate of the monitor, default,60HZ, 
%   scaleFactor:    scaleFactor for this experiment,related to spatial
%                   frequency
%
%
%   mvLength:      how many frames to present stimulus, default,60;
%   spatialMaskType:   Default,'Cosine',2D cosine,default;
%                   'Gaussian',which is 2D gaussian evenlop;
%                   'Circular', a 2D circular envelope
%   sptatialMaskGaussian,
%   temporal_mask:  temporal evenlope, defailt, square evenlope

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Example;
%gratings = createGrating(100,'orientation',90);
%gratings = createGrating(100,'orientation',90,'sf',4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%things to do
%   1.implmente temporal envelope function
%   

% Updated RZ 05-02-16
%   Wrote the function



%% define default and error signal
if(~exist('radius','var') || isempty(radius))
    error('Please input the radius of the round mask');
end

options = struct(...
        'orientation', 0,...
        'sf',1,...
        'contrast',1,...
        'speed',4,...
        'direction',1,...
        'amplitude',127,...
        'background', 127,...
        'scaleFactor',2,...
        'frameRate',60,...
        'spatialMaskType','cosine',...
        'spatialMaskGaussianSigma',2,...
        'mvLength',60,...
        'temporalMask',[],...
        'temporalMaskGaussianSigma',[]);

%% parse options
input_opts=mergestruct(varargin{:});
fn=fieldnames(input_opts);
for f = 1:numel(fn)
    opt=input_opts.(fn{f});
    if(~(isnumeric(opt) && isempty(opt)))
        options.(fn{f})=input_opts.(fn{f});
    end
end
            
%% create the spatial mask
[x,y]=meshgrid(-radius+1:radius,-radius+1:radius);
bps = (radius)*2;circle=((radius)^2-(x.^2+y.^2));
for i=1:bps;
    for j =1:bps;
        if circle(i,j) < 0; circle(i,j) = 0;
        else
            circle(i,j) = 1;
        end;
    end;
end;
if isequal(options.spatialMaskType,'gaussian')
    if(isfield(options,'spatialMaskGaussianSigma') || isempty(options.spatialMaskGaussianSigma))
        error('Please specify the std of spatial gaussian envelope');
    else
        circle = (exp(-(((x)/(sqrt(2)*option.spatialMaskGaussianSigma/2)).^2)-((y/(sqrt(2)*option.spatialMaskGaussianSigma/2)).^2)).*circle);
    end
elseif isequal(options.spatialMaskType,'cosine')
    R = (sqrt(x.^2 + y.^2) + eps).*circle;R = R/max(max(R));
    cos2D = (cos(R*pi)+1)/2;circle = (cos2D.*circle); 
end
    

if(isfield(options,'temporalMaskGaussianSigma') || isempty(options.temporalMaskGaussianSigma))
    options.temporalMask = ones(1,options.mvLength);
else
    options.temporalMask = envelope();
end


%% motion related stuff
%make the movie
options.TF = options.sf*options.speed;
TFstep = (2*pi*options.TF)/options.frameRate;
motion_step(1) = rand*2*pi;
for i=2:options.mvLength;
    motion_step(i) = motion_step(i-1)-options.direction*TFstep;
end

%% generating grating images
f=(options.sf*options.scaleFactor/60)*2*pi;
a=cosd(options.orientation)*f; b=sind(options.orientation)*f;
gratingImg = zeros(bps,bps,options.mvLength);

for i = 1:options.mvLength
    gratingImg(:,:,i) = round(((sin(a*x+b*y+motion_step(i)).*circle*options.amplitude*options.temporalMask(i))+options.background));
end
gratingImg = uint8(gratingImg);    

%% output should be a struct
options.gratingImg = gratingImg;
grating = options;
end
