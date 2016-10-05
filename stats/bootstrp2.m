function dist=bootstrp2(nboot,bootfun,dim,varargin)
if(~exist('nboot','var') || isempty(nboot))
    nboot=1000;
end
if(~exist('bootfun','var') || isempty(bootfun))
    error('Please input function handel');
end
if(~exist('dim','var') || isempty(dim))
    dim=1;
end
if(~exist('varargin','var') || isempty(varargin))
    error('Please input the input for function');
end

%% first test the size of output
try
    % Get result of bootfun on actual data, force to a row.
    temp = feval(bootfun,varargin{:});
    temp = temp(:)';
catch ME
    m = message('stats:bootstrp:BadBootFun');
    MEboot =  MException(m.Identifier,'%s',getString(m));
    ME = addCause(ME,MEboot);
    rethrow(ME);
end


dist={};
% we use parfor to accelerate
parfor p=1:nboot
    % resample to get an input
    bootvargin=cellfun(@bootresample,varargin,'UniformOutput', false);
    % run function
    dist{p}=feval(bootfun,bootvargin{:});
    
end
dist = catcell(dim,dist);

end
