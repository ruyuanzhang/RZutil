function A=readtxtdata(filename, varargin)
%
% varargin include <formatSpec> and <size>
%
% Example:
% readtxtdata('./bvec', '%d')
% readtxtdata('./bvec', '%f')
% readtxtdata('./bvec', '%f',[3,100])
%
if ~exist('filename','var')||isempty(filename)
   error('Input filename error'); 
end

fileID = fopen(filename,'r');

% 
if fileID == -1
  if exist(filename, 'file')
    error('Cannot open existing file: %s', filename);
  else
    error('Missing file: %s', filename);
  end
end
%

A = fscanf(fileID,varargin{:});
fclose(fileID);

end