function sample=bootresample(x)
%% resample a vector or from a matrix for bootstrap


ind=ceil(rand(1,length(x(:)))*length(x(:)));
sample=x(ind);
sample
sample=reshape(sample,size(x));
    
end