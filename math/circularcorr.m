function circ_r = circularcorr(x, y)

% function f = calccorrelation(x,y,dim,wantmeansubtract,wantgainsensitive)
%
% <x>,<y> are vectors

% Note:
%   1. cautious about the NAN, empty, dealwith later
x = x(:);
y = y(:);

% handle weird case up front
if isempty(x)
  circ_r = [];
  return;
end

% propagate NaNs (i.e. ignore invalid data points)
x(isnan(y)) = NaN;
y(isnan(x)) = NaN;

circ_r = sum(sin(x-circularmean(x)).*sin(y-circularmean(y)))/sqrt(sum(sin(x-circularmean(x)).^2)*sum(sin(y-circularmean(y)).^2));



