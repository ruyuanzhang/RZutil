function [az,el]=swapaxes(ax)
% function swapaxes(ax)
% In a 2-D plot, swap the x,y axes so that x axes goes vertical and y axes
% goes horizontal
% Input:
%   ax: axes handle you want to swap
% Output:
%   az
%   

if ~ishandle(ax)||isempty(ax)
    ax=gca; %default is current axes handle
end

view(ax,-90,90);
set(ax,'ydir','reverse');
set(ax,'xdir','reverse');
