function [l,label]=addsiglabel(dot1,dot2,siglabel,axs,varargin)
%function [l,label]=addsiglabel(dot1,dot2,siglabel,axs,varargin)
% add horizontal line and significant label "*" or "**" to figure, mostly
% bar figure, it can add a line if compare two condition or simply add a
% sign to single bar
%
% Input:
%       dot1: a scalar or a two-element vector of x data
%       dot2: a scalar or a two-element vector of y data
%   optional:
%       siglabel: '*','**';default is '*'
%       axs: the handle of axes
%       varargin: varables for text object;
% Output:
%       l:line handle
%       label:text handel
%
% Example;
% figure; [b,e,ax]=mybar([],rand(2,10),rand(2,10));
% addsiglabel([e(1).XData(1) e(1).XData(2)],[1.5 1.5],'*');
% addsiglabel([e(1).XData(3) e(1).XData(9)],[1.7 1.7],'**');
%
if ~exist('dot1','var')||isempty(dot1)
    error('Please input the label or line X data');
end
if ~exist('dot2','var')||isempty(dot2)||any(size(dot2)~=size(dot1))
    error('Please input the coorect label or line X data');
end
if ~exist('siglabel','var')||isempty(siglabel)
    siglabel = '*';
end
if ~exist('axs','var')||isempty(axs)
    axs=gca;
end

%% drawline if there are two dots, which means we are comparing two
% conditions
if numel(dot1)>1
    l=line(dot1,dot2,'LineWidth',2,'Color',[0 0 0]);
end

%% add label

spatialoff_x=0;spatialoff_y=0;
if numel(dot1)>1
    if dot1(1)==dot1(2)
        spatialoff_x = range(axs.XLim)*0.01;
    end
    if dot2(1)~=dot2(2)
        spatialoff_y = range(axs.YLim)*0.01;
    end
    label = text(sum(dot1)/2-spatialoff_x,sum(dot2)/2+spatialoff_y,siglabel);
else
    label = text(dot1-spatialoff_x,dot2+spatialoff_y,siglabel);
end



if any(strcmp(siglabel,{'*','**','***'}))
    set(label,'FontSize',25,'HorizontalAlignment','center');
else
    set(label,'FontSize',15,'HorizontalAlignment','center','VerticalAlignment','Bottom');
    
end

if ~isempty(varargin)
    set(label,varargin{:});
end
