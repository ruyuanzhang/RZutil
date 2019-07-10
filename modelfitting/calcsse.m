function [sse,r2] = calcsse(data,data_predict,scale)
% function [sse,r2] = calcsse(data,data_predict)
%
% compute SSE for fitting psychophysical data
%
% Input:
%       data: a matrix,data to fit
%       perdict_data: a matrix,predicted_data
%       scale(optional): at which scale compute data
%               0(default): linear
%               1:log, transform both data and data_predict into log space
%                   then compute sse
%
% Output:
%       sse: the sse.
%
if(~exist('data','var') || isempty(data))
    error('please specify params of input data');
end
if(~exist('data_predict','var') || isempty(data_predict))
    error('please provide predicted_data');
end
if(~exist('scale','var') || isempty(scale))
    scale = 0;% default is linear
end

%%check input
assert(all(size(data)==size(data_predict)),'emprical data and predicted data should be same size!');

%% change scale
if scale
    % we will perform log transform, make sure all data > 0 
    assert(all(flatten(data)>0),'log scale, make sure input all data element > 0');
    assert(all(flatten(data_predict)>0),'log scale, make sure all input data element > 0');
    data = log(data);
    data_predict = log(data_predict);
end

%% do it

sse=sum((data_predict(:)-data(:)).^2)/sum((data(:)-mean(data(:))).^2);

r2=1-sse;
