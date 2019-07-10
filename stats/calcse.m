function output = calcse(x)
% function output = calcse(x)
%
% compute the standard error given the vector x
%
% Input:
%   x: a vector, can have nan, we use nanstd function. We explicitly reject
%       matrix input
% Output:
%   output:standard error of x
% Note:
%   We just ignore the nan value   
%
% Example:
% calcse(rand(1,10));
%

if ~exist('x','var')||isempty(x)
    error('Please input a vector');
end

% this should not be a matrix
tmp = size(x);
assert(length(tmp)<=3,'Input vector should not be above 2 dimension'); % should not
assert(any(tmp(1:2)==1),'you can only input a vector not a matrix');

if any(isnan(x))
    output = nanstd(x)/sqrt(length(x(~isnan(x))));
else
    output = std(x)/sqrt(length(x));
end