function [f,g,xx,sd] = makegabor1d(res,c,cpfov,phase,bandwidth,xx,thresh)
%function [f,g,xx,sd] = makegabor1d(res,c,cpfov,phase,bandwidth,xx,thresh)
% Input:
%   res: number of pixel
%   c: is the center pixel with the peak of the Gaussain envelope (can be a decimal)
%   cpfov: is the number of cycles per field of view
%   phase: is the phase in [0, 2*pi)
%   bandwidth is :
%       +A where A is the number of cycles per 4 std dev of the Gaussian
%           evenlope
%       -B where B is the spatial frequency bandwidth in octave units (FWHM of amplitude spectrum)
%   xx(optional): speed-ups depends on res
%   thresh(optional): threshold to crop,default:0, we crop gabor with
%           pixels < threshold;
% Output:
%   f: 1D gabor signal
%   g: gaussain kernal
%   xx: coordiante
%   sd: sd in pixels
%
%Example:
% figure; imagesc(makegabor1d(32,[],4,0,-1,[],0.01),[-1 1]);
%
% here's an example to check the -B bandwidth case:
% a = makegabor1d(101,[],[],10,pi/2,0,-1);
% b = fftshift(abs(fft(a)));
% figure; plot(log2(1:50),b(51,52:end),'ro-');

%% dealing with input
if ~exist('res','var')||isempty(res)
    res = 100;
end
if ~exist('c','var')||isempty(c)
    c = (1+res)/2;
end
if ~exist('cpfov','var')||isempty(cpfov)
    cpfov = 5;
end
if ~exist('phase','var')||isempty(phase)
    phase = 0;
end
if ~exist('bandwidth','var')||isempty(bandwidth)
    bandwidth = -1;
    assert(numel(bandwidth)==1,'Accept only one value for bandwidth');
end
if ~exist('xx','var')||isempty(xx)
    xx=linspacepixels(-.5,.5,res);
end
if ~exist('thresh','var')||isempty(thresh)
    thresh = 0;
end

% convert to the unit coordinate frame
c = normalizerange(c,-.5,.5,.5,res+.5,0,0,1);

% calculate sd based on bandwidth
if bandwidth(1) > 0
  sd = (bandwidth(1)/cpfov)/4;  % first convert bandwidth to an absolute distance, then the sd is simply one-fourth of this
else
  sd = sqrt(1/(4*pi^2*((2^(-bandwidth(1))*cpfov-cpfov)/(sqrt(2*log(2))+2^(-bandwidth(1))*sqrt(2*log(2))))^2));  % derivation is ugly.
end


% do it

g = exp( ((xx-c).^2)/-(2*sd^2));
grating = cos(2*pi*cpfov*(-(xx-c)) + phase);
f = g .* grating;
    % the idea here is based on what we said in makegrating2d.m.
    % we want to first rotate the grating CCW and then translate to (<c>,<r>).
    % so, to figure out the values for a given grating, we undo the translation,
    % rotate CW, and then sample from the "base" case.

%
assert(thresh>=0,'Please input a threshold >=0');
if thresh > 0 % we crop the filter if threshold is set
   bad = g < thresh; % find where the Gaussian mask falls below the threshold
   if thresh > 0
       f(bad) = 0;
       g(bad) = 0;
   end
   % crop Gabor and Gaussian
   goodpixels = find(~bad);
   g=g(goodpixels);
   f=f(goodpixels);
end
    
% export
sd = sd*res;
