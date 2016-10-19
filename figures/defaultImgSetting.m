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
set(rootind,'defaultAxesFontSize',15);
set(rootind,'defaultAxesFontName','Arial');
set(rootind,'defaultAxesFontWeight','Bold');
set(rootind,'defaultAxesColor','none'); %set the background of plot area
set(rootind,'defaultAxesLineWidth',1.5);
set(rootind,'defaultAxesBox','off');
%set(rootind,'defaultAxesLooseInset',[0 0 0 0]); %remove the surrounding white space when make figures.
set(rootind,'defaultAxesNextPlot','add'); %remove the surrounding white space when make figures.
set(rootind,'defaultAxesColorOrder',mycolororder('color'));
set(rootind,'defaultAxesTickDirMode','manual');
set(rootind,'defaultAxesTickDir','out');


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
%set(groot,'DefaultBarFaceColor',[0 0 0]);
set(groot,'DefaultErrorBarLineStyle','none');
set(groot,'DefaultErrorBarColor',[0 0 0]);
set(groot,'DefaultErrorBarLineWidth',1.5);

%Default legend setting
set(groot,'DefaultLegendBox','off');
set(groot,'DefaultLegendLocation','northwest');


end
