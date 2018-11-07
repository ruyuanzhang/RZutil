function [namewithpath, namenopath]=getniifilename(file)
% get the file name

if ~exist('file','var')||isempty(file)
    error('Please input correct file');
end

[filepath, baseFileName,ext] = fileparts(file);
if strcmp(ext,'.nii')
    namenopath = baseFileName;
    namewithpath = fullfile(filepath,baseFileName);
elseif strcmp(ext,'.gz')
    [namewithpath, namenopath]= getniifilename(fullfile(filepath,baseFileName));
end
