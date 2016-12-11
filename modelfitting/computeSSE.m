function [sse, data_predict] =computeSSE(fun,data,scale,params,varargin)
% [sse, data_predict] =computeSSE(fun,data,scale,params,varargin)
% compute SSE for fitting psychophysical data
% Input:
%       fun:function handle, when you define the function, please set parameters as the first input argeument
%           e.p. linear(params,x1,x2...)
%       data: data to fit
%       scale(optional): in which scale the cost function lies, could be 'linear'(default),'log'
%       params: parameters to estimate
%       varargin: input for the fitting funtion
% Output:
%       sse: compute sse
%       data_predict: predicted_data
%
%Example:
% func = @(params,x,y) params(1)*x+y+params(2); % remember the first input is parameters
% params = [1,2];x=0:0.1:10;y=x;  
% data=params(1)*x+y+params(2)+4*(rand(1,numel(x))-0.5);% we add some noise
% [sse,y_predict]=computeSSE(func,data,[],params,x,y);
% figure;myplot(x,data,'o');myplot(x,y_predict);

if(~isa(fun,'function_handle') || isempty(fun))
    error('You must give a function handle');
end
if(~exist('data','var') || isempty(data))
    error('please specify params of input data');
end
if(~exist('scale','var') || isempty(scale))
    scale='linear';
end
if(~exist('params','var') || isempty(params))
    error('please specify params of input data');
end
if(~exist('varargin','var') || isempty(varargin))
    error('please specify input for the fitting function');
end


data_predict = feval(fun,params,varargin{:});



if strcmp(scale,'linear')
    sse=sum((data_predict(:)-data(:)).^2)/sum((data(:)-mean(data(:))).^2);
elseif strcmp(scale,'log')
    sse=sum((log(data_predict(:))-log(data(:))).^2)/sum((log(data(:))-mean(data(:))).^2);
elseif strcmp(scale,'log10')
    sse=sum((log10(data_predict)-log10(data(:))).^2)/sum((log10(data(:))-mean(data(:))).^2);
end

end