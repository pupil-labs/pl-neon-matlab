classdef GazeMapper
    properties(GetAccess = private, SetAccess = immutable)
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
            % marker_verts enters in the following form:
            % n squares by 4 coords, 2 for top-left corner and 2 for
            % bottom-right corner
            py_compat_verts = struct();
            for n = 1:size(marker_verts, 1)
                marker_vert = squeeze(marker_verts(n, :));
                topl = marker_vert(1:2);
                botr = marker_vert(3:4);
                py_compat_verts.(['m', num2str(n-1)]) = {
                    topl, ...
                    [botr(1), topl(2)], ...
                    botr, ...
                    [topl(1), botr(2)]
                    };
            end

            % py_marker_verts = convertVertStruct_to_PyDict(marker_verts);
            py_marker_verts = convertVertStruct_to_PyDict(py_compat_verts);

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

        function process_scene(obj, scene_sample)
            obj.py_gaze_mapper.process_scene(scene_sample);

            return;
        end

        function [res] = process_gaze(obj, gaze_sample)
            res = obj.py_gaze_mapper.process_gaze(gaze_sample.py_gaze_datum);

            return;
        end
    end
end