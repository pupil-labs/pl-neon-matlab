classdef GazeMapper
    % octave does not have immutable properties
    properties(Access = private)
        py_gaze_mapper
    endproperties

    methods
        function [obj] = GazeMapper(calibration)
            % no keyword arguments or type specifying of arguments in octave

            check_and_load_pythonic();

            pyexec("from pupil_labs.real_time_screen_gaze.gaze_mapper import GazeMapper");

            % py_side_calibration was cached when the Device object was created
            pyexec('gaze_mapper = GazeMapper(py_cached_calibration)');
            obj.py_gaze_mapper = pyeval('gaze_mapper');

            return;
        endfunction

        function [screen_surface] = add_surface(obj, marker_verts, screen_size)
            py_marker_verts = convertVertStruct_to_PyDict(marker_verts);

            screen_surface = obj.py_gaze_mapper.add_surface(py_marker_verts, screen_size);

            return;
        endfunction

        function [res] = process_frame(obj, sc_gz_sample)
            % no keyword arguments or type specifying of arguments in octave
            
            res = obj.py_gaze_mapper.process_frame(sc_gz_sample.py_scene_sample, sc_gz_sample.py_gaze_sample);

            return;
        endfunction
    endmethods
endclassdef