function [paramsfit, plikeli] = fitpsychometricfun(stim, choice, form, psychometricParams, wantfig)
% function [paramsfit, plikeli] = fitpsychmetricfun(stim, choice, form, psychometricParams, wantfig)
%
% quickly fit psychometric function for choice using maximu likelihood
% method
%
% <stim>: a vector of stimulus intensity
% <choice>: a vector of binary, 0,1, indicating two choices or
%   wrong/correct
% <form>: a string, name of psychmetric function
%   (1):'weibull': weibull function
%   (2):'cumgauss': cumulative gaussian function
% <psychometricParams>: a structure, params for psychmetric functions, with
% fields:
%   "threshold": the threshold to fit, default to nan, indicating a free
%       parameter
%   "slope": slope of the psychometric function,, default to nan,
%       indicating a free parameter.
%   "lapse":default to 0, or you can set it to nan, indicating a free
%       parameter to estimate
%   "thresholdaccu": the accuracy level corresponding to threshold,
%       default:0.82, 
%   "chance": chance level, default:0.5
%   "scale": 0 (default), linear;1, logscale
% <wantfig>: bool, whether to plot the fit figure
%
% This function output the <paramsfit>, the fitted parametes and the minimal POSITIVE
% likelihood.
%
% Notes:
% 1. Note that the parameters we estimate are usually threshold, slope, and
% lapse. You can set one of them to nan, indicating setting it as a free
% parameter. Or you can input a value, then the fitting processing will fix
% that value to this variable.
% 
% 2. the default parameters in <psychometricParams> are for 2AFC. For like
% 4AFC, you should change them
%
% 3. for all elements in <stim> > 0, can use both 'weibull' and 'cumgauss'.
% For <stim> containning any value <0, only use 'cumgauss'
%
% 4. for all elements in <stim> > 0, can use <scale> both linear or log
% For <stim> containning any value <0, only use linear
%
% 5. We randomly initialize the initial param0 10 times can choose the
% <paramsfit>, corresponding to the minimal p

if ~exist('stim', 'var')| isempty(stim)
    error('Please input the stimuli value')
end
if ~exist('choice', 'var')| isempty(choice)
    error('Please input the stimuli value')
end
if ~exist('form', 'var')| isempty(form)
    form = 'weibull';
end
if ~exist('psychometricParams','var') | isempty(psychometricParams)
    psychometricParams = struct('threshold', nan);
end
if ~exist('wantfig','var') | isempty(wantfig)
    wantfig = 0;
end

stim = flatten(stim);
choice = flatten(choice);
% check data
assert(length(stim)==length(choice), 'input stim and choice inconsistent');

% merge the parameter structure of the psychometric function
% default parameters for psychometric function
% note here by default, we set <slope> to nan, meaning treatinig <slope> as a
% free parameter. Also, default <lapse>=0, which is fixed
p = struct(...
    'threshold', nan, ...
    'slope', nan, ...
    'lapse', 0, ...
    'thresholdaccu', 0.82, ...  % thresholdaccu is necessary for weibull function but not necessesary for cumgauss
    'chance',0.5,...
    'scale',0);
% update and converge the structs
p = mergestruct(p, psychometricParams);

% preparefitting
options = optimset('Algorithm','active-set','MaxFunEvals',1e+5,'MaxIter',1e+5);

% for both the weibull and cumulative psychometric function, we need to fit threshold, slope, or lapse.
% But slope and lapse are optional.

% figure lower and upper bound of parameters
LB = zeros(1, 3);
UB = zeros(1, 3);
LB(1) = min(stim);
UB(1) = max(stim);
if isnan(p.slope) % we set slope as a free parameter
    LB(2) = 1e-5;
    UB(2) = 20;
else
    LB(2) = p.slope;
    UB(2) = p.slope;
end
if isnan(p.lapse) % we set lapse as a free parameter
    LB(3) = 1e-5;
    UB(3) = 1;
else
    LB(3) = p.lapse;
    UB(3) = p.lapse;
end

%% do it
% we fit 10 times
fprintf(sprintf('fit %s psychometric functions 10 times ... \n', form));
paramsfitMat = zeros(10,4);
for i = 1:10
    params0 = [LB(1) + rand*(UB(1)-LB(1)), LB(2) + rand*(UB(2)-LB(2)), LB(3) + rand*(UB(3)-LB(3))];
    %[paramsfitMat(1,1:3), paramsfitMat(1,4)]= fminsearchbnd(@(params) computeposlikeli(params, stim,choice,form,p),params0, LB, UB, options);
    [paramsfitMat(i,1:3), paramsfitMat(i,4)]= fmincon(@(params) computeposlikeli(params, stim, choice, form, p),params0, [],[],[],[],LB, UB, [], options);
end
fprintf('Done. \n');
[~,ind] = min(paramsfitMat(:,4));
paramsfit= paramsfitMat(ind,1:3);
plikeli= paramsfitMat(ind,4);
    
%% if wantfig
if wantfig % want to visualize
    f = figure;
    scatter(stim(choice==0), p.chance* ones(1,length(stim(choice==0))), 'ko'); hold on;
    scatter(stim(choice==1), ones(1,length(stim(choice==1))), 'ro');
    if strcmpi(form, 'weibull')
        myplot(linspace(min(stim), max(stim)+20,100), psychometricweibull(linspace(1, max(stim),100), paramsfit(1), paramsfit(2),...
            p.thresholdaccu, p.chance, paramsfit(3), p.scale));
    elseif strcmpi(form, 'cumgauss')
        myplot(linspace(min(stim), max(stim)+20,100), psychometriccumgauss(linspace(min(stim), max(stim),100), paramsfit(1), paramsfit(2),...
            p.chance, paramsfit(3), p.scale));
    end
    axis([1, max(stim), p.chance, 1]);
    legend({'incorrect trials', 'correct trials', 'psychometric curve'},'Location','east');
    xlabel('stimuli');
    ylabel('probability');
    title(sprintf('positive likelhood is %.04f', plikeli))
    if p.scale == 1 
        set(gca, 'XScale','log');
        axis([1, max(stim)*1.2, p.chance, 1]);
    else
        axis([min(stim), max(stim), p.chance, 1]);
    end
end

end


% The function to calculate postivie likelihood
function poslikeli = computeposlikeli(params, stim, choice, form, psychmetricParams)
    
    % decomposate the parameter for weibull psychometric function
    threshold = params(1);
    slope = params(2);
    lapse  = params(3);
    
    thresholdaccu = choose(isfield(psychmetricParams, 'thresholdaccu'), psychmetricParams.thresholdaccu, []);
    chance = choose(isfield(psychmetricParams, 'chance'), psychmetricParams.chance, []);
    scale  = choose(isfield(psychmetricParams, 'scale'), psychmetricParams.scale, []);
        
    if strcmp(form,'weibull') % weibull psychometric function
        prob = psychometricweibull(stim, threshold, slope, thresholdaccu, chance, lapse, scale);
    elseif strcmp(form,'cumgauss') % cumulative gauss psychometric function psychometric function
        prob = psychometriccumgauss(stim, threshold, slope, chance, lapse, scale);
    end
    assert(all(prob>0),'some cases in probability < 0');
    poslikeli = -sum(log(prob(choice==1))) - sum(log(1-prob(choice==0)));
end