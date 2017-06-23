function f = flatten(m,order)

% function f = flatten(m)
%
% Input:
%   m: is a matrix
%   order:'C','F', default is 'C'
%
% return as a row vector. Order c means to flatten using column-major order,
% which is also the default in matlab. 'F' means to flatten using row-major
% order, which is used in fortran and python.
%
% example:
% a = [1 2; 3 4];
% isequal(flatten(a,'C'),[1 3 2 4])
% isequal(flatten(a,'F'),[1 2 3 4])
if ~exist('order','var')||isempty(order)
    order = 'C'; % default column-major order
end

switch order
    case 'C'
        f = m(:).';
    case 'F'
        f = reshape(m',1,[]);
end

