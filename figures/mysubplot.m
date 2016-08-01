function fig=mysubplot(row,col,i,blankspace)
%function fig=mysubplot(rpw,col,i);
% Input:
%    row,col,i are the normal input for subplot(n,m,i);
% Output:
%    fig is the handle of this subplot
%
%example; 

if(~exist('row','var') || isempty(row))
    error('Please input the rows of those subplot');
end
if(~exist('col','var') || isempty(col))
    error('Please input the columns of those subplot');
end
if(~exist('i','var') || isempty(i))
    error('Please input the images number');
end
if(~exist('blankspace','var') || isempty(blankspace))
    blankspace = 0.05;%set blank space between plots
end


a=1:row*col;
a=reshape(a,col,row)';
[row_index,col_index]=find(a==i);

OuterPosition(1)=1/col*(col_index-1);
OuterPosition(2)=1/row*(row_index-1);
OuterPosition(3)=(1-blankspace*(col-1))/col;
OuterPosition(4)=(1-blankspace*(row-1))/row;


%remove some of the surrounding white space
fig=subplot(row,col,i,'OuterPosition',OuterPosition);
end