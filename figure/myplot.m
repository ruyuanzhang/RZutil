function lh = myplot(x,y,se,varargin)
% function H = myplot(x,y,se,varargin)
%
% plot function by Ruyuan Zhang, just a wrapper of plot.m.
%% Input:
%   x,y: input x,y data, x,y are vectors or matrix. If they are matrix, then
%       each column is a line. remember, the size of x, y should be compatible
%   se: sebar number, se is a vector or a matrix with same size as
%       x,y. In this case, se is a absolute value, the lower and upper boundary
%       of data should y-se and y+se.
%       Or, it can be with size as [size(x) 2]. The extra dimension
%       specifiy the lower and upper se, which correpond to errorbar2.m 
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
%   figure;myplot(rand(1,10));
%   figure;myplot(rand(1,10),rand(1,10));
%   figure;myplot(rand(1,10),rand(1,10),'-b');
%   figure;myplot(rand(1,10),rand(1,10),'-b','Tag','group1');
%   
% History:
%   2017/05/03 RZ add sebar function and fix the tag
%   2016/11/11 RZ added tag input option

if ~exist('x','var')||isempty(x)
    x=[];
end
if ~exist('y','var')||isempty(y)
    y=[];
end
if ~exist('se','var')||isempty(y)
    se=[];
end
if ~isempty(x)
    %assert(isequal(size(x),size(y)),'Please input same size of x,y!');
end

% do it 
if ~isempty(x)
    lh = plot(x,y,varargin{:}); hold on;
else
    lh = plot(y,varargin{:}); hold on;
end

% edit it a little big
set(gca, 'box','off');
set(lh,'LineWidth',2);

% add tag
% it would be nice if plot multiple lines or groups of dots
if any(cellfun(@(x) strcmp(x,'Tag'), varargin, 'UniformOutput', 1))
    ind = find(cellfun(@(x) strcmp(x,'Tag'), varargin, 'UniformOutput', 1));
    tag = varargin{ind+1};
    if ~iscell(tag)
        tag = cell(tag);
    end
    % give tag for all lines
    for iLine = 1:length(lh) % loop how many lines we have
        set(lh(iLine),'Tag',tag{iLine});
    end
end


% plot sebar
%eh = zeros(size(se));
if ~isempty(se) 
    % first massage se
    
    % in this case se is a absolute difference, refer the 1st case of definition of
    % se in function head
    if length(size(se)) < 3
        setmp(:,:,1) = y - se; % upper bound
        setmp(:,:,2) = y + se;
        %setmp is a
        se = permute(setmp,[3 2 1]); %se is a 2 x line x data matrix
    else % in this case, se is a data x line x 2 matrix
        se = permute(se,[3 2 1]);% 2 x line x data matrix
    end
    
    for iLine = 1:length(lh) % loop how many lines we have
    %eh(iLine,:) = sebar2(x(:,iLine),y(:,iLine),squeeze(se(:,iLine,:))',1,'-','Color',c,iLine);
        if isempty(x)
            rzerrorbar(1:size(y,1),flatten(y(:,iLine)),squeeze(se(:,iLine,:)),1,'-','Color',get(lh(iLine),'color')); hold on;              
        else
            rzerrorbar(flatten(x(:,iLine)),flatten(y(:,iLine)),squeeze(se(:,iLine,:)),1,'-','Color',get(lh(iLine),'color')); hold on; 
        end
    end
end

