%This function is to plot a grouped bar figure with much easier efforts.And
%I did a lot of optimization for overal controlling of the figure
%properties.The key feature of this plot is to combine bar and errorbar
%function and align the location of error bar to the grouped bars 
%
%  USAGE; 
%       [Hb,He,ax]= mybar(x,y,E)
%       [Hb,He,ax]= mybar([],y,E)
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
%      matrix



function [Hb,He,ax]= mybar(x,y,E)

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


set(groot,'defaultBarFaceColor',[0 0 0]);
set(groot,'defaultErrorBarLineStyle','none');
set(groot,'defaultErrorBarColor',[0 0 0]);
set(groot,'defaultErrorBarLineWidth',2);


set(groot,'defaultAxesFontSize',15);
set(groot,'defaultAxesFontName','Arial');
set(groot,'defaultAxesFontWeight','Bold');
set(groot,'defaultAxesColor','none'); %set the background of plot area
set(groot,'defaultAxesLineWidth',2);

%
%fig=figure;
if isempty(x)
    Hb = bar(y'); hold on;
else
    Hb = bar(x',y'); hold on;
end


xLoc_bar = Hb(1,1).XData;

%now compute the x location of each error bar 
numbars = size(y,1); 
groupwidth = min(0.8, numbars/(numbars+1.5));


for i = 1:numbars
      % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
      xLoc_errorbar(i,:) = xLoc_bar  - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
      %errorbar(x, model_series(:,i), model_error(:,i), 'k', 'linestyle', 'none');
end

He = errorbar(xLoc_errorbar',y',E'); hold on;

set(gca,'Box','off');
ax=gca;


