function sample = randg(sz,u,sigma)

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