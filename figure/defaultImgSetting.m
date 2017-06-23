%some Default setting when generating figures.
%It seems not applicable in ubuntu.
function defaultImgSetting
% function defaultImgSetting
% 
% Run as a function in startup.m. This function customize various
% properties of figures
% 
% Note:
%   Starting from 2014b, matlab upgrades its figure system. This function
%   is compatible with the version after 2014b and in generall compatible
%   to OSX system, not great in linux.

switch computer
    case 'GLNXA64'
        rootind = 0;
    case 'MACI64'
        rootind = groot;
end    


%Default Figure level setting
set(rootind,'DefaultFigureInvertHardCopy','off');
set(rootind,'DefaultFigurePaperPositionMode','auto');
set(rootind,'DefaultFigureColormap',parula);

%Default axes setting
set(rootind,'defaultAxesFontSize',15);
set(rootind,'defaultAxesFontName','Arial');
set(rootind,'defaultAxesFontWeight','Bold');
set(rootind,'defaultAxesColor','none'); %set the background of plot area
set(rootind,'defaultAxesLineWidth',1.5);
set(rootind,'defaultAxesBox','off');
%set(rootind,'defaultAxesLooseInset',[0 0 0 0]); %remove the surrounding white space when make figures.
%set(rootind,'defaultAxesNextPlot','add'); %remove the surrounding white space when make figures.
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
set(groot,'DefaultErrorBarLineStyle','none');
set(groot,'DefaultErrorBarLineWidth',1.5);

%Default legend setting
set(groot,'DefaultLegendBox','off');
set(groot,'DefaultLegendLocation','northwest');


end
