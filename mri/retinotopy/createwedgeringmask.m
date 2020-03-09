function masks=createwedgeringmask(dim, nWedge, nRing)
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
%   <masks>: 1x2 cell with {wedgeMasks, ringMasks}. The 'wedgeMasks' is a
%   3D matrix with size [dim dim nWedge], Similar to 'ringMasks'.


if notDefined('dim')
    dim = 768; % default 768 pixels
end
if notDefined('nRing')
    nRing = 8;
end
if notDefined('nWedge')
    nWedge = 8;
end

%% 
[x, y] = meshgrid(-dim/2:dim/2-1, -dim/2:dim/2-1);
% cartesian coordinate

% translate to polar coordinate
theta = atan2(y, x); % theta range [-pi, pi]
r = sqrt(x.^2 + y.^2);

%% Ring Masks
ringMasks = zeros(dim, dim, nRing);
r0 = linspace(1, dim/2, nRing+1);
for i=2:nRing+1
    ringMasks(:,:,i-1) = (r<=r0(i) & r>r0(i-1));
end

%% Wedge Masks
dTheta = 2*pi/nWedge;
wedgeMasks = zeros(dim, dim, nWedge);
theta0 = linspace(-pi/2-dTheta/2, pi+pi/2-dTheta/2, nWedge+1);
theta0 = wrapToPi(theta0);
for i=2:nWedge+1
    if theta0(i)-theta0(i-1) > 0 % no wrap
        wedgeMasks(:,:,i-1) = (theta<=theta0(i) & theta > theta0(i-1) & r < dim/2);
    else
        wedgeMasks(:,:,i-1) = (theta<=theta0(i) | theta > theta0(i-1)) & (r < dim/2);
    end
end

masks = {wedgeMasks, ringMasks};

end



