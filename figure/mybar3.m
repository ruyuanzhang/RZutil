
function [Hb,He,ax]= mybar3(x,y,E)
% function [Hb,He,ax]= mybar3(x,y,E)
% 
% Similar function to mybar.m and mybar2.m, see input and output
% description in mybar.m

% Note:
%   instead, this function uses patch function to draw a errorbar. You can change the color and width of
% errorbar.
%
% Example:
% x=rand(2,4);y=rand(2,4),E=rand(2,4)/3;
% figure;[Hb,He,ax]= mybar([],y,E);
% figure;[Hb,He,ax]= mybar2([],y,E);
% figure;[Hb,He,ax]= mybar3([],y,E);

% dealing with inputs

if nargin < 3||isempty(E)
    E = [];

elseif nargin <2 || isempty(y)
    error('please input the Y value !');
elseif isempty(x)
    x=[];
elseif size(x)~=size(y)
    error('dimentions of x and y do not match!')
end

%
%fig=figure;
if isempty(x)
    Hb = bar(y'); hold on;
else
    Hb = bar(x',y'); hold on;
end


xLoc_bar = get(Hb(1,1),'XData');

%now compute the x location of each error bar 
numbars = size(y,1); 
groupwidth = min(0.8, numbars/(numbars+1.5));
barwidth = get(Hb(1,1),'BarWidth');
errorbarwidth = 1/(numbars+1.5)*barwidth*0.5; % errorbar size is half of the obsolute barwidth;
xLoc_errorbar=zeros(size(y));

for i = 1:numbars
      % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
      xLoc_errorbar(i,:) = xLoc_bar  - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar           
end

%% we use patch to add errorbar
if ~isempty(E)    
    if numel(E)==numel(y) %single error value
        E = repmat(E,[1 1 2]);
    elseif numel(E)==2*numel(y) % up and low error value
        
    else
        error('Your input errorbar is wrong!!')
    end
    %
    % figure each patch width
    vertices_x = zeros(4,numel(y));% x location of vertices, row indicate, upleft/upright/downright/downleft/
    vertices_x(1,:) = flatten(xLoc_errorbar)-errorbarwidth/2;
    vertices_x(2,:) = flatten(xLoc_errorbar)+errorbarwidth/2;
    vertices_x(3,:) = flatten(xLoc_errorbar)+errorbarwidth/2;
    vertices_x(4,:) = flatten(xLoc_errorbar)-errorbarwidth/2;
    vertices_y = zeros(4,numel(y));% x location of vertices
    vertices_y(1,:) = flatten(y)+flatten(E(:,:,1));
    vertices_y(2,:) = flatten(y)+flatten(E(:,:,1));
    vertices_y(3,:) = flatten(y)-flatten(E(:,:,2));
    vertices_y(4,:) = flatten(y)-flatten(E(:,:,2));
    He = patch(vertices_x,vertices_y,'w');
    % some setting
    set(He,'EdgeColor',[0 0 0]);%for unix
    set(He,'FaceColor',[1 1 1]);%for unix
else
    He=[];
end


set(gca,'Box','off');
ax=gca;


