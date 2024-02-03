classdef Calibration
    properties(GetAccess = ?GazeMapper, SetAccess = private)
        py_calibration
    end

    properties
        scene_camera_matrix (3, 3) double
        scene_distortion_coefficients (8, 1) double
        right_camera_matrix (3, 3) double
        right_distortion_coefficients (8, 1) double
        left_camera_matrix (3, 3) double
        left_distortion_coefficients (8, 1) double
    end

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
        end
    end
end