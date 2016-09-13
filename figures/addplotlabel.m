function H=addplotlabel(fig,row,col,subplotnum,str,position)
% function to add subplot label 'A' 'B' to generate publish-ready figures
% Input:
%       fig: figure handle
%       row,col: row and colume number of all subplots
%       subplotnum: which subplot you want to add label
%       str: string you want to add,
%   optional: 
%       Position: position of the label
%
% Output:
%       H:handle of the annotation

if(~ishandle(fig) || (isempty(fig)))
    fig=gcf;
end
if(~exist('row','var') || isempty(row))
    error('Please input the rows of those subplots');
end
if(~exist('col','var') || isempty(col))
    error('Please input the columns of those subplots');
end
if(~exist('subplotnum','var') || isempty(subplotnum))
    error('Please input the number of the subplot');
end
if(~exist('str','var') || isempty(str))
    str = 'A';
end

%%first figure
a=1:row*col;
a=reshape(a,col,row)';
[row_index,col_index]=find(a==subplotnum);
OuterPosition=[1/col*(col_index-1) 1/row*(row-row_index) 1/col 1/row];

if(~exist('position','var') || isempty(position))
    position = [OuterPosition(1) OuterPosition(2)+1/row-0.1 0.1 0.1]; %ensure the label is added to the left up corner
end

H=annotation(fig,'textbox',position);
set(H,'String',str,'FontName','Arial','FontSize',20,'FontWeight','Bold','LineStyle','none');

end