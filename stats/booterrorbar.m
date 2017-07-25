function er = booterrorbar(x,metric,errorFormat,prcntage,nBoot)
% function booterrorbar(x,metric,errorFormat,nBoot)
%
% Estimate the errorbar given a vector and a metric
%
% Input:
%   x: input vector, can be ROW or COLUMN, we flatten it to row
%   optional:
%       metric: a string, specify 'mean'(default),'median','nanmean','nanmedian';
%       errorFormat: a string:
%           'single': (default) return a single number,half of the range between
%               low/up range.
%           'bound': return two number, upper and lower bound
%       prcntage: e.g. 95, 95% confidence interval, default:68
%       nBoot: number of bootstrap samples, default:1000
% Output:
%   er: a scalar, if errorFormat == 'single'
%          a two element vector,if errorFormat = 'bound'. represent the lower 
%           and uppder offset.
%           
% Notes:
%   1.Once we detect a nan value inside, we switch to nanmedian or nanmean
%
%
if ~exist('x','var')||isempty(x)
    error('Please input a vector!');
end
if ~exist('metric','var')||isempty(metric)
    metric = 'mean';
end
if ~exist('errorFormat','var')||isempty(errorFormat)
    errorFormat = 'single'; 
end
if ~exist('prcntage','var')||isempty(prcntage)
    prcntage = 68; 
end
if ~exist('nBoot','var')||isempty(nBoot)
    nBoot = 1000; 
end

% deal with input
if any(isnan(x))
    fprintf('detect nan value, use nanmean or nanmedian');
    if strcmp(metric,'mean')
        metric = 'nanmean';
    elseif strcmp(metric,'median')
        metric = 'nanmedian';
    end
end

[samples,~] = bootresamplemulti(x,nBoot);
switch metric
    case 'mean'
        tmp = mean(samples);
        tmp2 = mean(x);
    case 'median'
        tmp = median(samples);
        tmp2 = median(x);
    case 'nanmean'
        tmp = nanmean(samples);
        tmp2 = nanmean(x);
    case 'nanmedian'
        tmp = nanmedian(samples);
        tmp2 = nanmedian(x);
end

prcntage = (100 - prcntage)/2*[-1 1]+50;% compute target prcntage
% get bound
er = prctile(tmp,prcntage);
if strcmp(errorFormat,'single')
    er = diff(er);
else strcmp(errorFormat,'bound')
    er = [tmp2-er(1),er(2)-tmp2];
end

