
function [Hb,He,ax]= mybar3(x,y,E)
% function [Hb,He,ax]= mybar3(x,y,E)
% Similar as mybar,mybar2, the only difference is that we use bar function
% to plot errorbar.
%This function is to plot a grouped bar figure with much easier efforts.And
%I did a lot of optimization for overal controlling of the figure
%properties.The key feature of this plot is to combine bar and errorbar
%function and align the location of error bar to the grouped bars 
%___________________________________________________________________________
%  Output
%     Hb: handle of the bar part
%     He: handle of the errorbar part
%     ax: handle of the ax part
%__________________________________________________________________________
%  Input
%     x: x location of each bar, it should be a m (bars) * n (condition)
%      matrix
%     y: bar height values, it should be a m (bars) * n (condition)
%      matrix
%     E: length of error bar,it should be a m (bars) * n (condition)
%      matrix. Or it should a m (bars) * n (condition) * 2 (upper
%      error/lower error) matrix.Notice, if y input is an 1xn array or nx1
%      vector,E should be written as 1xnx2 or nx1x2 format, you can use
%      reshape(E,[1 n 2]) or reshape(E,[n 1 2]);
%   
%
%
%  i.e.
% figure; x=rand(2,4);y=rand(2,4),E=rand(2,4)/3;[Hb,He,ax]= mybar(x,y,E)
%       [Hb,He,ax]= mybar(x,y,E)
%       [Hb,He,ax]= mybar([],y,E)

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
%errorbarwidth = groupwidth/numbars*barwidth*0.5; % errorbar size is half of the obsolute barwidth;
errorbarwidth = barwidth*0.25; % errorbar size is half of the obsolute barwidth;
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


