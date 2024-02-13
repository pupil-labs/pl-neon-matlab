function [ns] = get_ns()
    % GetSecs is a Psychtoolbox function
    % call it from Python
    s = py.psychtoolbox.GetSecs();
    ns = fix(s*1e9);

    return;
endfunction