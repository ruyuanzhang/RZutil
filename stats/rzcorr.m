function [r,p] = rzcorr(x,y,varargin)
% function [r,p] = rzcorr(x,y,varargin)
%
% a wrapper of the matlab corrcoef.m function, we deliberately remove nan values
%
% Input:
%   x,y: correlation can only be two equal size vectors
%   varargin:see definition in constraits in corrcoef
% Output:
%   r: correlation value:
%   p: p value for significance, default CI is 95%
%
% Note:
%   1. empty responses
if ~exist('x','var')||isempty(x)
    x =[];
end
if ~exist('y','var')||isempty(y)
    y =[];
end

% remove nan
x = x(~isnan(x));
y = y(~isnan(y));

assert(isequal(size(x),size(y)),'x and y should be same size!');

[R,P] = corrcoef(x,y,varargin{:});
r = R(1,2);
p = P(1,2);