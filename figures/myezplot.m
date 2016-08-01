function H = myezplot(varargin)

% default settings
defaultImgSetting;

H = ezplot(varargin{:});

% add some setting
set(gca,'box','off');

end

