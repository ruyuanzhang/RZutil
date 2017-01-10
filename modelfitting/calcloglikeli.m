function loglikeli = calcloglikeli(prob)
% function loglikeli = calloglikeli(x)  
%
% Compute loglikelihood of a sequence of psychphysical responses
%
% Input:
%   prob: a scalar or an array of probablity of a sequence of independent
%           events. It usually stands for probability computed from a
%           psychmetric function
%
% Output:
%   loglikeli: loglikelihood value, here we transform to positive, since
%               simply taking log(probablity) will give negative value.in
%               this case, maximal likelihood method is equavalent to
%               minize this function, which is more convenient for
%               optimazation

%% deal with input
if(~exist('prob','var') || isempty(prob))
    error('Please input data, should be n * 2 matrics');
end

%% check data
assert(max(flatten(prob))<=1); % all probility should be within range [0,1]
assert(max(flatten(prob))>=0); % all probility should be within range [0,1]

% do it
loglikeli=-sum(log(prob));
