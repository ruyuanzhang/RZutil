%some default setting when generating figures.
%It seems not applicable in ubuntu.
function defaultImgSetting

%default axes setting
set(groot,'defaultAxesFontSize',15);
set(groot,'defaultAxesFontName','Arial');
set(groot,'defaultAxesFontWeight','Bold');
set(groot,'defaultAxesColor','none'); %set the background of plot area
set(groot,'defaultAxesLineWidth',1.5);
set(groot,'defaultAxesBox','off');
set(groot,'defaultAxesLooseInset',[0 0 0 0]); %remove the surrounding white space when make figures.
set(groot,'defaultAxesNextPlot','add'); %remove the surrounding white space when make figures.


%default legend setting
set(groot,'defaultLegendBox','off');
set(groot,'defaultLegendLocation','northwest');

%default text seting
set(groot,'defaultTextFontSize',15);
set(groot,'defaultTextFontName','Arial');
 
%default line setting
set(groot,'DefaultLineMarkerSize',20);
set(groot,'DefaultLineLineWidth',1.5);

%default bar and error bar settings
%set(groot,'defaultBarFaceColor',[0 0 0]);
set(groot,'defaultErrorBarLineStyle','none');
set(groot,'defaultErrorBarColor',[0 0 0]);
set(groot,'defaultErrorBarLineWidth',1.5);

%default figure setting
set(groot,'defaultFigurePaperPositionMode','auto');
end
