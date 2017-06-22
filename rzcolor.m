function color = rzcolor(iColor,theme,n)
% function color = rzcolor(iColor,theme,n)
% 
% obtain a color code [r b g], given a color number index in this
% colororder set. You can also provide theme and total number of color.
%
% Input
%   iColor: a scalar color index in the colorlist. default:1. 
%   theme: a string, color theme,current accept,'color',
%       'gray','brightcolor','overcastsky','jet'
%   n: a scalar, levels we want, default is 7, we can create more by color
%       interpolate.
% Output:
%   c0: a n x 3 matrix rgb value
%   
% Example:
% figure;
%   myplot(rand(1,10),rand(1,10),'o');hold on;
%   myplot(rand(1,10),rand(1,10),'o','color',rzc(2));
% figure;
%   myplot(rand(1,10),rand(1,10),'o','color',rzc(1,'gray'));hold on;
%   myplot(rand(1,10),rand(1,10),'o','color',rzc(2,'gray'));
%
if (~exist('iColor','var')||isempty(iColor))
    theme = 'iColor';
end
if (~exist('theme','var')||isempty(theme))
    theme = 'color';
end
if (~exist('n','var')||isempty(n))
    n = 7;
end
assert(iColor<=n,'iColor is larger than total color number, consider input a ')


% obtain the color order list given theme and total color level n
mycolororderlist = mycolororder(theme,n);
% return the color code given index.
color = mycolororderlist(iColor,:);