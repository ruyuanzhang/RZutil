function [images, r, theta]=creatediskcheckerboard(dim, nWedge, nRing)
% Create circular checkboard images to be used as wedge and ring. Wedge and
% ring stimuli can be made simply by applying mask onto it. Note that the
% output <images> are [-1, 1]. You should convert it to uint8 by:
%                       uint8(images*127+127)
%
% Input:
%   <dim>: in pixels, stimulus dimension [dim, dim]. default(100);
%   <nRing>: how many eccentricity levels from foveal to peripheral
%   <nWedge>: how many wedge levels from [-pi, pi];
%
% Output:
%   <images>: a 1x2 cell, two images with counter-phase polarity
%   <r>,<theta>: polar coordinates, can be used to create wedge and ring
%   mask
%
% Example:
%   [images, r, theta] = creatediskcheckerboard(1000, 10, 16);
%   mask = (r < 50 & r > 30);
%   ring = uint8(images{1}.*mask * 127 + 127);
%   imshow(ring);

if notDefined('dim')
    dim = 768; % default 768 pixels
end
if notDefined('nRing')
    nRing = 10;
end
if notDefined('nWedge')
    nWedge = 16;
end

% 
[x, y] = meshgrid(-dim/2:dim/2-1, -dim/2:dim/2-1);
% cartesian coordinate

% translate to polar coordinate
theta = atan2(y, x); % theta range [-pi, pi]
r = sqrt(x.^2 + y.^2);
mask1 = 2*round((sin(theta * nWedge/2)+1)/2)-1; % mask1 [0, 1]


% deal with eccentricity
r0 = linspace(1, dim/2, nRing+1);
mask2 = (r < r0(1));
mask3 = mask2;
for i = 2:length(r0)
    mask2 = mask2 + (2*mod(i, 2) - 1) * (r >= r0(i-1) & r < r0(i));
    mask3 = mask3 - (2*mod(i, 2) - 1) * (r >= r0(i-1) & r < r0(i));
end
mask4 = mask1.*mask2;
mask5 = mask1.*mask3;

images = {mask4, mask5};


end



