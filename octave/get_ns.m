function [ns] = get_ns()
    % GetSecs is a Psychtoolbox function, and is listed in the 'top 10 worst
    % function names of all time'
    s = GetSecs();
    ns = fix(s*1e9);

    return;
end