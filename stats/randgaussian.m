function sample = randgaussian(sz,u,sigma)
% function sample = randgaussian(sz,u,sigma)
% just a wrapper of randn.m, get sz samples from a normal distribution with
% mean as u and size as sigma;
%   
% u: mean
% sigma: standard devition
% sz:size of samples
if(~exist('sz','var') || isempty(sz))
    sz=[1 1];
end
if(~exist('u','var') || isempty(u))
    u=0;
end
if(~exist('sigma','var') || isempty(sigma))
    sigma=1;
end

sample=u+sigma*randn(sz);


end