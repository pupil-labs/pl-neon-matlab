classdef MarkerGenerator
    methods(Static)
        function [marker_pixels] = generate_marker(marker_id)
            arguments
                marker_id int32
            end

            marker_pixels = uint8(py.pupil_labs.real_time_screen_gaze.marker_generator.generate_marker(marker_id));

            return;
        end
    end
end