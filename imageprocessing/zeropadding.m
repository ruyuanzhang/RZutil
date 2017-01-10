function im=zeropadding(im,d)
% function im=zeropadding(im,d)
% Input:
%   im: input 1*N 1D signal, 2D image or 3D images
%   d: padding distance
% Output: im could be
%       1D signal, with length as length(im)+2*d 
%       2D image, with size(im,1)+2*d x size(im,2)+2*d
%       3D images, with size(im,1)+2*d x size(im,2)+2*d x size(im,3);
% 
% Example:
%   figure; im = rand(50,50);
%   subplot(1,2,1);imagesc(im);
%   subplot(1,2,2);imagesc(zeropadding(im,20));
if ~exist('im','var')||isempty(im)
    error('Please input signal or image');
end
if ~exist('im','var')||isempty(im)
    d = 0;% default is no padding
end

if any(size(im)==1) % 1D signal
    im = flatten(im);
    im = horzcat(zeros(1,d),im,zeros(1,d));
elseif ~any(size(im)==1)&&(numel(size(im))==2) %2D signal
    assert(size(im,1)==size(im,2),'We assume image should be square!');
    im = horzcat(zeros(size(im,1),d),im,zeros(size(im,1),d)); % add zero in horizontal direction;
    im = vertcat(zeros(d,size(im,2)),im,zeros(d,size(im,2))); % add zero in horizontal direction;
elseif numel(size(im))==3 % 3D images
    assert(size(im,1)==size(im,2),'We assume image should be square!');
    tmp = zeros(size(im,1)+2*d,size(im,2)+2*d,size(im,3));
    tmp(d+1:d+size(im,1),d+1:d+size(im,2),:)=im;
    im =tmp;
else
    error('input should be 1D signal, 2D image or 3D images');    
end