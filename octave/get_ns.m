function [ns] = get_ns()
    % GetSecs is a Psychtoolbox function
    % s = GetSecs();
    s = py.psychtoolbox.GetSecs;
    ns = fix(s*1e9);

    return;
endfunction