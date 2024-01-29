% https://de.mathworks.com/matlabcentral/answers/177342-how-to-convert-nanoseconds-timestamp-to-datetime-structure
function [dt] = secToDateTime(s)
    ns = fix(s*1e9);
    ns_u64 = uint64(ns);
    wholeSeconds = floor(double(ns_u64)/1e9);
    fracSeconds = double(ns_u64 - uint64(wholeSeconds)*1e9)/1e9;
    
    lt = localtime(wholeSeconds);
    dt = strftime("%Y-%m-%d %X", lt);
    
    return;
endfunction