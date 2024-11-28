function [ns] = get_ns()
    ns = int64(py.time.time_ns());

    return;
end