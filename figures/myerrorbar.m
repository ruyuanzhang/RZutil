function H = myerrorbar(varargin)

%%errorbar function by Ruyuan


%%
% default settings
defaultImgSetting;


H = errorbar(varargin{:});


% add some setting
set(gca,'box','off');



% if ~any(varargin =='MakerSize')
%     set(H,'MarkerSize',8);
% end
% 
% if ~any(varargin =='LineWidth')
%     set(H,'LineWidth',2);
% end


end

