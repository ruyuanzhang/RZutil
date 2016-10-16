function H = myerrorbar(varargin)

%%errorbar function by Ruyuan


%%
% default settings
defaultImgSetting;


H = errorbar(varargin{:});
% add some setting
set(gca,'box','off');



end

