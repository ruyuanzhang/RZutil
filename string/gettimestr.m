function s = gettimestr(t)
% function s = gettimestr(t)
% 
% return a time str given time object,default is the current time obtained from
% clock.
%
% t is a 1x6 vector indicate time. default s=clock
if notDefined('t')
    t = clock;
end
s = sprintf('%d%02d%02d%02d%02d%02d',t(1),t(2),t(3),t(4),t(5),round(t(6)));




