function fig=figrmwhitespace(fig,row,col,space,axesNum)
% fig=figrmwhitespace(fig,row,col,space)
% remove some redundent white space when using multiple subplot
% -------------------------------------------------------------------------
%   Input:
%       row,col: number of rows and columns of this multiple plot figures
%    Optional:
%       fig:whole figure handle;default is gcf;
%       space:a 1 by 4 vector, range from 0~1, specify move distance [left bottom width
%               heigh], for make all subplots closer, use negative
%               value, otherwise,use positive value
%--------------------------------------------------------------------------
%   Output:
%        fig:whole figure handle;
%--------------------------------------------------------------------------
% Example:
% x=1:100;y=randn(1,100);
% fig = figure;
% for i=1:6
%     subplot(3,2,i);
%     myplot(x,y);hold on;
%     title(sprintf('figure%d',i));
% end
% fig2 = figure;
% for i=1:6
%     subplot(3,2,i);
%     myplot(x,y);hold on;
%     title(sprintf('figure%d',i));
% end
% fig2=figrmwhitespace(fig2,3,2);


if(~exist('row','var') || isempty(row))
    error('Please input the rows of those subplot');
end
if(~exist('col','var') || isempty(col))
    error('Please input the columns of those subplot');
end
if(~ishandle(fig) || (isempty(fig)))
    fig=gcf;
end
if(~exist('space','var') || isempty(space))
    space = [0 0 0 0.005];
end
if (~exist('axesNum','var'))||isempty(axesNum)
    axesNum = [];
end

item=get(fig,'Child');

if ~isempty(axesNum)
    item=item(axesNum);
end


k=0;
for i = numel(item):-1:1
    
    if isa(item(i),'matlab.graphics.axis.Axes'); %only count axis object
        k=k+1;
        a=1:row*col;
        a=reshape(a,col,row)';
        [row_index,col_index]=find(a==k);
        
        
        OuterPosition=[1/col*(col_index-1) 1/row*(row-row_index) 1/col 1/row];
        
        
        
        Position(1)=OuterPosition(1)+item(i).TightInset(1)+space(1);
        Position(2)=OuterPosition(2)+item(i).TightInset(2)+space(2);
        Position(3)=OuterPosition(3)-item(i).TightInset(1)-item(i).TightInset(3)-space(3);
        Position(4)=OuterPosition(4)-item(i).TightInset(2)-item(i).TightInset(4)-space(4)-0.005;
        
        set(item(i),'OuterPosition',OuterPosition,'Position',Position); % It's important to set OuterPosition and Position at the same time
    end
    
end

end