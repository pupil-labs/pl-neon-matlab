function [ns] = get_ns()
    s = py.time.time_ns();
    ns = fix(s*1e9);

    return;
endfunction