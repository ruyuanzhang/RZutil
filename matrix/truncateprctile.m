function v = truncateprctile(v, prcntrange)
% function truncateprctile(v, prcntrange)
% 
% truncate a vector based on <prcntrange>. i.e., return a vector that only keeps the
% element within the percentile range. This is useful for removing some outlier
% 
% <v>: an 1D vector, either row or column
% <prcntrange>: a 2 element vector, range between [0, 100]. Is the percentile
%   range we want to keep. Default:[1 99]
%
%
if ~exist('v','var')||isempty(v)
    error('Please input a vector');
end
if ~exist('prcntrange','var')||isempty(prcntrange)
    prcntrange = [1 99];
end

assert(length(prcntrange)==2,'prnctrange should be a 2 element vector!');
assert(all(prcnrange<=100&prcnrange>=0),'prnctrange should be within [0 100]');

a = prctile(v,prcntrange);
v = v(v>=a(1)&v<=a(2));
return v



