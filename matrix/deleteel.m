function new_vector=deleteel(a,index)
%delete some elements in a vector
% Inputs
%       a:      original vector
%       index:  index of elements to delete
% Output
%       new_a : new vector, length(new_a) =length*(a)-length(index)
%
%Example
% a = rand(1,5);b=delete(a,[1 3 4]);
% display(a);display(b)


if ~exist('a','var')||isempty('a')
    error('please input original vector');
end

if ~exist('index','var')||isempty('index')
    error('please input the index of new elements');
end


tmp = ones(1,numel(a));
tmp(index)=0;
new_vector=a(tmp==1);


end