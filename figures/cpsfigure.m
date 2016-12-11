function h = cpsfigure(row,col)
%cpsFigure(widthscale, heightscale)
if ~exist('row','var')||isempty(row)
    error('Please input how many rows you want');
end
if ~exist('col','var')||isempty(col)
    error('Please input how many columes you want');
end

h = figure;
Position = get(h,'Position');
Position(4) = row*Position(4);
Position(3) = col*Position(3);
set(h,'Position', Position)