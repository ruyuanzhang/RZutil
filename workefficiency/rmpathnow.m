function rmpathnow
%%remove path
warning('off','all');
rmpath(genpath(pwd));
savepath;