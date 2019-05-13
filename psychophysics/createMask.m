function mask = createmask(res, varargin)
% mask = createMask(radius,varargin)
% 
% Inputs:
%   res:   number of pixels of the image, assuming a square image
%
% Optional varargin:
%   maskType:   'cosine', 2D cosine,default (default);
%               'gaussian',which is 2D gaussian evenlop;
%               'circular', a 2D circular envelope,
%               'annulus', a 2D annulus envelope, need to specify inner
%                   res
%   radius2: for Annulus option,number of pixels, default:(0.7 * res/2)
%   
%   gaussianStdev: standard devision for Gaussian mask,number of pixels,
%           default:(0.7 * res/2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Example;
% Figure; a=createMask(100);imagesc(a(:,:,2))
% Figure; a=createMask(100,'maskType','gaussian');imagesc(a(:,:,2))
% Figure; a=createMask(100,'maskType','annulus');imagesc(a(:,:,2))

% Note that we use kk's makecircleimage function to generate annulus image


%% define default and error signal
if(~exist('res','var') || isempty(res))
    error('Please input the res of the round mask');
end
p = struct(...
        'maskType','cosine',...
        'white',254,...
        'background',127,...
        'radius2',0.7*res/2,...
        'gaussianStd',0.7*res/2);
%parse options
input_opts=mergestruct(varargin{:});
fn=fieldnames(input_opts);
for f = 1:numel(fn)
    opt=input_opts.(fn{f});
    if(~(isnumeric(opt) && isempty(opt))) && isfield(p,fn{f})
        p.(fn{f})=input_opts.(fn{f});
    end
end
            
%% convert to unit length
[xx, yy]=calcunitcoordinates(res);
p.radius = 0.5; % default outter radius
p.radius2 = p.radius2/res;
p.gaussianStd=p.gaussianStd/res;

%% make the circular dis
circle=p.radius^2-(xx.^2+yy.^2);
circle(circle<=0)=0;
circle(circle>0)=1; % circular mask

%% make gaussian and cosin disk
if isequal(p.maskType,'gaussian') % Gaussian Disk, you have to specify gaussianStd
    circle = (exp(-(((xx)/(sqrt(2)*p.gaussianStd/2)).^2)-((yy/(sqrt(2)*p.gaussianStd/2)).^2)).*circle);
elseif isequal(p.maskType,'cosine') 
    R = (sqrt(xx.^2 + yy.^2) + eps).*circle;R = R/max(max(R));
    cos2D = (cos(R*pi)+1)/2; circle = (cos2D.*circle);  
elseif isequal(p.maskType,'annulus')
    circle = makecircleimage(res, p.radius2*res, xx, yy, p.radius*res);
end

%% convert to the format that can be used to create filter for screen function
circleMask = zeros(size(circle,1), size(circle,2), 2);
circleMask(:,:,2)=(1-circle);
circleMask(:,:,1)=ones(res, res);
mask=circleMask;

end