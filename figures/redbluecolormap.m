function cmap = redbluecolormap(numColors)
% function cmap = redbluecolormap(numColors)
% make red blue colorbar, colorbar can be handlely adjust if output
% colorbar is not satified.
% 
% Input:
%   numColors: how many color levels, default,65
% 
% Output:
%   cmap: a numColors x 3 matrix;
%

if ~exist('numColors','var')
  numColors=65;
  assert(rem(numColors,2)==1,'Color number should be odd!');
end
cmap=[0 0 1;
    1 1 1;
    1 0 0;];
cmap =colorinterpolate(cmap,numColors,1);