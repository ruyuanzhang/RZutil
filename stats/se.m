function outputse = se(x,dim)
% function outputse = se(x,dim)
%
% compute standard error of a samples in a vector, we rely on std.m function in
% matlab. For nan values, we use nanstd to ignore it.
%
% Input:
%   x: matrix
%   dim: which dimension want to take compute se.
% 
% Output:
%   outputse: standard error
% 
% Note:
%   1. We assume to compute standard error by normalize sample number N, not N-1


if ~exist('x','var')||isempty(x)
    error('Please give an input!')
end
if ~exist('dim','var')||isempty(dim)
    dim = 1;
end

if iscolumn(x) || isrow(x)
    x = vflatten(x); % make it all column vector
end

if any(isnan(x))
    error('Please deal with nan values in your data');
else
    outputse = nanstd(x,[],dim)/sqrt(size(x,dim)); 
    % denominator count nan
end



