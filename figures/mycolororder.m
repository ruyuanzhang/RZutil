function c0=mycolororder(theme,n)
%two different types of color order when making figures
% Input
%   theme: color,current accept,'color','gray','jet'
%   n: levels we want, default is 7, we can create more by color
%       interpolate
% Output:
%   c0: a n x 3 matrix rgb value
%   
% future work: Improve the gray color set, to improve the contrast.
%
if (~exist('theme','var')||isempty(theme))
    theme = 'color';
end
if (~exist('n','var')||isempty(n))
    n = 7;
end

switch theme
    case 'color' % this is default color order since matlab 2014b
        c0=[0    0.4470    0.7410
            0.8500    0.3250    0.0980
            0.9290    0.6940    0.1250
            0.4940    0.1840    0.5560
            0.4660    0.6740    0.1880
            0.3010    0.7450    0.9330
            0.6350    0.0780    0.1840];
        if n > 7
            c0=colorinterpolate(c0,ceil(n/7),2);
        end
            c0=c0(1:n,:);
    case 'brightcolor' % this is default color order for 'bgrcmykw'
        c0=[0    0    1
            0    1    0
            1    0    0
            0    1    1
            1    0    1
            1    1    0
            0    0    0];
        if n > 7
            c0=colorinterpolate(c0,ceil(n/7),1);
        end
        c0=c0(1:n,:);
    case 'overcastsky' % this is default color order for 'bgrcmykw'
        c0=[0,6,35
            40,71,92
            74,108,116
            139,166,147
            240,227,192]/255;
        
        if n > 5
            c0=colorinterpolate(c0,ceil(n/5),1);
        end
        c0=c0(1:n,:);
    case 'gray'
        c0=gray(n);
    case 'jet'
        c0=jet(n);
end


end