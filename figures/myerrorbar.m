function H = myerrorbar(varargin)

%%errorbar function by Ruyuan



H = errorbar(varargin{:});
% add some setting
set(gca,'box','off');



end

