function [cah, sstruct] = mycorrelation(data1,data2,varargin)
%% [cah, ssstruct] = mycorrelation(data1,data2,varargin)
%
% Correlation, quickly compute and plot the correlation of two variables.
%
% Inputs:
%   data 1, data 2: two variables with same length
%   Optional Inputs:
%       corrinfo: specifies what information to display on the correlation chart as a cell of string in 
%                   order of top to bottom. The following codes are available:
%                   if not specified or empty, default is: {'r';'p'}
%
%                   - 'eq'     slope and intercept equation
%                   - 'int%'   intercept as % of mean values
%                   - 'r'      pearson r-value
%                   - 'r2'     pearson r-value squared
%                   - 'rho'    Spearman rho value
%                   - 'SSE'    sum of squared error
%                   - 'n'      number of data points used
%                           %if not specified or empty, default is: {'r';'p'}
%       fighandle  :  could be figure, axes handles
%       drawconf: yes,draw confident interval patch, default: yes,
%       confinterval: a scalar between 0~1, default:0.68
%       labels   : lables for data 1 and data 2, default {'data1','data2'};
%       linerange: the range of the linear line; default: axex limits;
%       color: color for dot and line,default:[0    0.4470    0.7410],the
%           first color (light blue color) for default colororder.
%       degree: degree of poly fit, default:1, linear regression.
%       se: {xse,yse}, xse and yse are standard error for x and y, the
%           input format should be consisten with rzerrorbar.m. we use rzerrorbar 
%           to plot errobar. se can also be 2 x N where the first row
%           has values for the lower bound and the second row has values
%           for the upper bound.
%           
% Outputs:
%       cah:        figure axes handle
%       sstruct:    structure contains all information
%
% Note:
%   1. Once we find nan value, just delete the pair of data in both data1
%       and data2
%   2. we use rzerrorbar function to plot errobar.
%
% Examples:
% [h(1),s]=mycorrelation(corr(:,11),corr(:,3),[],'fighandle',h(1),'linerange',[],'labels',{'Overall MOT performance at post-test','N-back learning gain%'},'corrinfo',{'r'});
%
% Future work:
%   1. dot,line,surface handle delivered to structure, then every handle is
%   doubled, not sure why? bugs??
%
% History:
% 04/27/17, RZ added errorbar to both direction
% 04/26/17, RZ implemented the confidence interval patch
% 06/04/16, wrote the function



%% Set default
if(~exist('data1','var') || isempty(data1)||~exist('data2','var') || isempty(data2))
    error('Please input the two variable to compute correlation');
end
assert(isequal(size(data1),size(data2)),'Please input x,y with same size');
%default 
options = struct(...
        'corrinfo', {{'r','p'}},...
        'fighandle',[],...
        'drawconf','yes',...
        'labels',{{'',''}},... % note cell input should be double quote
        'linerange',[],...
        'lineonly',0,...
        'confinterval',0.68,...
        'color',[0 0.4470 0.7410],...
        'degree',1,...
        'se',{{[],[]}});

%% parse options
input_opts = mergestruct(varargin{:});
fn = fieldnames(input_opts);
for f = 1:numel(fn)
    opt = input_opts.(fn{f});
    if ~isfield(options,fn{f})
        error('Please input correct input variable');
    end
    if(~(isnumeric(opt) && isempty(opt)))
        options.(fn{f}) = input_opts.(fn{f});
    end
end

%% deal with figure issue
if isempty(options.fighandle)
	fig = gcf;
	cah = gca;
elseif strcmpi(get(options.fighandle,'type'),'figure')
	fig = options.fighandle;%update figure handle;
    cah = get(fig,'Children');     
elseif strcmpi(get(options.fighandle,'type'),'axes')
    cah = options.fighandle;
	fig = get(cah,'parent');
else
	error('What in tarnations is the handle that was passed to Bland-Altman????')
end
set(cah,'tag','Correlation Plot');
% some settings
markersize = 8;
%% consider the nan case
ind = ~(isnan(data1)|isnan(data2));
data1 = data1(ind);
data2 = data2(ind);


