classdef Device
  properties (SetAccess = private)
    py_device
  endproperties
  
  properties
    % octave does not support specifying types on props
    phone_ip
    phone_name
    battery_level_percent
    memory_num_free_bytes
    module_serial
    clock_offset_ns
  endproperties
  
  methods
    function [obj] = Device(ip, port)
      % no keyword arguments or type specifying of arguments in octave
      
      check_and_load_pythonic();
      
      pyexec("from pupil_labs.realtime_api.simple import discover_one_device");
      
      if nargin == 2
        pyexec(['device = discover_one_device(', ip, ', ', port, ')']);
        obj.py_device = pyeval("device");
      elseif nargin == 0
        pyexec('device = discover_one_device()');
        obj.py_device = pyeval("device");
      else
        error('Device either needs IP address AND port of a specific Neon device or give no inputs and it will search for a Neon device.');
      endif
      
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

      % for some reason, when sent from octave, the events need a
      % timestamp. otherwise, they are silently dropped on the cloud
      % so, we need to estimate time offset when setting things up
      est = obj.estimate_time_offset();
      obj.clock_offset_ns = fix(est.time_offset_ms.mean * 1000000);
      
      % sending an event when no recording is running
      % is safe. now it is JITed/cached
      obj.py_device.send_event('noop event', 0);

      % due to a peculiarity of Pythonic, it is easiest
      % to cache the calibration on the Python side here,
      % to be used later by the GazeMapper class
      pyexec('py_cached_calibration = device.get_calibration()');
      
      return;
    endfunction
    
    function [rid] = recording_start(obj)
      rid = obj.py_device.recording_start();
      rid = char(rid);
      
      return;
    endfunction
    
    function recording_stop_and_save(obj)
      obj.py_device.recording_stop_and_save();
      
      return;
    endfunction
    
    function [event] = send_event(obj, event_text, timestamp)
      % no keyword arguments or type specifying of arguments in octave
      
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
      endif
      
      event = struct();
      event.name = char(evt.name);
      event.recording_id = char(evt.recording_id);
      event.timestamp_unix_ns = double(evt.timestamp);
      event.datetime = datestr(datenum(evt.datetime(1:end-3), 'yyyy-mm-dd HH:MM:SS.FFF'));
      
      return;
    endfunction
    
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
    endfunction
    
    function [gaze_data] = receive_gaze_datum(obj)
      gaze_sample = obj.py_device.receive_gaze_datum();
      
      gaze_data = struct();
      gaze_data.x = gaze_sample.x;
      gaze_data.y = gaze_sample.y;
      gaze_data.worn = gaze_sample.worn;
      gaze_data.timestamp_unix_seconds = gaze_sample.timestamp_unix_seconds;
      
      return;
    endfunction
    
    % function [scene_image, gaze_data] = receive_matched_scene_video_frame_and_gaze(obj)
    function [sc_gz_sample] = receive_matched_scene_video_frame_and_gaze(obj)
      scene_and_gaze_sample = obj.py_device.receive_matched_scene_video_frame_and_gaze();
      
      scene_sample = scene_and_gaze_sample.frame;
      gaze_sample = scene_and_gaze_sample.gaze;
      
      sc_gz_sample = SceneGazeSample(scene_sample, gaze_sample);

      return;
    endfunction
    
    % function [eye_image, scene_image, gaze_data] = receive_matched_scene_and_eyes_video_frames_and_gaze(obj)
    function [ey_sc_gz_sample] = receive_matched_scene_and_eyes_video_frames_and_gaze(obj)
      eye_scene_and_gaze_sample = obj.py_device.receive_matched_scene_and_eyes_video_frames_and_gaze();
      
      eye_sample = eye_scene_and_gaze_sample.eyes;
      scene_sample = eye_scene_and_gaze_sample.scene;
      gaze_sample = eye_scene_and_gaze_sample.gaze;
      
      ey_sc_gz_sample = EyeSceneGazeSample(eye_sample, scene_sample, gaze_sample);

      return;
    endfunction
    
    function [calib_out] = get_calibration(obj)
      py_calibration = obj.py_device.get_calibration();
      calibration = cell(py_calibration.tolist());
      calibration = calibration{1};
      
      scene_camera_matrix = calibration{3};
      scene_distortion_coefficients = calibration{4};
      right_camera_matrix = calibration{6};
      right_distortion_coefficients = calibration{7};
      left_camera_matrix = calibration{9};
      left_distortion_coefficients = calibration{10};
      
      mat_calibration = struct();
      mat_calibration.scene_camera_matrix = ndarray2mat(scene_camera_matrix, 3, 3, 0);
      mat_calibration.scene_distortion_coefficients = ndarray2mat(scene_distortion_coefficients, 1, 8, 0)';
      mat_calibration.right_camera_matrix = ndarray2mat(right_camera_matrix, 3, 3, 0);
      mat_calibration.right_distortion_coefficients = ndarray2mat(right_distortion_coefficients, 1, 8, 0)';
      mat_calibration.left_camera_matrix = ndarray2mat(left_camera_matrix, 3, 3, 0);
      mat_calibration.left_distortion_coefficients = ndarray2mat(left_distortion_coefficients, 1, 8, 0)';

      calib_out = Calibration(py_calibration, mat_calibration);
      
      return;
    endfunction
    
    function close(obj)
      obj.py_device.close();
      
      return;
    endfunction
    
    function [estimate] = estimate_time_offset(obj)
      est = obj.py_device.estimate_time_offset();
      
      estimate = struct();
      estimate.time_offset_ms = struct();
      estimate.time_offset_ms.mean = est.time_offset_ms.mean;
      estimate.time_offset_ms.median = est.time_offset_ms.median;
      estimate.time_offset_ms.std = est.time_offset_ms.std;
      estimate.time_offset_ms.measurements = ndarray2mat(est.roundtrip_duration_ms.measurements, 1, 100, 0)';
      
      estimate.roundtrip_duration_ms = struct();
      estimate.roundtrip_duration_ms.mean = est.roundtrip_duration_ms.mean;
      estimate.roundtrip_duration_ms.median = est.roundtrip_duration_ms.median;
      estimate.roundtrip_duration_ms.std = est.roundtrip_duration_ms.std;
      estimate.roundtrip_duration_ms.measurements = ndarray2mat(est.roundtrip_duration_ms.measurements, 1, 100, 0)';
      
      return;
    endfunction
  endmethods
  endclassdef