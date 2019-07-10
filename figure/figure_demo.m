% some sample code to manipulate the settings for figures

% You can use simple code to check current values
get(groot,'default');
get(groot,'factory');
get(groot);

get(gca,'default');
get(gca);

% open figure control GUI
inspect;




% below are some simple example codes
hold on;
ax1=gca;
set(gca,'YScale','log');
set(gca,'XScale','log');
set(gca,'XTick',[1 1.5 2.3 3.5 5.3 8.0]);
set(gca,'YTick',[2 10 50 100]);
set(gca,'XGrid','off');
set(gca,'YLim',[2 100]);
set(gca,'YGrid','off');
set(gca,'ZGrid','off');
set(gca,'Box','off');
set(gca,'Clipping','off');
set(gca, 'CameraPosition',[29.9862 -222.7875   11.7665]);

colormap hot;

subplot(1,2,2);
s2=surf(X1,X2,reshape(p2,length(x),length(y)));
ax2=gca;
hold on;
set(gca,'YScale','log');
set(gca,'XScale','log');
%axis([0 15 0 0.25]);
set(gca,'XTick',[1 1.5 2.3 3.5 5.3 8.0]);
set(gca,'YTick',[2 10 50 100]);
set(gca,'XGrid','off');
set(gca,'YLim',[2 100]);
set(gca,'YGrid','off');
set(gca,'ZGrid','off');
set(gca,'Box','off');
set(gca,'Clipping','off');
set(gca,'Color','none'); %set the background of plot area
set(gca, 'CameraPosition',[29.9862 -222.7875   11.7665]);
colormap hot;
