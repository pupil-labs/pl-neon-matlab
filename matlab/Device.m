classdef Device
    properties (SetAccess = private)
        py_device
    end

    properties
        phone_ip char
        phone_name char
        battery_level_percent double
        memory_num_free_bytes double
        module_serial char
        clock_offset_ns double
    end

    methods
        function [obj] = Device(ip, port)
            arguments
                ip char = '192.168.1.172'
                % if connected via hotspot, then this address does not
                % work?
                % ip char = 'neon.local'
                port char = '8080'
            end

            if nargin == 2
                obj.py_device = py.pupil_labs.realtime_api.simple.discover_one_device(ip, port);
            elseif nargin == 0
                obj.py_device = py.pupil_labs.realtime_api.simple.discover_one_device();
            else
                error('Device either needs IP address AND port of a specific Neon device or give no inputs and it will search for a Neon device.');
            end

            obj.phone_ip = char(obj.py_device.phone_ip);
            obj.phone_name = char(obj.py_device.phone_name);
            obj.battery_level_percent = char(obj.py_device.battery_level_percent);
            obj.memory_num_free_bytes = double(obj.py_device.memory_num_free_bytes);
            obj.module_serial = char(obj.py_device.module_serial);

            % the first time these functions run, they are slow.
            % then they are JITed (i guess?) and much faster.
            % so get the JIT/cache process out of the way here,
            % since these are presumably frequently used functions
            obj.py_device.receive_matched_scene_video_frame_and_gaze();
            obj.py_device.receive_matched_scene_and_eyes_video_frames_and_gaze();
            obj.py_device.receive_imu_datum();
            obj.py_device.receive_gaze_datum();

            % for some reason, when sent from MATLAB, the events need a
            % timestamp. otherwise, they are silently dropped on the cloud
            % so, we need to estimate time offset when setting things up
            est = obj.estimate_time_offset();
            obj.clock_offset_ns = fix(est.time_offset_ms.mean * 1000000);

            % sending an event when no recording is running
            % is safe. now it is JITed/cached
            obj.py_device.send_event('noop event', 0);

            return;
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

        function [event] = send_event(obj, event_text, timestamp)
            arguments
                obj Device
                event_text char
                timestamp double = 0
            end

            if nargin == 2
                % when sent from MATLAB, all events need a timestamp,
                % so attach a manually corrected timestamp
                current_time_ns_in_client_clock = get_ns();
                current_time_ns_in_companion_clock = current_time_ns_in_client_clock - obj.clock_offset_ns;
                evt = obj.py_device.send_event(event_text, current_time_ns_in_companion_clock);
            elseif nargin == 3
                evt = obj.py_device.send_event(event_text, timestamp);
            else
                error('Event inputs are event text and an (optional) user-supplied timestamp.');
            end

            event = struct();
            event.name = char(evt.name);
            event.recording_id = char(evt.recording_id);
            event.timestamp_unix_ns = double(evt.timestamp);
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

        function [scene_image, gaze_data] = receive_matched_scene_video_frame_and_gaze(obj)
            scene_and_gaze_sample = obj.py_device.receive_matched_scene_video_frame_and_gaze();

            scene_sample = scene_and_gaze_sample.frame;
            gaze_sample = scene_and_gaze_sample.gaze;

            gaze_data = struct();
            gaze_data.x = gaze_sample.x;
            gaze_data.y = gaze_sample.y;
            gaze_data.worn = gaze_sample.worn;
            gaze_data.timestamp_unix_seconds = gaze_sample.timestamp_unix_seconds;

            scene_image = uint8(py.cv2.cvtColor(scene_sample.bgr_pixels, py.cv2.COLOR_BGR2RGB));

            return;
        end

        function [eye_image, scene_image, gaze_data] = receive_matched_scene_and_eyes_video_frames_and_gaze(obj)
            eye_scene_and_gaze_sample = obj.py_device.receive_matched_scene_and_eyes_video_frames_and_gaze();

            eye_sample = eye_scene_and_gaze_sample.eyes;
            scene_sample = eye_scene_and_gaze_sample.scene;
            gaze_sample = eye_scene_and_gaze_sample.gaze;

            gaze_data = struct();
            gaze_data.x = gaze_sample.x;
            gaze_data.y = gaze_sample.y;
            gaze_data.worn = gaze_sample.worn;
            gaze_data.timestamp_unix_seconds = gaze_sample.timestamp_unix_seconds;

            eye_image = uint8(py.cv2.cvtColor(eye_sample.bgr_pixels, py.cv2.COLOR_BGR2RGB));
            scene_image = uint8(py.cv2.cvtColor(scene_sample.bgr_pixels, py.cv2.COLOR_BGR2RGB));

            return;
        end

        function [calib] = get_calibration(obj)
            calibration = obj.py_device.get_calibration();
            calibration = cell(calibration.tolist());
            calibration = calibration{1};

            scene_camera_matrix = calibration(3);
            scene_distortion_coefficients = calibration(4);
            right_camera_matrix = calibration(6);
            right_distortion_coefficients = calibration(7);
            left_camera_matrix = calibration(9);
            left_distortion_coefficients = calibration(10);

            calib = struct();
            calib.scene_camera_matrix = ndarray2mat(scene_camera_matrix{1});
            calib.scene_distortion_coefficients = ndarray2mat(scene_distortion_coefficients{1});
            calib.right_camera_matrix = ndarray2mat(right_camera_matrix{1});
            calib.right_distortion_coefficients = ndarray2mat(right_distortion_coefficients{1});
            calib.left_camera_matrix = ndarray2mat(left_camera_matrix{1});
            calib.left_distortion_coefficients = ndarray2mat(left_distortion_coefficients{1});

            return;
        end

        function close(obj)
            obj.py_device.close()

            return;
        end

        function [estimate] = estimate_time_offset(obj)
            est = obj.py_device.estimate_time_offset();

            estimate = struct();
            estimate.time_offset_ms = struct();
            estimate.time_offset_ms.mean = est.time_offset_ms.mean;
            estimate.time_offset_ms.median = est.time_offset_ms.median;
            estimate.time_offset_ms.std = est.time_offset_ms.std;
            estimate.time_offset_ms.measurements = double(est.roundtrip_duration_ms.measurements)';

            estimate.roundtrip_duration_ms = struct();
            estimate.roundtrip_duration_ms.mean = est.roundtrip_duration_ms.mean;
            estimate.roundtrip_duration_ms.median = est.roundtrip_duration_ms.median;
            estimate.roundtrip_duration_ms.std = est.roundtrip_duration_ms.std;
            estimate.roundtrip_duration_ms.measurements = double(est.roundtrip_duration_ms.measurements)';

            return;
        end
    end
end