function varargout=WaitTill(keys)
    [down t kcode] = KbCheck(-1); %#ok read it as early as possbile
    esc=KbName('Escape');
    while ~any(kcode(keys))
        WaitSecs(0.005);
        [down t kcode] = KbCheck(-1); %#ok
        if kcode(esc), error('esc:exit','ESC pressed.'); end
    end
    k=find(kcode(keys),1);
    if nargout, varargout={k t}; end
end