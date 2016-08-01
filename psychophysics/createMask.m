% draw a circular mask on the stimulus
function mask = createMask(radius,varargin)
% maskCOS = SetupCircularMask(radius,w,maskType)
% 
% Inputs:
%   radius:     radius of this circular of this circular mask in number of
%               pixel
%
% Outputs:
%   mask:       the output mask as a texture which is ready to present on a
%               screen using Screen('DrawTexture') function
%
%
%
% Optional Inputs:
%   maskType:   Default,'Cosine',2D cosine,default;
%               'Gaussian',which is 2D gaussian evenlop;
%               'Circular', a 2D circular envelope,
%               'Annulus', a 2D annulus envelope, need to specify inner
%                   radius
%               'squre'
%
%   background: background gray scale value,default, 127
%   white:      surface gray scale value,default,254
%
%
%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Example;



% Updated RZ 04-28-16
%   Wrote the function



%% define default and error signal
if(~exist('radius','var') || isempty(radius))
    error('Please input the radius of the round mask');
end

options = struct(...
        'maskType','cosine',...
        'white',254,...
        'background',127,...
        'innerRadius',0.7*radius);

%parse options
input_opts=mergestruct(varargin{:});
fn=fieldnames(input_opts);
for f = 1:numel(fn)
    opt=input_opts.(fn{f});
    if(~(isnumeric(opt) && isempty(opt)))
        options.(fn{f})=input_opts.(fn{f});
    end
end
            
%%
[x,y]=meshgrid(-radius:radius,-radius:radius);
bps = (radius)*2+1;circle=((radius)^2-(x.^2+y.^2));
for i=1:bps;
    for j =1:bps;
        if circle(i,j) < 0; circle(i,j) = 0;
        else
            circle(i,j) = 1;
        end;
    end;
end;
if isequal(options.maskType,'gaussian')
    circle = (exp(-(((x)/(sqrt(2)*Gaussian_stdev/2)).^2)-((y/(sqrt(2)*Gaussian_stdev/2)).^2)).*circle);
elseif isequal(options.maskType,'cosine')
    R = (sqrt(x.^2 + y.^2) + eps).*circle;R = R/max(max(R));
    cos2D = (cos(R*pi)+1)/2;circle = (cos2D.*circle);  
elseif isequal(options.maskType,'annulus')
    circle = 1-circle;
    [x,y]=meshgrid(-options.innerRadius:options.innerRadius,-options.innerRadius:options.innerRadius);
    innerbps = (options.innerRadius)*2+1;innerCircle=((options.innerRadius)^2-(x.^2+y.^2));
    for i=1:innerbps;
        for j =1:innerbps;
            if innerCircle(i,j) < 0; innerCircle(i,j) = 0;
            else
                innerCircle(i,j) = 1;
            end;
        end;
    end;
    circle(round(end/2)-options.innerRadius:round(end/2)+options.innerRadius,round(end/2)-options.innerRadius:round(end/2)+options.innerRadius) = innerCircle; 
    
    %innerCircle;
end


circleMask = zeros(size(circle,1), size(circle,1), 2);
circleMask(:,:,2)=(1-circle)*options.white;
circleMask(:,:,1)=ones(bps,bps)*options.background;
mask=circleMask;

end