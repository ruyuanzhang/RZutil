function designMatrix=createdm(timePoint,stimCond,numTr,condNum)
%designMatrix=createdm(timePoint,condition,numTr,conditionNumber,)
% create design matrix, output is a sparse matrix
% Input:
%       timePoint:a vector containing stimulus onset time points,secs;
%       condition: a vector of stimulus conditions;
%       numTr:number of total TR in this run
%   optional:
%       conditionNumer: how many unique stimulus condition in this run
% Output:
%       designMatrix: obtained design Matrix, in sparse matrix mode;
%
% example:
%   timePoint= 1:4:100;
%   stimCond = 1:numel(timePoint);
%   designMatrix = createdm(timePoint,stimCond,50);
%   figure;imagesc(designMatrix);colormap(gray);

if ~exist('timePoint','var')||isempty(timePoint)
    error('Please input the stimulus onset time');
end
if ~exist('stimCond','var')||isempty(stimCond)
    error('Please input the stimulus condition vector');
end
if ~exist('numTr','var')||isempty(numTr)
    error('Please input the total TR in this run');
end
if ~exist('condNum','var')||isempty(condNum)
    condNum = numel(unique(stimCond));
end



designMatrix = sparse(timePoint,stimCond,ones(size(stimCond)),numTr,condNum,numTr);




end