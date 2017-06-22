function likeli=prob2likeli(prob)
% function prob2likeli(prob)
% Transform probility (0~1) to POSITIVE loglikelihood.
%
% Input:
%   prob: a scalar or a vector
% Output:
%   likeli: a scalar or a vector of positive likelihood

if ~exist('prob','var')||isemptu(prob)||any(prob<0)||any(prob>1)
    error('Please input probability (0~1)');
end

likeli = -log(prob);




end