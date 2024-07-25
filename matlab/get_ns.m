function [ns] = get_ns()
    ns = double(py.time.time_ns());

    return;
end