function h = cpsfigure(row,col,ratio)
%function h = cpsFigure(widthscale, heightscale,ratio)
%
% Scale the figure size according number of subplots
%
% Input:
%   row,col: row number and col number of subplots
%   ratio(optional):overal ratio of the figure after scaling by row and
%           col,default is 1.
% Ouput:
%   h: figure handle 
% 
% Example:
% cpsfigure(1,2);
% subplot(1,2,1),myplot(rand(1,10));
% subplot(1,2,1),myplot(rand(1,10));

if ~exist('row','var')||isempty(row)
    error('Please input how many rows you want');
end
if ~exist('col','var')||isempty(col)
    error('Please input how many columes you want');
end
if ~exist('ration','var')||isempty(ratio)
    ratio = 1;
end

h = figure;
Position = get(h,'Position');
Position(4) = row*Position(4)*ratio;
Position(3) = col*Position(3)*ratio;
set(h,'Position', Position)