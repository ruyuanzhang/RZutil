function img=setbgcolor(img,bgcolor,currentbg)
%function img=setbgcolor(img,bgcolor)
%sometimes we need to set background of a image color to certain value
%i.e. set 127 as background value for a face img. 
%Simply using img(img==bgcolornow)=127 may change pixel within the face.
%So use a "tedious" method. We assume that the background img is some
%other value (i.e. 100) but homogious surrouding img.
%
%Input:
%   img: input img, could be uint8 or double
%   bgcolor:background color,i.e 127
%Output:
%   img: outputimg
%
%i.e.
%
%
%
%
%


if ~exist('img','var') || isempty(img)
  error('Please specify an img of which you want to change the background')
end
if ~exist('bgcolor','var') || isempty(bgcolor)
  bgcolor = 127;
end
if ~exist('currentbg','var') || isempty(currentbg)
  currentbg = [];
end

x=size(img); %works for both gray and rgb img
row=x(1);
col=x(2);

if numel(size(img))==3
    currentbg=mean(img(1,1,:));
elseif numel(size(img))==2
    currentbg=img(1,1);
end


for x=1:row
    ii=1;
    jj=col;
    iibreak=0;
    jjbreak=0;
    while(ii<jj)&&(iibreak*jjbreak==0)
        if img(x,ii)==currentbg
            img(x,ii)=bgcolor;
            ii=ii+1;        
        else
            iibreak=1;
        end       
        
        if img(x,jj)==currentbg
            img(x,jj)=bgcolor;
            jj=jj-1;
        else
            jjbreak=1;
        end
    end
end


end