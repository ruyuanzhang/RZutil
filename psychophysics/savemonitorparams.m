% a script to save monitor params

clear all;close all;clc

mp.monitorName = 'uminn7tpsboldscreen';
mp.size = [69.84, 39.29];  % cm
mp.resolution = [1920, 1080]; % pixels
mp.refreshRate = 120; % hz
mp.viewDist = [189.5, 174]; % cm
mp.coil = {'em32k','nova1x32'};
mp.pixperdeg = (mp.resolution(1)/2)./ atand(mp.size(1)/2./mp.viewdist); %pix/deg
mp.pixperarcmin = mp.pixperdeg/60; %pix/arcmin
mp.gamma = 1;

% note the saved path
save(sprintf('monitor%s.mat', mp.monitorName), 'mp');

