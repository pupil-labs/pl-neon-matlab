function [pyd_out] = convertVertStruct_to_PyDict(verts_struct)
    pyd = py.dict();

    fns = fieldnames(verts_struct);
    for fnc = 1:numel(fns)
        fn = fns{fnc};
        vert_list = py.list();
        verts = {verts_struct.(fn)};
        for vc = 1:numel(verts)
            vert = verts{vc};
            vert_list.append(py.tuple(vert));
        end

        pyd{fn(2:end)} = vert_list;
    end

    py.sys.path.insert(int32(0), "convert_ids.py");
    pyd_out = py.convert_ids.convert_ids(pyd);

    return;
end