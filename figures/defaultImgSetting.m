%some Default setting when generating figures.
%It seems not applicable in ubuntu.
function defaultImgSetting

switch computer
    case 'GLNXA64'
        rootind = 0;
    case 'MACI64'
        rootind = groot;
end
    


%%

%Default axes setting
set(rootind,'DefaultAxesFontSize',15);
set(rootind,'DefaultAxesFontName','Arial');
set(rootind,'DefaultAxesFontWeight','Bold');
set(rootind,'DefaultAxesColor','none'); %set the background of plot area
set(rootind,'DefaultAxesLineWidth',1.5);
set(rootind,'DefaultAxesBox','off');
set(rootind,'DefaultAxesLooseInset',[0 0 0 0]); %remove the surrounding white space when make figures.
set(rootind,'DefaultAxesNextPlot','add'); %remove the surrounding white space when make figures.
set(rootind,'DefaultAxesColorOrder',mycolororder('color'));

%Default text seting
set(rootind,'defaultTextFontSize',15);
set(rootind,'defaultTextFontName','Arial');
 
%Default line setting
set(rootind,'defaultLineMarkerSize',8);
set(rootind,'defaultLineLineWidth',1.5);
%Default figure setting
set(rootind,'DefaultFigurePaperPositionMode','auto');


%% below are specific to groot, somehow it's wrong to use 0 on linux
%Default legend settings
set(groot,'defaultLegendBox','off');
set(groot,'defaultLegendLocation','northwest');

%Default bar and error bar settings
set(groot,'DefaultBarFaceColor',[0 0 0]);
set(groot,'defaultErrorBarLineStyle','none');
set(groot,'defaultErrorBarColor',[0 0 0]);
set(groot,'defaultErrorBarLineWidth',1.5);

end
