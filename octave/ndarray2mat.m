function [mat] = ndarray2mat(arr, nr, nc, nl)
  if nl == 0
    mat = zeros(nr, nc);
    if nr == 1
      for x = 1:nc
        mat(1, x) = py.float(arr{x});
      endfor
    else
      for y = 1:nr
        r = arr{y};
        for x = 1:nc
          mat(y, x) = py.float(r{x});
        endfor
      endfor
    endif
  else
    mat = zeros(nr, nc, nl);
    for y = 1:nr
      r = arr{y};
      for x = 1:nc
        c = r{x};
        for z = 1:nl
          mat(y, x, z) = py.float(c{z});
        endfor
      endfor
    endfor
  endif
  
  return;
endfunction