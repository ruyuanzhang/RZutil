
function [Hb,He,ax]= mybar(x,y,E)
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


for i = 1:numbars
      % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
      xLoc_errorbar(i,:) = xLoc_bar  - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar     
end

if ~isempty(E)
    for i=1:numbars
        if numel(E)==numel(y) %single error value
            He = errorbar(xLoc_errorbar',y',E'); hold on;
        elseif numel(E)==2*numel(y) % up and low error value
            He = errorbar(xLoc_errorbar',y',E(:,:,1)',E(:,:,2)'); hold on;
        end
    end
else
    He=[];
end

set(He,'LineStyle','none');%for unix
set(He,'Color',[0 0 0]);%for unix

set(gca,'Box','off');
ax=gca;


