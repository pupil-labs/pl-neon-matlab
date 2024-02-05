classdef EyeSceneGazeSample
    % octave does not have immutable properties
    properties(SetAccess = private, GetAccess = ?GazeMapper)
        py_eye_sample
        py_scene_sample
        py_gaze_sample
    endproperties

    properties
        gaze_data
        eye_image
        scene_image
    endproperties

    methods
        function [obj] = EyeSceneGazeSample(eye_sample, scene_sample, gaze_sample)
            obj.py_eye_sample = eye_sample;
            obj.py_scene_sample = scene_sample;
            obj.py_gaze_sample = gaze_sample;

            obj.gaze_data = struct();
            obj.gaze_data.x = gaze_sample.x;
            obj.gaze_data.y = gaze_sample.y;
            obj.gaze_data.worn = gaze_sample.worn;
            obj.gaze_data.timestamp_unix_seconds = gaze_sample.timestamp_unix_seconds;

            % currently no good way with Pythonic to get large ndarray's across the Octave-Python boundary 
            obj.eye_image = py.cv2.cvtColor(eye_sample.bgr_pixels, py.cv2.COLOR_BGR2RGB);
            obj.scene_image = py.cv2.cvtColor(scene_sample.bgr_pixels, py.cv2.COLOR_BGR2RGB);
        endfunction
    endmethods
endclassdef