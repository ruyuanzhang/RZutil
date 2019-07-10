function savestruct(filename,struct)
%function savestruct(filename,struct)
%
% directly use save(filename,'-struct',struct) seems to generate a huge
% file, while extracting all fields of a struct into workspace then save
% all of them seems save a lot of space..not sure why. But here i implement
% a simple funtion to achieve this.
%
% Input:
%       filename: filename to save, could include fullpath, like
%                   '~/rivalry/run1.mat';
%       struct: the struct to save
%
% Example:
% x.a=1;x.b=2;x.c=3;
% savestruct('test.mat',x);
% savestruct('~/test1.mat',x);
%
% Notes: might implement selective save fields in the future.

if ~exist('filename','var')||isempty(filename)
    error('Please input the file name');
end
if ~exist('struct','var')||isempty(struct)
    error('Please input the struct');
end


names=fieldnames(struct);
for i=1:numel(names)
    evalc([names{i} '=struct.' names{i}]);
    if i==1
        save(filename,names{i});
    else
        save(filename,names{i},'-append');
    end
    
end

end