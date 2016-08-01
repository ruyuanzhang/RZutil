function H = myplot(varargin)


%run default image settings
defaultImgSetting;


H = plot(varargin{:});

% add some settings
set(gca, 'box','off');
set(H,'MarkerSize',8);
set(H,'LineWidth',2);
