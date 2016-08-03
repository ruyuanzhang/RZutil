function fig=figrmwhitespace(fig,row,col,space)



if(~ishandle(fig) || (isempty(fig)))
    error('Please input the figure handel');
end
if(~exist('row','var') || isempty(row))
    error('Please input the rows of those subplot');
end
if(~exist('col','var') || isempty(col))
    error('Please input the columns of those subplot');
end
if(~exist('space','var') || isempty(col))
    space = [0 0 0 0.005];
end


item=get(fig,'Child');
for i = 1:numel(item)
    a=1:row*col;
    a=reshape(a,col,row)';
    [row_index,col_index]=find(a==i);
    
    
    OuterPosition=[1/col*(col_index-1) 1/row*(row-row_index) 1/col 1/row];
    
    
    
    Position(1)=OuterPosition(1)+item(i).TightInset(1)+space(1);
    Position(2)=OuterPosition(2)+item(i).TightInset(2)+space(2);
    Position(3)=OuterPosition(3)-item(i).TightInset(1)-item(i).TightInset(3)-space(3);
    Position(4)=OuterPosition(4)-item(i).TightInset(2)-item(i).TightInset(4)-space(4)-0.005;
    
    set(item(i),'OuterPosition',OuterPosition,'Position',Position); % It's important to set OuterPosition and Position at the same time
    
    
end

end