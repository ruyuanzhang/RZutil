function [randcondmat, condmat]=getranddesign(trialnum,expcond)
%
% create a design matrix that randomize different conditions, this is
% useful for psychphysics experiment.
%
% Input:
%   trialnum: Total number of trial in this block, we assumed total trial
%       number could be fully divided by exp condition number
%   expcond: a scaler or an array of experiment condition. i.e. there are 4
%           speed levels, 5 directions, 3 locations.The expcond=[4 5 3].
%
%   
% Output:
%   randcondmat: randomized condition matrix. The first column is 1:trialnum. Then
%           the other columns corresponding to expcond
%   condmat: non randomized condition matrix. The first column is 1:trialnum. Then
%           the other columns corresponding to expcond

%% deal with input
if(~exist('trialnum','var') || isempty(trialnum))
    error('Input the trial number');
end
if(~exist('expcond','var') || isempty(expcond))
    error('Input the conditions for this experiment, e.g.[2 3 4]');
end

%% check the data
% we assume total trial number is divisible by all exp condition. 
assert(rem(trialnum,prod(expcond))==0,'trialnumber cannot be fully divisble by expcond');


%% do it
trialpercond = trialnum/prod(expcond);
tmp=(1:trialpercond)';
for i = numel(expcond):-1:1
    tmp = repmat(tmp,expcond(i),1);
    tmp2 = rem((1:size(tmp,1)),expcond(i))+1;
    tmp2 = sort(tmp2)';
    tmp = horzcat(tmp2, tmp);    
end

condmat = tmp;
% randomize it
randcondmat = Shuffle(condmat,2);

condmat = horzcat((1:trialnum)',condmat);
randcondmat = horzcat((1:trialnum)',randcondmat);

% discard last column
condmat=condmat(:,1:end-1);
randcondmat=randcondmat(:,1:end-1);