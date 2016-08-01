function f=imshowmulti(img)
% show multiple image in a big frame
% img is a res x res X imgs, matrix, should uint8
% f is the handle of the picture;

if ~exist('img','var')||isempty('img')
    error('please input the images');
end

img=uint8(img);


imgnum = size(img,3);
columnnum = floor(sqrt(imgnum));
rownum = ceil(imgnum/columnnum);

f=figure;

for i = 1:imgnum
    subplot(rownum,columnnum,i);
    imshow(img(:,:,i));
    hold on;
    
    
end

end