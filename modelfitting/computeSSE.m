function [sse, data_predict] =computeSSE(fun,params,data,input,scale)
% compute SSE for fitting psychophysical data


if(~isa(fun,'function_handle') || isempty(fun))
    error('You must give a function handle');
end
if(~exist(params,'var') || isempty(params))
    error('please specify params of input data');
end
if(~exist(data,'var') || isempty(data))
    error('please specify params of input data');
end
if(~exist(input,'var') || isempty(input))
    error('please specify params of input data');
end
if(~exist(scale,'var') || isempty(scale))
    scale='linear';
end

data_predict = feval(fun,params,input);

if strcmp(scale,'linear')
    sse=sum((data_predict(:)-data(:)).^2)/sum((data(:)-mean(data(:))).^2);
elseif strcmp(scale,'log')
    sse=sum((log(data_predict(:))-log(data(:))).^2)/sum((log(data(:))-mean(data(:))).^2);
elseif strcmp(scale,'log10')
    sse=sum((log10(data_predict)-log10(data(:))).^2)/sum((log10(data(:))-mean(data(:))).^2);
end



end