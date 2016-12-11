function outputimg=imnormconst(img)
% function img=imnormconst(img)
% normalize image luminance range to 0-254;
% output image is a double img
% 
% Input:
%   img:a res x res image or
%       res x res x n images
% Output:
%   outputimg: same size with input image
%
% Example:
% img=imnormconst(rand(10,10));
% isequal()
% 
% Note: implement cell images??


if ~exist('img','var')||isempty('img')
    error('please input the image');
end

if numel(size(img))<=2
    tmp = double(img);
    tmp=(tmp-min(tmp(:)))/range(tmp(:));%set to 0-1
    tmp=round(254*tmp);
    outputimg=tmp;    
else
    for i = size(img,3)
        tmp = double(img(:,:,i));
        tmp=(tmp-min(tmp(:)))/range(tmp(:));%set to 0-1
        tmp=round(254*tmp);
        outputimg{:,:,i}=tmp;
    end
end


%