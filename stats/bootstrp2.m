function output=bootstrp2(nboot,bootfun,bootinput,otherparams)
%function dist=bootstrp2(nboot,bootfun,bootinput,otherparams)
% Bootstrap the results for a function
% Input:
%   nboot: number of samples
%   bootfun: the function handle. For conveniance, the function handle
%       should written as it accepts in generally two parts of inputs -
%       bootinput, see below, that we want to resampled and otherparams,
%       that we want to input as parameters. i.e. func(input1,input2,otherparams)
%       If a function handle is not in
%       this form, please rewritten or wrapper it to fulfill this form.
%   bootinput: a cell vector within which each element are input vector for
%       functional handle, this variable specified which vector to
%       resample.
%   otherparams:all other extra parameters for function handel
% Output: output is a structure with field as below
%   <nboot>:a scaler, number of bootstrap samples,default:1000
%   <dist>: 1xnboot array of bootstrapped results
%   <bootsamples>: a cell array that contains all bootstrap samples.
%   
% Example:
% a=[1 2 3 4];b=[1 2 3 4];
% betadiff=@(x,y,otherparams) nanmean(x)-nanmean(y)+otherparams;
% dist = bootstrp2(1000,betadiff,{a,b},{3}); 
% figure;hist(dist);

if(~exist('nboot','var') || isempty(nboot))
    nboot=1000;
end
if(~exist('bootfun','var') || isempty(bootfun))
    error('Please input function handel');
end
if(~exist('bootinput','var') || isempty(bootinput))
    bootinput={};
end
if~exist('otherparams','var') || isempty(otherparams)
    otherparams = {};
end

%% first test the size of output
try
    % Get result of bootfun on actual data, force to a row.
    temp = feval(bootfun,bootinput{:},otherparams{:});
    temp = temp(:)';
catch ME
    m = message('stats:bootstrp:BadBootFun');
    MEboot =  MException(m.Identifier,'%s',getString(m));
    ME = addCause(ME,MEboot);
    rethrow(ME);
end


dist={};
bootvargin={};
% we use parfor to accelerate
parfor p=1:nboot
    % resample to get an input
    tmp=cellfun(@bootresample,bootinput,'UniformOutput', false);
    % run function
    bootsamples{p}=tmp;
    dist{p}=feval(bootfun,tmp{:},otherparams{:});
    
end
dist = catcell(2,dist);
output.dist = dist;
output.nboot = nboot;
output.bootsamples = bootsamples;
end
