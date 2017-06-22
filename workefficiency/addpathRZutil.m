%addpath now
function addpathRZutil
%% a simple function to update RZutil repositories into path but do not include .git folder

warning('off','all');
rmpath(genpath('~/Documents/Code_git/CodeRepositories/RZutil'));
pathstr = genpath('~/Documents/Code_git/CodeRepositories/RZutil');

%% remove git folder
allpath = strsplit(pathstr,pathsep);
allpath = allpath(1:end-1); % a cell of all subpaths
tf=cellfun('isempty',strfind(allpath,'.git'));
allpath=allpath(tf);

%% concatenate all paths
allpath=cellfun(@strcat,allpath,repmat({pathsep},1,numel(allpath)),'UniformOutput',false);
allpath=strcat(allpath{:});
addpath(allpath);
savepath;
end