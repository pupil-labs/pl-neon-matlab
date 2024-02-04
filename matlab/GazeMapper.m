classdef GazeMapper
    properties(Access = private)
        py_gaze_mapper
    end

    methods
        function [obj] = GazeMapper(calibration)
%             arguments
%                 calibration Calibration
%             end

            obj.py_gaze_mapper = py.pupil_labs.real_time_screen_gaze.gaze_mapper.GazeMapper(calibration.py_calibration);

            return;
        end

        function [screen_surface] = add_surface(obj, marker_verts, screen_size)
            py_marker_verts = convertVertStruct_to_PyDict(marker_verts);

            screen_surface = obj.py_gaze_mapper.add_surface(py_marker_verts, screen_size);

            return;
        end

        function [res] = process_frame(obj, sc_gz_sample)
%             arguments
%                 obj GazeMapper
%                 sc_gz_sample SceneGazeSample
%             end

            res = obj.py_gaze_mapper.process_frame(sc_gz_sample.py_scene_sample, sc_gz_sample.py_gaze_sample);

            return;
        end
    end
end