function output = fitnonlinearmodel_rz(input)
% function output = fitnonlinearmodel_rz(data,model,modelinput,init,varargin)
%
% a simple wrapper fminsearch function for model fitting
% Input: Input is a structure with fields as below
%   <positional argument>
%       data: data to fit, typically a time x voxels, response (beta,time series)
%       model: the model function which only accept a 1xP parameter and a input, @model(p,num);     
%       modelinput: model input mentioned above, e.g. stimulus
%       init: a 1xP vector that set as the initial value for parameters
%   <optional argument>, this function can also be provide some other
%   parameter argument, write format like, 'bound',[-inf,-inf;inf,inf];
%       metric:metric function to minimize,could be
%               @calcleastsquare (default): minimize least square
%               @calcsse : minimize sse
%               @calccorrelation : maximize correlation
%               @calcord: similar to calcsse,proportion of variance, maximize
%       optimoption: optimization options.
%       LB: a 1xP vector, low bound during optimization,default:-1e6
%       UB: a 1xP vector, up bound during optimization, default:1e6
%       scale: 'linear'(default) or 'log', on which scale we perform
%           optimization, sometimes we want to optimization in log scale,
%           e.g. contrast response function
%       multiinit: a scalar indicating how many random initial values.
%           Providing a >1 number will overwrite the init. But init is a
%           NxP matrix, then multinit will be discard. To generate
%           multiple p0, basically uniformly draw a sample between LB and
%           UB, in this case, LB and UB should not include [],NaN or
%           Inf/-Inf
%       
%               

% history
%   1. implement multiple random initial values
%   2. implement bootstrap and across validation
%   02/14/2017. update calcord metric, this is a function written by KK
%   12/24/2016. Ruyuan Zhang 
% 


%% deal with input
p=myinputParser;
% some key parameters, 
addParameter(p,'data',[], @(x) validateattributes(x,{'numeric','cell'},{'nonempty'}));
addParameter(p,'modelinput',[], @(x) validateattributes(x,{'numeric','cell'},{'nonempty'}));
addParameter(p,'model',[], @(x) validateattributes(x,{'function_handle'},{'nonempty'}));
addParameter(p,'init',[], @(x) validateattributes(x,{'numeric'},{'nonempty'})); % must provide a initial guess

%
defaultMetric = @calcsse;
defaultLB = -inf(1,size(input.init,2));
defaultUB = inf(1,size(input.init,2));
defaultOpt = optimset(getoptimizeopt('fminsearch'),'MaxFunEvals',1000,...
                        'MaxIter',500,...
                        'FunValCheck','on',...
                        'Display','final');
defaultScale='linear';


addParameter(p,'metric',defaultMetric,@(x) validateattributes(x,{'function_handle'},{'nonempty'}));
addParameter(p,'opt',defaultOpt,@iscell);
addParameter(p,'LB',defaultLB, @(x) validateattributes(x,{'numeric'},{'nonempty'}));
addParameter(p,'UB',defaultUB, @(x) validateattributes(x,{'numeric'},{'nonempty'}));
addParameter(p,'scale',defaultScale, @(x) validateattributes(x,{'char'},{'nonempty'}));
addParameter(p,'multiinit',defaultMetric,@(x) validateattributes(x,{'function_handle'},{'nonempty'}));
parse(p,input);
input=p.Results; % obtain parsed input
%% read in input

% deal with metric
metric = input.metric;
scale  = input.scale;
data = input.data;
if isequal(metric,@calcsse)
        assert(numel(input.data)>1,'only fit 1 data point, cannot calculate sse');        
elseif ismember(metric,{@calccorrelation,@calccod})
        metric = @() 1-metric; % maxima correlation is equivelant minimize error
        % here has some problem.. need to fix;
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



