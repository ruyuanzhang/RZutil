function funoutput=gaussianresamplebootstrp(nboot,fun,input)
%% resample data based on mean and standard deviation and compute bootstrap intervals.
% Input:
%   nboot: how many bootstrap samples
%   fun: function handle you want to compute
%   input: input of the function. Input is the 2*input number matrix. The
%           first row is the mean values of input for function, second row
%           is std for these input.
%Output:
%   funoutput: nboot samples of output of the function,sort by ascending
%   way
%
% Note:
%       1. We sample from gaussian distribution from input here.
%   
% Example:
% const=@(x,y) (x-y)/(x+y);
% funoutput=resamplebootstp(1000,const,[1 1;0.2 0.2]);


% Output

if(~exist('nboot','var') || isempty(nboot))
    nboot=1000;
end
if(~isa(fun,'function_handle') || isempty(fun))
    error('You must give a function handle');
end
if(~exist('input','var') || isempty(input))
    error('Please input the rows of those subplot');
end

%% get the input
input_tmp=zeros(nboot,size(input,2));
for i=1:size(input,2)
    input_tmp(:,i)=input(1,i)+input(2,i)*randn(nboot,1);
end


output=zeros(1,nboot);
parfor p=1:nboot
    output(p)=feval(fun,input_tmp(p,:));
end

output = sort(output,'ascend');
funoutput = output;


end