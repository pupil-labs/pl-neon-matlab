classdef MarkerGenerator
    methods(Static)
        function [marker_pixels] = generate_marker(marker_id)
            check_and_load_pythonic();

            pyexec("from pupil_labs.real_time_screen_gaze.marker_generator import generate_marker");

            pyexec(['marker_pixels = generate_marker(', num2str(marker_id), ')']);
            marker_pixels = pyeval('marker_pixels');
            marker_pixels = uint8(ndarray2mat(marker_pixels, 8, 8, 0));

            return;
        endfunction
    endmethods
endclassdef