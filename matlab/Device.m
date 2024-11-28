classdef Device < handle
    properties (GetAccess = private, SetAccess = immutable)
        py_device
    end

    properties
        phone_ip char
        phone_name char
        battery_level_percent char
        memory_num_free_bytes double
        module_serial char
        serial_number_glasses char
        is_neon logical
        is_pupil_invisible logical
    end

    methods
        function [obj] = Device(ip, port)
            if nargin == 2
                try
                    disp('Searching for device...');
                    obj.py_device = py.pupil_labs.realtime_api.simple.Device(ip, uint32(port));
                catch e
                    error('Could not find device at the given IP address and port.');
                end
            elseif nargin == 0
                try
                    disp('Searching for device...');
                    obj.py_device = py.pupil_labs.realtime_api.simple.discover_one_device();
                catch e
                    error('Could not find any device.');
                end
            else
                error('Device either needs IP address AND port of a specific Neon device or give no inputs and it will search for a Neon device.');
            end

            disp('Device found!');

            % matlab does automatic type conversion here
            obj.phone_ip = obj.py_device.phone_ip;
            obj.phone_name = obj.py_device.phone_name;
            obj.battery_level_percent = obj.py_device.battery_level_percent;
            obj.memory_num_free_bytes = obj.py_device.memory_num_free_bytes;

            % for Neon
            obj.module_serial = obj.py_device.module_serial;

            % for Pupil Invisible
            obj.serial_number_glasses = obj.py_device.serial_number_glasses;

            % serial_number_glasses is specific to Pupil Invisible
            obj.is_neon = strcmp(obj.serial_number_glasses, '-1');
            if obj.is_neon && ~strcmp(obj.phone_name, 'Neon Companion')
                error('Neon is somehow connected to Pupil Invisible Companion app. This is not supported.');
            end

            obj.is_pupil_invisible = ~obj.is_neon;

            % initialize common streams
            obj.py_device.receive_matched_scene_video_frame_and_gaze();
            obj.py_device.receive_scene_video_frame();
            obj.py_device.receive_gaze_datum();

            % Pupil Invisible does not stream IMU data or eye video
            if obj.is_neon
                obj.py_device.receive_imu_datum();
                obj.py_device.receive_eyes_video_frame();
                obj.py_device.receive_matched_scene_and_eyes_video_frames_and_gaze();
            end

            % sending an event when no recording is running
            % is safe. now the function is JITed/cached
            obj.py_device.send_event('noop event', 0);

            return;
        end

        function delete(obj)
            obj.py_device.close();
        end

        function [rid] = recording_start(obj)
            rid = obj.py_device.recording_start();
            rid = char(rid);

            return;
        end

        function recording_stop_and_save(obj)
            obj.py_device.recording_stop_and_save();

            return;
        end

        function recording_cancel(obj)
            obj.py_device.recording_cancel();

            return;
        end

        function [event] = send_event(obj, event_name, timestamp)
            if nargin == 2
                % `string(missing)` is how you send a "None" value over the MATLAB->Python boundary
                evt = obj.py_device.send_event(event_name, pyargs('event_timestamp_unix_ns', string(missing)));
            elseif nargin == 3
                evt = obj.py_device.send_event(event_name, pyargs('event_timestamp_unix_ns', timestamp));
            else
                error('Event inputs are event name (string) and an (optional) user-supplied timestamp.');
            end

            event = struct();
            event.name = char(evt.name);
            event.recording_id = char(evt.recording_id);
            event.timestamp_unix_ns = int64(evt.timestamp);
            event.datetime = evt.datetime;

            return;
        end

        function [imu_data] = receive_imu_datum(obj)
            imu_sample = obj.py_device.receive_imu_datum();

            imu_data = struct();

            imu_data.timestamp_unix_seconds = imu_sample.timestamp_unix_seconds;

            quat = struct();
            quat.x = imu_sample.quaternion.x;
            quat.y = imu_sample.quaternion.y;
            quat.z = imu_sample.quaternion.z;
            quat.w = imu_sample.quaternion.w;

            imu_data.quaternion = quat;

            accel_data = struct();
            accel_data.x = imu_sample.accel_data.x;
            accel_data.y = imu_sample.accel_data.y;
            accel_data.z = imu_sample.accel_data.z;

            imu_data.accel_data = accel_data;

            gyro_data = struct();
            gyro_data.x = imu_sample.gyro_data.x;
            gyro_data.y = imu_sample.gyro_data.y;
            gyro_data.z = imu_sample.gyro_data.z;

            imu_data.gyro_data = gyro_data;

            return;
        end

        function [gaze_data] = receive_gaze_datum(obj)
            gaze_sample = obj.py_device.receive_gaze_datum();

            gaze_data = struct();
            gaze_data.x = gaze_sample.x;
            gaze_data.y = gaze_sample.y;
            gaze_data.worn = gaze_sample.worn;
            gaze_data.timestamp_unix_seconds = gaze_sample.timestamp_unix_seconds;

            return;
        end

        % function [scene_image, gaze_data] = receive_matched_scene_video_frame_and_gaze(obj)
        function [sc_gz_sample] = receive_matched_scene_video_frame_and_gaze(obj)
            py_scene_and_gaze_sample = obj.py_device.receive_matched_scene_video_frame_and_gaze();

            scene_sample = py_scene_and_gaze_sample.frame;
            gaze_sample = py_scene_and_gaze_sample.gaze;

            sc_gz_sample = SceneGazeSample(scene_sample, gaze_sample);

            return;
        end

        % function [eye_image, scene_image, gaze_data] = receive_matched_scene_and_eyes_video_frames_and_gaze(obj)
        function [ey_sc_gz_sample] = receive_matched_scene_and_eyes_video_frames_and_gaze(obj)
            eye_scene_and_gaze_sample = obj.py_device.receive_matched_scene_and_eyes_video_frames_and_gaze();

            eye_sample = eye_scene_and_gaze_sample.eyes;
            scene_sample = eye_scene_and_gaze_sample.scene;
            gaze_sample = eye_scene_and_gaze_sample.gaze;

            ey_sc_gz_sample = EyeSceneGazeSample(eye_sample, scene_sample, gaze_sample);

            return;
        end

        function [calib_out] = get_calibration(obj)
            if obj.is_neon
                py_calibration = obj.py_device.get_calibration();
                calibration = cell(py_calibration.tolist());
                calibration = calibration{1};
    
                scene_camera_matrix = calibration(3);
                scene_distortion_coefficients = calibration(4);
                scene_extrinsics_affine_matrix = calibration(5);

                right_camera_matrix = calibration(6);
                right_distortion_coefficients = calibration(7);
                right_extrinsics_affine_matrix = calibration(8);

                left_camera_matrix = calibration(9);
                left_distortion_coefficients = calibration(10);
                left_extrinsics_affine_matrix = calibration(11);
    
                mat_calibration = struct();
                mat_calibration.scene_camera_matrix = ndarray2mat(scene_camera_matrix{1});
                mat_calibration.scene_distortion_coefficients = ndarray2mat(scene_distortion_coefficients{1});
                mat_calibration.scene_extrinsics_affine_matrix = ndarray2mat(scene_extrinsics_affine_matrix{1});

                mat_calibration.right_camera_matrix = ndarray2mat(right_camera_matrix{1});
                mat_calibration.right_distortion_coefficients = ndarray2mat(right_distortion_coefficients{1});
                mat_calibration.right_extrinsics_affine_matrix = ndarray2mat(right_extrinsics_affine_matrix{1});

                mat_calibration.left_camera_matrix = ndarray2mat(left_camera_matrix{1});
                mat_calibration.left_distortion_coefficients = ndarray2mat(left_distortion_coefficients{1});
                mat_calibration.left_extrinsics_affine_matrix = ndarray2mat(left_extrinsics_affine_matrix{1});
    
                calib_out = Calibration(py_calibration, mat_calibration);
    
                return;
            else
                warning('Pupil Invisible does not provide camera calibration data over the Real-time API.');

                calib_out = [];

                return;
            end
        end

        function close(obj)
            obj.py_device.close();

            return;
        end

        function [estimate] = estimate_time_offset(obj)
            est = obj.py_device.estimate_time_offset();

            estimate = struct();
            estimate.time_offset_ms = struct();
            estimate.time_offset_ms.mean = est.time_offset_ms.mean;
            estimate.time_offset_ms.median = est.time_offset_ms.median;
            estimate.time_offset_ms.std = est.time_offset_ms.std;
%             estimate.time_offset_ms.measurements = double(est.roundtrip_duration_ms.measurements)';
            estimate.time_offset_ms.measurements = cellfun(@double, cell(est.roundtrip_duration_ms.measurements))';

            estimate.roundtrip_duration_ms = struct();
            estimate.roundtrip_duration_ms.mean = est.roundtrip_duration_ms.mean;
            estimate.roundtrip_duration_ms.median = est.roundtrip_duration_ms.median;
            estimate.roundtrip_duration_ms.std = est.roundtrip_duration_ms.std;
%             estimate.roundtrip_duration_ms.measurements = double(est.roundtrip_duration_ms.measurements)';
            estimate.roundtrip_duration_ms.measurements = cellfun(@double, cell(est.roundtrip_duration_ms.measurements))';

            return;
        end
    end
end
