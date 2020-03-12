function result = rzcellfun(varargin)
% Just a quick wrap for cellfun and so no need to input 'UniformOutput',
% false repeatly

result = cellfun(varargin{:}, 'UniformOutput', 0);