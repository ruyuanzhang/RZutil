function prob=psychmetricweibull(x,threshold,slope,thresholdaccu,chance,lapse,scale)
% function prob=psychmetricweibull(x,threshold,slope,thresholdaccu,chance,lapse,scale, format)
%
% Compute probability of correct a sequence of independent response based on weibull
% psychometric function. If you want to use contrast, please convert contrast
% from 0-1 to 0-100.
%
% Input:
%   x: input x data, can be a scale or a array.
%   threshold: threshold of this psychometric function, corresponding to
%               the thresholdaccu 
%   slope: slope of psychmetric curve
%   thresholdaccu: the accuracy level corresponding to threshold, e.g. 0.82;
%   chance: chance level probablity,e.chance. 0.5 for 2 alternative
%           forcechoice,default is 0.5.
%   lapse(optional): lapse of psychmetric function. In some cases,
%           maxima of psychometric function is not 1. Consider lapse, it
%           should be 1-lapse. default is 0.
%   Scale(optional): psymetric function in linear or log scale
%               0(default): linear scale
%               1:log scale, we transform threshold and all stimulus input
%                   to log space. We assume all threshold and stimulus
%                   input is bigger than 1. For some variable less than 1,
%                   like contrast (0,1), we use
% Output:
%   y: the probility of corrsponding to input x, can be a scalar and an
%       array
%
%Example
% x=0:0.1:10;
% myplot(psychmetricweibull(x,5,2));

%% deal with input
if(~exist('x','var') || isempty(x))
    error('Please input stimulus intensity');
end
if(~exist('threshold','var') || isempty(threshold))
    error('Please input threshold hold of this psychmetric function');
end
if(~exist('slope','var') || isempty(slope))
    error('Please input slope of this psychmetric function');
end
if(~exist('thresholdaccu','var') || isempty(thresholdaccu))
    thresholdaccu = 0.82; %default is 82% accuracy threshold
end
if(~exist('chance','var') || isempty(chance))
    chance = 0.5; % default is binary choice 
end
if(~exist('lapse','var') || isempty(lapse))
    lapse = 0;
end
if(~exist('scale','var') || isempty(scale))
    scale = 0;
end


%% check input
assert(chance>0||(chance<=1)); % chance level should be within (0,1)
assert(thresholdaccu>=chance); % threshold accuracy should >= chance
assert(lapse >= 0);% lapse should >=0;

%%
if scale
    assert(all(x>0),'some stimulus input is less than 1, better use linear scale')% in log scale all input should be > 1, for values smaller than 1, like contrast, we use linear space.
    assert(threshold>0)% in log scale all input should be > 0
end
%%
k = (-log((1-thresholdaccu)/(1-chance)))^(1/slope);

prob = 1-lapse - (1-chance-lapse)*exp(- 10.^(slope*(log10(k*x)-log10(threshold))));

prob = prob*0.99 + eps; 

