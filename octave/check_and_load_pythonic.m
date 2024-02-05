function check_and_load_pythonic()
    pkg_list = pkg('list');
    for x = 1:numel(pkg_list)
      if strcmp(pkg_list{x}.name, 'pythonic')
        if ~pkg_list{x}.loaded
          pkg load pythonic
        endif
      endif
    endfor
endfunction