function [sample,ind]=bootresamplemulti(x,nboot)
% function [sample,ind]=bootresamplemulti(x,nboot)
% resample an vector for bootstrap. We assume input is a long vertical
% vector,then we generate nboot columes as the result. remember. this
% is sample with replacement.
%   
% Input:
%   x: a matrix,can be a cell
%   nboot: how many samples we want,default is 1;
% Output:
%   sample:a length(x) X nboot matrix, each column is a sample
%   ind: length(x) X nboot matrix, each columen is a sample. value is the
%       index in original input
% Note: 
%   1. it assumes sample with replacement
%   2. cell case is OK
% 
% Example:
% [sample,ind]=bootresamplemulti(rand(10,1),500);
% isequal(size(sample),[10,500])

if ~exist('x','var')||isempty(x)
    error('Please input an array or a cell vector to resample');
end
if ~exist('nboot','var')||isempty(nboot)
    nboot = 1000; %default,we resample once
end
% check stimulus
vflatten(x); % wright input into a vertical vector

ind = ceil(rand(numel(x),nboot)*numel(x));
sample = x(ind); % now each column is a bootstrap sample, we have nboot columns. 

%consider to reshape this result outside function to recover as the
%original x format
