% a script to save monitor params

clear all;close all;clc

mp.monitorName = 'uminnintercranialpatient';
mp.size = [53.85, 35.56];  % cm
mp.resolution = [1920, 1080]; % pixels
mp.refreshRate = 60; % hz
mp.viewDist = 60.96; % cm, 2ft
mp.pixperdeg = (mp.resolution(1)/2)./ atand(mp.size(1)/2./mp.viewDist); %pix/deg
mp.pixperarcmin = mp.pixperdeg/60; %pix/arcmin
mp.gamma = 1;

% note the saved path
save(sprintf('monitor%s.mat', mp.monitorName), 'mp');

