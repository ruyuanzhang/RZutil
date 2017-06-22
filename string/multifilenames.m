function a = multifilenames(rep,n)
% function a = multifilenames(rep,n)
% make multiple filenames, i.e. image01.png, image02.png....
% This is useful to change filenames for multiple files,e.g. You want to
% change image01.png...image10.png to myimage01.png...myimage02.png.
% Consider to use movefile together.
%
% Input:
%   rep:a string wildcard expression,e.g. 'images%02d.png'
%   n: labeled numbers
%      (1) a scaler, i.e. 10, we assume label files from 01-10
%      (2) a vector, i.e. 3-10, we assume label files from 03-10
% Example:
% a = multifilenames('');

if ~exist('rep','var')||isempty(rep)
    error('Please input wildcard expression, i.e. ''image%02d.png'' ');
end
if ~exist('n','var')||isempty(n)
    error('Please input number labels, i.g. 10 or 3:10')
end

if length(n)==1
    n = 1:n;
end


a = {};
for i = 1:length(n)
    a{i} = sprintf(rep,n(i)); 
end

end