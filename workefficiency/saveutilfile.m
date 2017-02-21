function saveutilfile(filename,foldername,mode)
% function saveutilfile(filename,foldername,mode)
% move a function in current folder to utility repository RZutil. This only
% works when the file already exists in your current folder.Then this will
% automatically update path of RZutil 
%
% Input:
%   filename: name of the file you want to move.
%   foldername: which subfolder you want to add the file, e.g.
%       'imagingprocessing','figure','psychophysics';
%   mode: 0(default),movefile
%         1,copyfile

if ~exist('filename','var')||isempty(filename)
    error('Please specify the filename you want to move');
end
if ~exist('foldername','var')||isempty(foldername)
    fprintf(sprintf('%s will be put under RZutil/ \n',filename));
    foldername='';
end
if ~exist('mode','var')||isempty(mode)
    mode = 0;
end

dir = sprintf('/Users/ruyuan/Documents/Code_git/CodeRepositories/RZutil/%s',foldername);
if ~exist(dir,'file')
    fprintf(sprintf('No "%s" folder in RZutil, will put file under RZutil/ \n',foldername));
    dir = '/Users/ruyuan/Documents/Code_git/CodeRepositories/RZutil';
end

s = which(filename,'-ALL');
if iscell(s)
    if numel(s)>1
        fprintf(sprintf('Multiple files ''%s'' exists,use which(%s,''-All'') to check \n',foldername,foldername));
        s=s{1};
    else
        s=s{1};
    end
    
end
if mode==0
    movefile(s,dir);
elseif mode==1
    copyfile(s,dir);
end

cpath = pwd; % save current path
cd('~/Documents/Code_git/CodeRepositories/RZutil');
addpathnow; % update files into matlab path
cd(cpath); % go back to current path.
