function tit = mysuptitle(str,varargin)

tit = suptitle(str);

set(tit,'FontWeight','Bold');

if ~isempty(varargin)
    set(tit,varargin{:});
end


end