function sqerror=circularsqerror(s,target, module)
% sqerror=circularsqerror(s,target, module)
%
% <s> is a vector, we get the circular squared error according to a <target>
% and the <module>
% 
if ~exist('s','var')||isempty(s)
    error('Please input s')
end
sqerror = sum(circulardiff(s, target,module).^2);
