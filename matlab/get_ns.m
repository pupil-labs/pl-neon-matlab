function [ns] = get_ns()
    % GetSecs is a Psychtoolbox function
    s = GetSecs();
    ns = fix(s*1e9);

    return;
end