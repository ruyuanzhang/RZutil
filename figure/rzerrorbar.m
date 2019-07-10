function f = rzerrorbar(x,y,er,direction,varargin)
% function f = errorbar2(x,y,er,direction,varargin)
%
% RZ's errorbar function, based on errorbar2.m from KK 
%
% <x>,<y>,<er> are ROW vectors of the same length
%   <er> can also be 2 x N where the first row
%   has offset values for the lower bound and the second row has offset values
%   for the upper bound.
% <direction> is
%   0 or 'h' or 'x' means error on x
%   1 or 'v' or 'y' means error on y
% <varargin> are additional arguments to plot.m (e.g. 'r-')
%
% Output
%   errorbar handle
%   
% draws error lines on the current figure, returning
% a vector of handles.
%
% Example:
% figure; rzerrorbar(randn(1,10),randn(1,10),randn(1,10)/4,1,'r-');
% figure; rzerrorbar(randn(1,10),randn(1,10),[randn(1,10);randn(1,10)]/4,1,'r-');
%
% Note: 
%   1. what about the cases of NaNs? we report error if input have nan values
%   2. remember x, y ,er should row vector, can use flatten function.


if ~exist('x','var')||isempty(x)
    error('Please input row vector x');
end
if ~exist('y','var')||isempty(y)
    error('Please input row vector y');
end
if ~exist('er','var')||isempty(er)
    error('Please input row vector y');
end
if ~exist('er','var')||isempty(er)
    direction = 1; % default errorbar in y direction
end

% check data
assert(all(~isnan(flatten(x))),'Input x values without nan!');
assert(all(~isnan(flatten(y))),'Input y values without nan!');
assert(all(~isnan(flatten(er))),'Input error values without nan!');

% hold on
prev = ishold;
hold on;

% prep er
if size(er,1) == 1
    er = repmat(er,2,1);
end

% do it
f = [];
switch direction
    case {0 'h' 'x'}
        for p=1:numel(x)
            f = [f plot([x(p)-er(1,p) x(p)+er(2,p)],[y(p) y(p)],varargin{:})];
        end
    case {1 'v' 'y'}
        for p=1:numel(x)
            f = [f plot([x(p) x(p)],[y(p)-er(1,p) y(p)+er(2,p)],varargin{:})];
        end
    otherwise
        error('invalid <direction>');
end

% hold off
if ~prev
  hold off;
end

% add some setting
set(gca,'box','off');



end

