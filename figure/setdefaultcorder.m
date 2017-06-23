function setdefaultcorder(cmap)
% function setdefaultcorder(cmap)
%
% set default colormap, 
% Input:
% cmap: character, input colormap, You can use 
% parula,jet,hsv,hot,cool,spring,summer,autumn,winter,gray,bone,copper,pink,lines,colorcube,prism,flag,white
% 
% Example:
%   setdefaultcorder;
%   setdefaultcorder(parula(5));
%   figure;setdefaultcorder(parula(5));myplot(rand(3,4));
%
if (~exist('cmap','var')||isempty(cmap))
    set(groot,'defaultAxesColorOrder',mycolororder('color'));
else
    set(groot,'defaultAxesColorOrder',cmap);
end
