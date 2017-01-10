function error = calcleastsquare(x,y)
%function error = calcleastsqure(x,y)
%
% calculate least squre of two arrays.
% Input:
%    x,y: any numerical input
% Output:
%   error: squre sum difference between x, y

%% det
p=myinputParser;
addRequired(p,'x',@isnumeric);
addRequired(p,'y',@isnumeric);
parse(p,x,y);

x=p.Results.x;
y=p.Results.y;

%% check data
assert(isequal(numel(x),numel(y)),'x,y has different number of element');

%% do it
error = sum((flatten(x)-flatten(y)).^2);