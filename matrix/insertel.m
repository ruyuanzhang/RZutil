function new_vector=insertel(a,b,index)
%insert some elements into a vector
% Inputs
%       a:      original vector
%       b:      a scalr or a vector, elements being inserted
%       index:  index of new elements in the new vector
% Output
%       new_a : new vector, length(new_a) =length*(a)+length(b)
%
%Example
% a = rand(1,5);b=rand(1,3);c=insertel(a,b,[1 3 4]);
% display(a);display(b);display(c)


if ~exist('a','var')||isempty('a')
    error('please input original vector');
end

if ~exist('b','var')||isempty('b')
    error('please input the elements to be inserted');
end

if ~exist('index','var')||isempty('index')
    error('please input the index of new elements');
end


new_vector = ones(1,numel(a)+numel(b));
new_vector(index)=0;
new_vector(new_vector==1)=a;
new_vector(index)=b;

end