%% Correlation

%plot scatter plot
hold(cah,'on');
axes(cah);
ph = myplot(data1,data2,[],'o','Color',options.color,'MarkerSize',markersize,'tag','correlation dot');
% add errorbar
f1=[];
f2=[];
if ~isempty(options.se{1})
    f1 = rzerrorbar(flatten(data1),flatten(data2),options.se{1},0,'-','Color',options.color,'tag','errorbar_x');
end
if ~isempty(options.se{2})
    f2 = rzerrorbar(flatten(data1),flatten(data2),options.se{2},1,'-','Color',options.color,'tag','errorbar_y');
end

if options.lineonly == 1    
    set(ph,'Marker','none');
end

%compute correlation
% Linear regression
[polyCoefs, S] = polyfit(data1,data2,options.degree);
[r, p] = corrcoef(data1,data2); r = r(1,2); p = p(1,2);
rho = corr(data1,data2,'type','spearman');
N = length(data1);
SSE = sqrt(sum((polyval(polyCoefs,data1)-data2).^2)/(N-2));
a = axis(cah);

%plot the correlation line
if isempty(options.linerange)
    axes(cah);
    ph_line = myplot(a(1:2), polyval(polyCoefs,a(1:2)),[],'-','LineWidth',2,'Color',get(ph,'Color'),'tag','correlation line');
else
    axes(cah);
    ph_line = myplot(options.linerange(1:2), polyval(polyCoefs,options.linerange(1:2)),[],'-','LineWidth',2,'Color',get(ph,'Color'),'tag','correlation line');
end


if  isequal(options.drawconf,'yes')% Add 95% CI linesw
    xfit = ph_line.XData(1):(ph_line.XData(2)-ph_line.XData(1))/100:ph_line.XData(2);
	[yfit, delta] = polyconf(polyCoefs,xfit,S,'alpha',1-options.confinterval);
	ar = patch([xfit fliplr(xfit)],[yfit+delta fliplr(yfit-delta)],get(ph,'Color'));
    set(ar,'Facecolor',get(ph,'Color'),'LineStyle','none','FaceAlpha',0.1); 
end

% re adjust 

corrtext = {};  
for i=1:length(options.corrinfo)
	switch lower(options.corrinfo{i})
		case 'eq', corrtext = [corrtext; ['y=' num2str(polyCoefs(1),3) 'x+' num2str(polyCoefs(2),3)]];
		case 'int%', corrtext = [corrtext; ['intercept=' num2str(polyCoefs(2)/mean(data1+data2)*2*100,3) '%']];
		case 'r2', corrtext = [corrtext; ['r^2=' num2str(r^2,4)]];
		case 'r', corrtext = [corrtext; ['r=' num2str(r,4)]];
		case 'p', corrtext = [corrtext; ['p=' num2str(p,4)]];
		case 'rho', corrtext = [corrtext; ['rho=' num2str(rho,4)]];
		case 'sse', corrtext = [corrtext; ['SSE=' num2str(SSE,2)]];
		case 'n', corrtext = [corrtext; ['n=' num2str(N)]];
	end
end
a = axis(cah);
texthandle = text(a(1)+0.01*(a(2)-a(1)),a(4),corrtext,'Parent',cah,'FontSize',15,'FontName','Arial','Color',get(ph,'Color'));
%set(texthandle,'FontName','Arial');
%set(texthandle,'FontSize',13);
xlabel(cah,options.labels{1}); ylabel(cah,options.labels{2});

if nargout>1
	sstruct = struct('N',N,...
		'r',r,...
        'p',p,...
		'r2',r^2,...
		'SSE',SSE,...
		'rho',rho,...
		'Slope',polyCoefs(1),...
		'Intercept',polyCoefs(2),...
        'dothandle',ph,...
        'linehandle',ph_line,...
        'surfacehandle',ar,...
        'errobarhandle',{f1,f2},...
        'testhandle',texthandle);
end