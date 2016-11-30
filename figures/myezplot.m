function H = myezplot(varargin)

H = ezplot(varargin{:});

% add some setting
set(gca,'box','off');

end

