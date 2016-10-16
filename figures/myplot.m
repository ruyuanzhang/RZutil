function H = myplot(varargin)


%run default image settings
defaultImgSetting;


H = plot(varargin{:});

% add some settings
set(gca, 'box','off');
set(H,'LineWidth',2);
