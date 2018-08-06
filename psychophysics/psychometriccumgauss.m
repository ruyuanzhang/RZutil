function prob = psychometriccumgauss(x,threshold,slope,chance,lapse,scale)
% function prob = psychometriccumgauss(x,threshold,slope,chance,lapse,scale)
% 
% Compute probability of a sequence of independent response based on
% cummulative gaussain function
%
% Input:
%   x: input x data, can be a scale or a array.
%   threshold: threshold of this psychometric function, in cummulative
%               gaussian function, the threshod corresponding to the middle
%               point between chance and maximal probability. Basically, it
%               is mean(chance,1-lapse)
%   slope: slope of psychmetric function, here slope is the sigma of
%           gaussian,smaller slope refers to steeper curve.
%   chance: chance level of this task.default is 0.5/
%   lapse(optional): lapse of psychmetric function. In some cases,
%           maxima of psychometric function is not 1. Consider lapse, it
%           should be 1-lapse. default is 0.
%   scale(optional): on which scale we derive this psychmetric function, it
%                   0(default): linear scale
%                   1:log scale, transform all input x into log scale.For
%                       variable which magnitude is less than 1, we use linear
%                       scale
%
%Example
%   x=1:1:100;
%   myplot(x,psychmetriccumgauss(x,50,10));

%% deal with input
if(~exist('x','var') || isempty(x))
    error('Please input stimulus intensity');
end
if(~exist('threshold','var') || isempty(threshold))
    error('Please input stimulus intensity');
end
if(~exist('slope','var') || isempty(slope))
    error('Please input slope of this psychmetric function');
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
assert(lapse >= 0);% lapse should >=0;

%%
if scale
    assert(all(x>0),'variable value less than 0, better use linear scale')% in log scale all input should be > 0
    assert(threshold>0)% in log scale all input should be > 0
    x=log(x);
    threshold=log(threshold);
end
%% do it
P_cdf = normcdf(x,threshold,slope);% normcdf( durations, mu, sigma );
prob = chance + (1-chance-lapse)*P_cdf;
prob = 0.99*prob + eps;