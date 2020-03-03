function mp = getmonitorparams(monitorname,varargin)
% function getmonitorparams(monitorname)
%
% Similar to the concept of monitor center in psychopy, we define a unified
% function that can retrival the monitor information 
%
% <monitorname> is a string or pattern for matchfiles.m that matlab can use
% and load the corresponding file. in RZutil/psychophysics/. We return a 
% structure <mp> that contains all monitor related parameters. You can
% input keyword arugments in <varargin> to update field, we use
% mergestruct.m to update the struct
%
%
% <mp> has fields:
%   'monitorname': a string specify the monitor name
%   'size': [width, height] in centimeters
%   'resolution': [width, height] in pixels
%   'refreshrate': hz
%   'viewdist': viewdist in centimeters,a scalar or a vector of scalars. This
%       consider in MRI, different coils might have different view
%       distance. In the later case, 'coil' should specify the coil name.
%       'pixperdeg' and 'pixperarcmin' are also a vector
%   'pixperdeg': how many pixels per degree
%   'pixperarcmin': how many pixesl per arcmin
%   'coil': a string or a cell of string, specify coils in MRI monitor
%   'gamma': [gamma, gain, base], the fitted base luminance and exponent from
%       monitor calibration. so the output luminance is
%           lum = gain * value.^gamma + base
%
% Currently support monitors are:
%   'uminn7tpsboldscreen'
%   'uminnofficedesk'
%   'nih7T'
%   'uminn7tpsvpixx' (to do)
%   'uminn3tbprojector' (to do)
%
% To do:
%   1. regular expression monitor name matching
%   
%
%
% History:
%   20200221 RZ added support for 'nih7t'
%   20180625 RZ added support for 'uminnmacpro'
%   20180425 RZ created it


% we use thie regular expression

switch monitorname
    case 'uminn7tpsboldscreen'
        mp.monitorName = 'uminn7tpsboldscreen';
        mp.size = [69.84, 39.29];  % cm
        mp.resolution = [1920, 1080]; % pixels
        mp.refreshRate = 120; % hz
        mp.viewDist = [189.5, 174]; % cm
        mp.coil = {'em32k','nova1x32'};
        mp.pixPerDeg = (mp.resolution(1)/2)./ atand(mp.size(1)/2./mp.viewDist); %pix/deg
        mp.pixPerArcmin = mp.pixperdeg/60; %pix/arcmin
        mp.gamma = 1;
    case 'uminn7tpsvpixx'
        
    case 'uminn3tbprojector'
    
    case 'cmrrpsphlab'
        mp.monitorName = 'cmrrpsphlab';
        mp.size = [52, 32.5];  % width, height cm
        mp.resolution = [1920, 1200]; % width height pixels
        mp.refreshRate = 60; % hz
        mp.viewDist = 70;
        mp.coil = {};
        mp.pixPerDeg = (mp.resolution(1)/2)./ atand(mp.size(1)/2./mp.viewDist); %pix/deg
        mp.pixPerArcmin = mp.pixPerDeg/60; %pix/arcmin
        mp.gamma = 1;
    case 'uminnmacpro'
        mp.monitorName = 'uminmacpro';
        mp.size = [36, 29];  % width, height cm
        mp.resolution = [1440, 900]; % width height pixels
        mp.refreshRate = 60; % hz
        mp.viewDist = 50; % this is rough
        mp.coil = {};
        mp.pixPerDeg = (mp.resolution(1)/2)./ atand(mp.size(1)/2./mp.viewDist); %pix/deg
        mp.pixPerArcmin = mp.pixPerDeg/60; %pix/arcmin
        mp.gamma = 1;
    
    case 'uminnofficedesk'
        mp.monitorName = 'uminnofficedesk';
        mp.size = [36, 29];  % width, height cm
        mp.resolution = [1280, 1024]; % width height pixels
        mp.refreshRate = 60; % hz
        mp.viewDist = 70;
        mp.coil = {};
        mp.pixPerDeg = (mp.resolution(1)/2)./ atand(mp.size(1)/2./mp.viewDist); %pix/deg
        mp.pixPerArcmin = mp.pixPerDeg/60; %pix/arcmin
        mp.gamma = 1;
    case 'uminnintracranialpatient' 
        mp.monitorName = 'uminnintracranialpatient';
        mp.size = [53.85, 35.56];  % cm
        mp.resolution = [1920, 1080]; % pixels
        mp.refreshRate = 60; % hz
        mp.viewDist = 60.96; % cm, 2ft
        mp.pixPerDeg = (mp.resolution(1)/2)./ atand(mp.size(1)/2./mp.viewDist); %pix/deg
        mp.pixPerArcmin = mp.pixPerDeg/60; %pix/arcmin
        mp.gamma = 1;
    case 'nih7t' 
        mp.monitorName = 'nih7t';
        mp.size = [33.9852, 19.5072];  % cm
        mp.resolution = [1920, 1080]; % pixels
        mp.refreshRate = 60; % hz
        mp.viewDist = 64; % cm, 2ft
        mp.pixPerDeg = (mp.resolution(2)/2)./ atand(mp.size(2)/2/mp.viewDist); %pix/deg
        mp.pixPerArcmin = mp.pixPerDeg/60; %pix/arcmin
        mp.gamma = 1;        
    case 'nihofficedesk' 
        mp.monitorName = 'nihofficedesk';
        mp.size = [53.85, 35.56];  % cm
        mp.resolution = [1920, 1080]; % pixels
        mp.refreshRate = 60; % hz
        mp.viewDist = 70; % cm
        mp.pixPerDeg = (mp.resolution(1)/2)./ atand(mp.size(1)/2./mp.viewDist); %pix/deg
        mp.pixPerArcmin = mp.pixPerDeg/60; %pix/arcmin
        mp.gamma = 1;
    case 'nihlaptop'
        
    otherwise
        error('Can not find the monitor file !')

end
