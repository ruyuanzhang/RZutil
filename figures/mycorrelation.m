function [cah, sstruct] = mycorrelation(data1,data2,varargin)
%% [cah, ssstruct] = mycorrelation(data1,data2,varargin)
% Correlation, quickly compute and plot the correlation of two variables.
%
%   Inputs:
%       data 1, data 2: two variables with same length
%   Outputs:
%       cah:        figure axes handle
%       sstruct:    structure contains all information
%
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
%       fighandle    :  could be figure, axes handles
%       confinterval: yes,draw 95% CI line, default: [];
%       labels   : lables for data 1 and data 2, default {'data1','data2'};
%       linelrange: the range of the linear line; default: axex limits;
%
%
%%%%%%%%%%%%%%%%%%
%Examples;
%
%[h(1),s]=mycorrelation(corr(:,11),corr(:,3),'fighandle',h(1),'linerange',[],'labels',{'Overall MOT performance at post-test','N-back learning gain%'},'corrinfo',{'r'});
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%history
%Updated RZ 06/04/16
%   wrote the function,RZ 06/04/16





%% Set default
if(~exist('data1','var') || isempty(data1)||~exist('data2','var') || isempty(data2))
    error('Please input the two variable to compute correlation');
end
s = size(data1);
if ~isequal(s,size(data2));
	error('data1 and data2 must have the same size');
end
%default
options = struct(...
        'corrinfo', {{'r','p'}},...
        'fighandle',[],...
        'confinterval',[],...
        'labels',{{'',''}},...
        'linerange',[],...
        'lineonly',0);
        
       
%% parse options
input_opts=mergestruct(varargin{:});
fn=fieldnames(input_opts);
for f = 1:numel(fn)
    opt=input_opts.(fn{f});
    if ~isfield(options,fn{f})
        error('Please input correct input variable');
    end
    if(~(isnumeric(opt) && isempty(opt)))
        options.(fn{f})=input_opts.(fn{f});
    end
end

% deal with figure issue
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

%
markersize = 8;
%% Correlation

%plot scatter plot
hold(cah,'on');
ph=myplot(cah,data1,data2,'o','markersize',markersize,'tag','correlation dot');
if options.lineonly == 1    
    set(ph,'Marker','none');
end

%compute correlation
% Linear regression
[polyCoefs, S] = polyfit(data1,data2,1);
[r, p] = corrcoef(data1,data2); r=r(1,2); p=p(1,2);
rho = corr(data1,data2,'type','spearman');
N = length(data1);
SSE = sqrt(sum((polyval(polyCoefs,data1)-data2).^2)/(N-2));
a = axis(cah);

%plot the correlation line
if isempty(options.linerange)
    ph=myplot(cah,a(1:2), polyval(polyCoefs,a(1:2)),'-','LineWidth',2,'Color',get(ph,'Color'),'tag','correlation line');
else
    ph=myplot(cah,options.linerange(1:2), polyval(polyCoefs,options.linerange(1:2)),'-','LineWidth',2,'Color',get(ph,'Color'),'tag','correlation line');
end

if  isequal(options.confinterval,'yes')% Add 95% CI lines
	xfit = a(1):(a(2)-a(1))/100:a(2);
	[yfit, delta] = polyconf(polyCoefs,xfit,S);
	h = [plot(cah,xfit,yfit+delta);...
		plot(cah,xfit,yfit-delta)];
	set(h,'color',get(ph,'Color'),'linestyle','-');
end

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
texthandle=text(a(1)+0.01*(a(2)-a(1)),a(4),corrtext,'parent',cah,'FontSize',15,'FontName','Arial','Color',get(ph,'Color'));
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
		'Intercept',polyCoefs(2));
end