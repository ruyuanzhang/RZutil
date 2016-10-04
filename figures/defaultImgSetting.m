%some Default setting when generating figures.
%It seems not applicable in ubuntu.
function defaultImgSetting


%%
% c0=[0    0.4470    0.7410
%     0.8500    0.3250    0.0980
%     0.9290    0.6940    0.1250
%     0.4940    0.1840    0.5560
%     0.4660    0.6740    0.1880
%     0.3010    0.7450    0.9330
%     0.6350    0.0780    0.1840];

%Default axes setting
set(groot,'DefaultAxesFontSize',15);
set(groot,'DefaultAxesFontName','Arial');
set(groot,'DefaultAxesFontWeight','Bold');
set(groot,'DefaultAxesColor','none'); %set the background of plot area
set(groot,'DefaultAxesLineWidth',1.5);
set(groot,'DefaultAxesBox','off');
set(groot,'DefaultAxesLooseInset',[0 0 0 0]); %remove the surrounding white space when make figures.
set(groot,'DefaultAxesNextPlot','add'); %remove the surrounding white space when make figures.
%set(groot,'DefaultAxesColorOrder',gray);

%Default figure setting
set(groot,'DefaultFigurePaperPositionMode','auto');

%Default text seting
set(groot,'DefaultTextFontSize',15);
set(groot,'DefaultTextFontName','Arial');
 
%Default line setting
set(groot,'DefaultLineMarkerSize',20);
set(groot,'DefaultLineLineWidth',1.5);

%Default bar and error bar settings
%set(groot,'DefaultBarFaceColor',[0 0 0]);
set(groot,'DefaultErrorBarLineStyle','none');
set(groot,'DefaultErrorBarColor',[0 0 0]);
set(groot,'DefaultErrorBarLineWidth',1.5);
%Default legend setting
set(groot,'DefaultLegendBox','off');
set(groot,'DefaultLegendLocation','northwest');


end
