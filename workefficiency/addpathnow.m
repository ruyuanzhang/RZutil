%addpath now
function addpathnow
%% a simple function to add current folder into path but do not include .git folder

warning('off','all');
rmpath(genpath(pwd))
pathstr = genpath(pwd);

%% remove git folder
allpath = strsplit(pathstr,pathsep);
allpath=allpath(1:end-1);
tf=cellfun('isempty',strfind(allpath,'.git'));
allpath=allpath(tf);
allpath=cellfun(@strcat,allpath,repmat({pathsep},1,numel(allpath)),'UniformOutput',false);
allpath=strcat(allpath{:});
addpath(allpath);
savepath;
end