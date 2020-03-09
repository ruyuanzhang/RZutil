function designMat=createdesignmat(timePoint,stimCond,numTR,condNum)
%designMat=createdm(timePoint,condition,numTr,conditionNumber,)
% create design matrix, output is a sparse double matrix
% Input:
%       timePoint:a vector containing stimulus onset time points,in number of TR;
%       condition: a vector of stimulus conditions correspondg to timePoint vector, the size is the same as timePoint
%           indicating stimulus condition in each timepoint;
%       numTr:number of total TR in this run
%   optional:
%       condNum: how many unique stimulus condition in this run
% Output:
%       designMat: obtained design Matrix, in sparse matrix mode;
%
% example:
%   timePoint= 1:4:100;
%   stimCond = 1:numel(timePoint);
%   designMat = createdm(timePoint,stimCond,numTR);
%   figure;imagesc(designMat);colormap(gray);

if ~exist('timePoint','var')||isempty(timePoint)
    error('Please input the stimulus onset time');
end
if ~exist('stimCond','var')||isempty(stimCond)
    error('Please input the stimulus condition vector');
end
if ~exist('numTR','var')||isempty(numTR)
    error('Please input total number of TR in this run');
end
if ~exist('condNum','var')||isempty(condNum)
    condNum=numel(unique(stimCond));
end

if condNum~=numel(unique(stimCond))
    error('Your input conditio Number seems incorrect, double check!');
end


%dealing with blanktrials
tmp=stimCond;
if any(stimCond==0)
    tmp(stimCond==0)=condNum;
end

designMat = zeros(numTR,condNum);
ind=sub2ind(size(designMat),timePoint,tmp);
designMat(ind)=1;

if any(stimCond==0)
    designMat = designMat(:,1:end-1);% delete the blank trial condition;
end
designMat = sparse(designMat);

end