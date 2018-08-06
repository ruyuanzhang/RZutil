function var = circularvar(s, module)
% function circularvar()
%
% calculate the variance of circular variable vector <s>, according to
% <module>. 

if ~exist('s','var')||isempty(s)
    error('Please input s')
end
avg = circularavg(s, module);
var = sum(abs(circulardiff(s, avg)).^2);

