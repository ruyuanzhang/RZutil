function img=imnormconst(img)
%normalize image luminance range to 0-254;
%output image is a double img

if ~exist('img','var')||isempty('img')
    error('please input the image');
end


tmp = double(img);
tmp=(tmp-min(tmp(:)))/range(tmp(:));%set to 0-1
tmp=round(254*tmp);%set to 50% contrast and scale it to 0~254;
img=tmp;

end

%