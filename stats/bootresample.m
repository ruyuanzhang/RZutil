function sample=bootresample(x)
% function sample=bootresample(x)
% resample an vector for bootstrap. We assume input is a long vertical
% vector,then we generate 1 columes as the result. remember. this
% is sample with replacement.
%   
% Input:
%   x: a matrix,can be a cell
%   1: how many samples we want,default is 1;
% Output:
% Note: 
%   1. it assumes sample with replacement
%   2. cell case is OK
%   3. do we need to reshape it or reshape outsize to make it faster??
%
% Example:
%  x= rand(10,1);
%  sample = bootresample(x);

if ~exist('x','var')||isempty(x)
    error('Please input an array or a cell vector to resample');
end

% check stimulus
ind=datasample((1:numel(x))',numel(x)); % sample with replacement

sample=x(ind);
sample=reshape(sample,size(x)); % do we need to reshape or we can do this outside...let's keep it for now.
end