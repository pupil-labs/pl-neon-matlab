classdef EyeSceneGazeSample
    properties(SetAccess = immutable, GetAccess = ?GazeMapper)
        py_eye_sample
        py_scene_sample
        % py_gaze_sample
    end

    properties
        gaze_sample % struct
        eye_image (:, :, 3) uint8
        scene_image (:, :, 3) uint8
    end

    methods
        function [obj] = EyeSceneGazeSample(eye_sample, scene_sample, gaze_sample)
            obj.py_eye_sample = eye_sample;
            obj.py_scene_sample = scene_sample;
            obj.gaze_sample = gaze_sample;

            % obj.gaze_data = struct();
            % obj.gaze_data.x = gaze_sample.x;
            % obj.gaze_data.y = gaze_sample.y;
            % obj.gaze_data.worn = gaze_sample.worn;
            % obj.gaze_data.timestamp_unix_seconds = gaze_sample.timestamp_unix_seconds;

            obj.eye_image = uint8(py.cv2.cvtColor(eye_sample.bgr_pixels, py.cv2.COLOR_BGR2RGB));
            obj.scene_image = uint8(py.cv2.cvtColor(scene_sample.bgr_pixels, py.cv2.COLOR_BGR2RGB));
        end
    end
end