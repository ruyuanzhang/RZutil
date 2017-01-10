function output = fitnonlinearmodel_rz(data,model,modelinput,init,varargin)
% function output = fitnonlinearmodel_rz(data,model,modelinput,init,varargin)
%
% a simple wrapper fminsearch function for model fitting
% Input:
%   <positional argument>
%       data: fitted data, can be
%       model: constructed model outside of this function. Any function or
%           model with multiple input argument can be rewritten as a
%           generally two input, e.g. model(p,input).p is the parameter
%           array,input is a cell array that include all other argument.
%           check example below
%       modelinput: model input mentioned above
%       init: a vector that set as the initial value for parameters
%   <parameter argument>, this function can also be provide some other
%   parameter argument, write format like, 'bound',[-inf,-inf;inf,inf];
%       metric:metric function to minimize,could be
%               @calcleastsquare (default): minimize least square
%               @calcsse : minimize sse
%               @calccorrelation : maximize correlation
%               

% history
%   1. implement multiple random initial values
%   2. implement bootstrap and across validation
%   12/24/2016. Ruyuan Zhang 
% 


%% deal with input
p=myinputParser;
addRequired(p,'data', @(x) validateattributes(x,{'numeric','cell'},{'nonempty'},1));
addRequired(p,'model', @(x) validateattributes(x,{'function_handle'},{'nonempty'},2));
addRequired(p,'modelinput', @(x) validateattributes(x,{'numeric','cell'},{'nonempty'},3));
addRequired(p,'init',@(x) validateattributes(x,{'numeric'},{'nonempty'},4));

defaultMetric = @calcleastsquare;
defaultLB = repmat(-inf,1,size(init,2));
defaultUB = repmat(inf,1,size(init,2));
defaultOpt = optimset('MaxFunEvals',6000,...
                        'MaxIter',4000,...
                        'FunValCheck','on');
defaultScale='linear';

addParameter(p,'metric',defaultMetric,@(x) validateattributes(x,{'function_handle'},{'nonempty'}));
addParameter(p,'opt',defaultOpt,@iscell);
addParameter(p,'LB',defaultLB, @(x) validateattributes(x,{'numeric'},{'nonempty'}));
addParameter(p,'UB',defaultUB, @(x) validateattributes(x,{'numeric'},{'nonempty'}));
addParameter(p,'scale',defaultScale, @(x) validateattributes(x,{'char'},{'nonempty'}));
addParameter(p,'multiinit',defaultMetric,@(x) validateattributes(x,{'function_handle'},{'nonempty'}));
parse(p,data,model,modelinput,init,varargin{:});

%% read in input
input=p.Results;

% deal with metric
metric = input.metric;
scale  = input.scale;
if isequal(model,@calcsse)
    assert(numel(sse),'only fit 1 data point, cannot calculate sse');        
elseif isequal(model,@calcsse)
        metric = 1-@calcorrelation; % maxima correlation is equivelant minimize it
end

% deal with model and model input
model = input.model;
modelinput = input.modelinput;

%% construct costfun, cost function is the object function which we want to minize.
switch scale
    case 'linear'
        costfun = @(p) metric(data,model(p,modelinput));    
    case 'log'
        assert(all(flatten(data)>0),'log scale, make sure all data > 0');
        costfun = @(p) metric(log(data),log(model(p,modelinput)));    
end
%% do the fitting
LB = input.LB;
UB = input.UB;
init = input.init;
options = input.opt;

% here we use fminsearchbnd as our main optimize function
[x,fval,exitflag,output]=fminsearchbnd(costfun,init,LB,UB,options);

% save some output
output.paramsfit = x;
output.fval = fval;
output.exitflag = exitflag;
output.data = data;
output.modelinput=modelinput;
output.model=model;
output.metric=metric;
output.costfun=costfun;
output.init = init;
output.scale = scale;

output.predictdata=model(x,modelinput);
% compute other metric and save
if numel(output.predictdata)>1
    
    switch scale
        case 'linear'
            output.R2 = 1 - calcsse(data,output.predictdata);
            output.corr= calccorrelation(data,output.predictdata);
        case 'log'
            output.R2 = 1 - calcsse(data,output.predictdata,1);
            output.corr= calccorrelation(log(data),log(output.predictdata));
    end
else
    % only 1 data point and predict data, not need to caculate R2 and
    % correlations
    output.R2 = [];
    output.corr = [];
end



