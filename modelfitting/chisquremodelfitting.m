function [x2,df] = chisquremodelfitting(data,predicted_data)
% function [x2,df] = chisquremodelfitting()
% Compute chi squre value based on input data
% Input:
%   data: a m * n matrix, where m is the number of conditions,n is number
%       of total subjects or samples.
%   predicted_data: a m * n matrix, where m is the number of conditions,n is number
%       of total subjects or samples
% Output:
%   x2: chi squre value
%   df: degree of freedom

if (~exist('data','var')||isempty(data))
    error('Please input the data matrix');
end

% Here we use the function below
%   x2 = sum ((predicted_data - data)^2/varaince);
% predicted_data is the output of the model, data is the real data,
% varaince is the across subjects variance at that condition
x2 = sum((mean(predicted_data,2) - mean(data,2)).^2./var(data,2));
df = 0;