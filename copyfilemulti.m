function copyfilemulti(source,dest, mode)
% function copyfilemulti(source,dest, mode)
% copyfile multiple files give filenames and new names. a wrapper of
% copyfile.m function
%
% Input:
%   source: a cell vector of strings of source filenames
%   dest: a cell vector of strings new filenames
%   mode: same input for copyfile function
%
% Example:
%   
if ~exist('source','var')||isempty(source)||~iscell(source)
    error('Please input the cell vector of source filenames');
end
if ~exist('dest','var')||isempty(dest)||~iscell(dest)
    error('Please input the cell vector of destinations filenames');
end
if ~exist('mode','var')||isempty(mode)||~iscell(mode)
    mode = [];
end

assert(all(size(source)==size(dest))); %source and dest should be same size

for i = 1:length(source)
    if isempty(mode)
        copyfile(source{i},dest{i});
    else
        copyfile(source{i},dest{i},mode);
    end
end

