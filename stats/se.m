function outputse = se(x)
% function outputse = se(x)
%
% compute standard error of a samples in a vector, we rely on std.m function in
% matlab, 
%
% Input:
%   x: input vector, either row or a column
% 
% Output:
%   outputse: a scalar, compute se
% 
% Note:
%   1. We assume to compute standard error by normalize sample number N, not N-1
%   2. We deliberately remove nan 
if ~exist('x','var')||isempty(x)
    error('Please input a vector!')
end

x = x(~isnan(x)); % remove nan

if isempty(x)
    error('Please input a valid vector, notice nan value')
else
    outputse = std(x)/sqrt(numel(x));
end
