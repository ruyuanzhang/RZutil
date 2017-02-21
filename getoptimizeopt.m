function [opt,funname]=getoptimizeopt(funname,varargin)
% function getoptimizeopt()
% Get optimize option
%
% Input:
%   funname: a string,optimization function name, like,
%   'lsqcurvefit'(default),'fminsearch','fmincon'
%   all input are parameters input variable, which means you can set
%   the format like, getoptimizaopt()
%   
% Output: 
%   Output option:
% 

% check input funname
p = myinputParser;
addRequired(p,'funname',@(x) ismember(x, {'lsqcurvefit','fminsearch','fmincon'}));
parse(p,funname);
input = p.Results;


% first get the default optimization
opt = optimset(input.funname);
% add new stuff;
opt = optimset(opt,varargin{:}); 

