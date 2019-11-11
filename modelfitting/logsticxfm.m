function y=logsticxfm(x,a,b, beta)

% This is useful during model fitting that can transform a value between [-inf, inf]
% to range (a,b). We can convert to the problem of searching for a
% parameter between (a,b) to (-inf, inf), so as to avoid the boundary
% problem

% <x>: value between [-inf, inf];
% <a>,<b>: lower and upper limit of the range, can be inf. For example, [0, inf]
% <beta>: inverse temperature parameter for the logistic function 

if isreal(a) && isreal(b)
    y = (b-a)*sigmf(x,[beta 0]) + a;
elseif a == -inf && isreal(b)
    y = b-exp(x);
elseif isreal(a) && b == inf
    y = exp(x) + a;
else
    error('wrong input range');
    
end


