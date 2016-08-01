function c
% exit index when error occurs


screen_clut = [0:255; 0:255; 0:255]'./(255);
screens=Screen('Screens');
Screen('LoadNormalizedGammaTable',max(screens),screen_clut);
sca;
%Screen('Preference', 'VisualDebugLevel', oldVisualDebugLevel);
%Screen('Preference', 'SuppressAllWarnings', oldSupressAllWarnings);
ShowCursor;
end