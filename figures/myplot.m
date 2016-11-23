function H = myplot(varargin)
% function H=myplot(varargin)
% plot function by Ruyuan Zhang
%
% Example:
%   figure;myplot(rand(1,10));
%   figure;myplot(rand(1,10),rand(1,10));
%   figure;myplot(rand(1,10),rand(1,10),'-b');
%   figure;myplot(rand(1,10),rand(1,10),'-b','Tag','group1');
%   
% 2016/11/11 RZ added tag input option

%run default image settings
defaultImgSetting;


H = plot(varargin{:});



% add some settings
set(gca, 'box','off');
set(H,'LineWidth',2);

% add tag
if any(cellfun(@(x) strcmp(x,'Tag'), varargin, 'UniformOutput', 1))
    ind=find(cellfun(@(x) strcmp(x,'Tag'), varargin, 'UniformOutput', 1));
    tag=varargin{ind+1};
    set(H,'Tag',tag);
end
