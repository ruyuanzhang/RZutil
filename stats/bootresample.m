function sample=bootresample(x)
% function sample=bootresample(x)
% resample an array or from a matrix for bootstrap

if ~exist('x','var')||isempty(x)
    error('Please input an array or a cell vector to resample');
end


ind=ceil(rand(1,numel(x(:)))*numel(x(:)));
sample=x(ind);
sample=reshape(sample,size(x));    
end