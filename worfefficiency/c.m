
function c
% exit index when error occurs when running psychotoolbox screen function

screen_clut = [0:255; 0:255; 0:255]'./(255);
screens=Screen('Screens');
Screen('LoadNormalizedGammaTable',max(screens),screen_clut);
sca;
%Screen('Preference', 'VisualDebugLevel', oldVisualDebugLevel);
%Screen('Preference', 'SuppressAllWarnings', oldSupressAllWarnings);
ShowCursor;
end