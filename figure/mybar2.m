
function [Hb,He,ax]= mybar2(x,y,E)
% function [Hb,He,ax]= mybar2(x,y,E)
%
% This function is another version of mybar.m see input and output
% description in mybar.m
% 
% Note:
%   This function uses myplot function to directly plot straight lines as
%   errobar, seems to look prettier. see another version in mybar3.m
%   
% Example:
%  figure; x=rand(2,4);y=rand(2,4),E=rand(2,4)/3;
%  [Hb,He,ax]= mybar([],y,E);
%  [Hb,He,ax]= mybar2(1:4,y,E)

% dealing with inputs

if nargin < 3||isempty(E)
    E = [];

elseif nargin <2 || isempty(y)
    error('please input the Y value !');
elseif isempty(x)
    x=[];
elseif size(x)~=size(y)
    error('dimentions of x and y do not match!')
end

%
%fig=figure;
if isempty(x)
    Hb = bar(y'); hold on;
else
    Hb = bar(x',y'); hold on;
end


xLoc_bar = get(Hb(1,1),'XData');


%now compute the x location of each error bar 
numbars = size(y,1); 
groupwidth = min(0.8, numbars/(numbars+1.5));

xLoc_errorbar=zeros(size(y));
He=zeros(size(y));

for i = 1:numbars
      % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
      xLoc_errorbar(i,:) = xLoc_bar  - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
      %errorbar(x, model_series(:,i), model_error(:,i), 'k', 'linestyle', 'none');
      if ~isempty(E)
          if numel(E)==numel(y) %single error value
              He(i,:) = flatten(myplot([xLoc_errorbar(i,:);xLoc_errorbar(i,:)],[y(i,:)+E(i,:);y(i,:)-E(i,:)])); hold on;
          elseif numel(E)==2*numel(y) % up and low error value
              He(i,:) = flatten(myplot([xLoc_errorbar(i,:);xLoc_errorbar(i,:)],[y(i,:)+E(i,:,1);y(i,:)-E(i,:,2)])); hold on;
          end
      else
          He=[];
      end
end
% add errorbar. We do not use default errorbar function in matlab. rather,
% we simply plot a straight line on it. This seems looks prettier.
set(flatten(He),'LineWidth',6*groupwidth);
set(flatten(He),'Color',[0 0 0]);%for unix
set(gca,'Box','off');
ax=gca;


