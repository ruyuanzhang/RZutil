function filename = getfilenamefromfullpath(fullpath,wantext)
% function str = getfilenamefromfullpath(fullpath)
% extract filename from a full path string
%
% Input:
%   fullpath: like /home/stone-ext1/fmridata/lh.mat;
%   wantext: 0,do not include file extension (default)
%               1, keep extension
% Output:
%   filename, 'lh' or 'lh.mat';

if ~exist('fullpath','var')||isempty(fullpath)
    error('Please input the full path, like /homt/stone-ext1/xx.mat');
end
if ~exist('wantext','var')||isempty(wantext)
    wantext = 0; %default with no text;
end

[~,filename,ext] = fileparts(fullpath);

if wantext ==1
    filename = strcat(filename,ext);
end


