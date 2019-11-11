function savetxtdata(filename, data, varargin)
%
%
% savetxtdata('./bvec', m, '%d %d %d')
% savetxtdata('./bvec', m, '%f %f %f')
% savetxtdata('./bvec', m, '%f')

if ~exist('filename','var')||isempty(filename)
   error('Input filename error'); 
end

fileID = fopen(filename,'w');
% 
if fileID == -1
  if exist(filename, 'file')
    error('Cannot open existing file: %s', filename);
  else
    error('Missing file: %s', filename);
  end
end
%

fprintf(fileID,varargin{:}, data);
fclose(fileID);

end