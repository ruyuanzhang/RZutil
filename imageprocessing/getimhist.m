function f=getimhist(im)
% plot the pixel histogram of a image,could not accept multiple image


if ~exist('im','var') || isempty(im)
  error('please specify an image');
end

%%
defaultImgSetting;
%%
if length(size(im))==3
    
    f=figure;
    subplot(3,2,[1 3 5]);
    h=subimage(im);
    gca=get(h,'Parent');
    set(gca,'Box','off');
    set(gca,'XTick',gca.XLim-0.5);
    set(gca,'YTick',gca.YLim-0.5);
    
    subplot(3,2,2);
    title('red');
    h1=histogram(mat2vec(im(:,:,1)),256);
    h1.FaceColor = 'r';
    h1.FaceAlpha=1;
    h1.EdgeColor = h1.FaceColor;
    h1.BinLimits =[0,256];
    h1.BinWidth =1;
    gca1=get(h1,'Parent');
    set(gca1,'Box','off');
    axis tight;
    
    subplot(3,2,4);
    title('green');
    h2=histogram(mat2vec(im(:,:,2)),256);
    h2.FaceColor = 'g';
    h2.FaceAlpha=1;
    h2.EdgeColor = h2.FaceColor;
    h2.BinLimits =[0,256];
    h2.BinWidth =1;
    gca2=get(h2,'Parent');
    set(gca2,'Box','off');
    axis tight ;
    
    subplot(3,2,6);
    title('Blue');
    h3=histogram(mat2vec(im(:,:,3)),256);
    h3.FaceColor = 'b';
    h3.FaceAlpha =1;
    h3.EdgeColor = h3.FaceColor;
    h3.BinLimits =[0,256];
    h3.BinWidth = 1;
    gca3=get(h3,'Parent');
    set(gca3,'Box','off');
    axis tight;
else
    
    f=figure;
    subplot(1,2,1);
    subimage(im);
    
    subplot(1,2,2);

    h1=histogram(mat2vec(im(:,:,1)),256);
    h1.FaceColor = 'k';
    h1.FaceAlpha=1;
    h1.EdgeColor = h1.FaceColor;
    h1.BinLimits =[0,256];
    h1.BinWidth =1;
    gca1=get(h1,'Parent');
    set(gca1,'Box','off');
    
end






end