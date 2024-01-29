function [mat] = ndarray2mat(arr)
    sh = double(arr.shape);
    ac = cell(arr.tolist());

    mat = zeros(sh);
    if length(sh) == 1
        mat = cell2mat(ac);
        mat = mat(:);
    elseif length(sh) == 2
        for x = 1:sh(1)
            mat(x, :) = double(ac{x});
        end
    elseif length(sh) == 3
        for x = 1:sh(1)
            acx = ac{x};
            for y = 1:sh(2)
                mat(x, y, :) = double(acx{y});
            end
        end
    end

    return;
end