function [lh, eh] = myplot(x,y,se,varargin)
% function H = myplot(x,y,se,varargin)
%
% plot function by Ruyuan Zhang, just a wrapper of plot.m.
%% Input:
%   x,y: input x,y data, x,y are ROW vectors or matrix. If they are both matrix, then
%       each ROW is a line.
%   se: sebar number, se is a vector or a matrix with same size as
%       x,y. In this case, se is a absolute value, the lower and upper boundary
%       of data should y-se and y+se.
%       or, 
%       it can be with size as [size(x) 2]. The extra dimension
%       specifiy the lower and upper se, which correpond to errorbar2.m
%       or,
%       se can be a two element cell {horzse,vertse} indicate horizontal se and
%       vertical se. Each element should be defined as non cell case
%
%   varargin: other varargins for plot.m
%   
% Output:
%   lh: line (or dot) handle
%   eh: sebar handle
%
% Note:
%   1. We use sebar2.m to plot sebar
%
% Example:
% figure;myplot([],rand())
%   
% History:
%   20170706 RZ implement the vertical and horizontal errorbar,delete the tag
%       function, which seems hard
%   2017/05/03 RZ add sebar function and fix the tag
%   2016/11/11 RZ added tag input option

if ~exist('x','var')||isempty(x)
    x=[];
end
if ~exist('y','var')||isempty(y)
    error('You must input y!');
end
if ~exist('se','var')||isempty(y)
    se=[];
end

%% deal with the input
if isempty(x)
    x = 1:size(y,2); % line length is size(y,2)
end

% figure out line width
% 1D, row
if isrow(x) || iscolumn(x)
    x = flatten(x); % flatten x if it is a column vector, to make sure x are always row vector;
    assert(length(x)==size(y,2),'size of x,y seems incompatible,we plot row of y');
    x = repmat(x,size(y,1),1);% we expand x to be same size with y;
else % in this case both x,y are matrix
    assert(all(size(x)==size(y)),'both x,y are matrix, their size should be same'); 
end
% do it
lh = plot(x',y',varargin{:}); hold on;% we transpose x,y in this case, weird plot function setting in matlab ..
% edit it a little big
set(gca, 'box','off');
set(lh,'LineWidth',2);

% % %% add tag
% % % it would be nice if plot multiple lines or groups of dots
% % if any(cellfun(@(x) strcmp(x,'Tag'), varargin, 'UniformOutput', 1))
% %     ind = find(cellfun(@(x) strcmp(x,'Tag'), varargin, 'UniformOutput', 1));
% %     tag = varargin{ind+1};
% %     if ~iscell(tag)
% %         tag = {tag};
% %     end
% %     assert(numel(tag)==numel(lh),'Input correct number of Tag');
% %     % give tag for all lines
% %     for iLine = 1:length(lh) % loop how many lines we have
% %         set(lh(iLine),'Tag',tag{iLine});
% %     end
% % end


%% plot errorbar
%eh = zeros(size(se));
if ~isempty(se)
    if iscell(se) % plot both horizontal and vertical bar
        seh = se{1};
        sev = se{2};
    else
        sev = se;
        seh = [];
    end
    % deal with vertical errorbar
    if length(size(sev)) < 3
        setmp(:,:,1) = sev; % upper bound
        setmp(:,:,2) = sev;
        %setmp is a
        sev = permute(setmp,[3 2 1]); %se is a 2 x line x data matrix
    else % in this case, se is a data x line x 2 matrix
        sev = permute(sev,[3 2 1]);% 2 x line x data matrix
    end
    sev = reshape(sev,[2 size(y,1) size(y,2)]);% to avoid one line case
    for iLine = 1:length(lh) % loop how many lines we have        
        rzerrorbar(x(iLine,:),y(iLine,:),squeeze(sev(:,iLine,:)),1,'-','Color',get(lh(iLine),'color')); hold on;
    end
    if ~isempty(seh)
        % deal with horizontal errorbar
        if length(size(seh)) < 3
            setmp(:,:,1) = seh; % upper bound
            setmp(:,:,2) = seh;
            %setmp is a
            seh = permute(setmp,[3 2 1]); %se is a 2 x line x data matrix
        else % in this case, se is a data x line x 2 matrix
            seh = permute(sev,[3 2 1]);% 2 x line x data matrix
        end
        seh = reshape(seh,[2 size(y,1) size(y,2)]);% to avoid one line case
        for iLine = 1:length(lh) % loop how many lines we have
            rzerrorbar(x(iLine,:),y(iLine,:),squeeze(seh(:,iLine,:)),0,'-','Color',get(lh(iLine),'color')); hold on;
        end
    end
end

