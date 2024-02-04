function [mat] = ndarray2mat(arr)
%     sh = double(arr.shape);
    sh = cellfun(@double, cell(arr.shape));
    ac = cell(arr.tolist());

    mat = zeros(sh);
    if length(sh) == 1
        mat = cell2mat(ac);
        mat = mat(:);
    elseif length(sh) == 2
        for x = 1:sh(1)
            acx = ac{x};
            for y = 1:sh(2)
                mat(x, :) = double(acx{y});
            end
        end
    elseif length(sh) == 3
        for x = 1:sh(1)
            acx = ac{x};
            for y = 1:sh(2)
                acy = acx{y};
                for z = 1:sh(3)
                    mat(x, y, z) = double(acy{z});
                end
            end
        end
    end

    return;
end