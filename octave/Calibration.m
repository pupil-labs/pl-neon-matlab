classdef Calibration
    % octave does not have immutable properties
    properties(GetAccess = ?GazeMapper, SetAccess = private)
        py_calibration
    endproperties

    properties
        scene_camera_matrix
        scene_distortion_coefficients
        right_camera_matrix
        right_distortion_coefficients
        left_camera_matrix
        left_distortion_coefficients
    endproperties

    methods
        function [obj] = Calibration(py_calibration, calibration)
            obj.py_calibration = py_calibration;

            obj.scene_camera_matrix = calibration.scene_camera_matrix;
            obj.scene_distortion_coefficients = calibration.scene_distortion_coefficients;
            obj.right_camera_matrix = calibration.right_camera_matrix;
            obj.right_distortion_coefficients = calibration.right_distortion_coefficients;
            obj.left_camera_matrix = calibration.left_camera_matrix;
            obj.left_distortion_coefficients = calibration.left_distortion_coefficients;

            return;
        endfunction
    endmethods
endclassdef