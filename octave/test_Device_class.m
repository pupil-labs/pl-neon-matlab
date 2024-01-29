clear all; close all; clc;

%% discover and display diagnostic info

device = Device();

disp(['Phone IP address: ', device.phone_ip]);
disp(['Phone name: ', device.phone_name]);
disp(['Battery level: ', device.battery_level_percent, '%']);
% octave's round does not accept additional arguments
disp(['Free storage: ', num2str(round(device.memory_num_free_bytes / 1024^3)), ' GB']);
disp(['Serial number of connected module: ', device.module_serial]);

%% run a test recording

recording_id = device.recording_start();
disp(['Started recording with id ', recording_id]);

pause(5);

device.recording_stop_and_save();

%% send some test events

device.recording_start();

disp(device.send_event('test event 1'));

pause(5);

% send event with current timestamp (make sure it is an integer,
% otherwise you will get a cryptic error!)
disp(device.send_event('test event 2', get_ns()));

% event 1 is sent before recording starts.
% so send another test even to be sure also works when no timestamp provided by
% user
disp(device.send_event('test event 3 (from octave!)'));

device.recording_stop_and_save();

%% receive scene and gaze data

[scene_image, gaze_sample] = device.receive_matched_scene_video_frame_and_gaze();

figure(1);
% imshow(scene_image);
axis on;
hold on;
plot(gaze_sample.x, gaze_sample.y, 'ro', 'MarkerSize', 30, 'LineWidth', 4);

%% receive eye, scene and gaze data

[eye_image, scene_image, gaze_sample] = device.receive_matched_scene_and_eyes_video_frames_and_gaze();

figure(2);
subplot(1, 2, 1);
% imshow(eye_image);
subplot(1, 2, 2);
% imshow(scene_image);
axis on;
hold on;
plot(gaze_sample.x, gaze_sample.y, 'ro', 'MarkerSize', 30, 'LineWidth', 4);

%% investigate IMU data

imu_sample = device.receive_imu_datum();

dt = secToDateTime(imu_sample.timestamp_unix_seconds);
disp(['This IMU sample was recorded at ', char(dt)]);

disp('It contains the following data:');

disp('Head pose:');
disp(imu_sample.quaternion);

disp('Acceleration data:');
disp(imu_sample.accel_data);

disp('Gyro data:');
disp(imu_sample.gyro_data);

%% print out scene camera calibration data

calibration = device.get_calibration();

disp('Scene camera matrix:');
disp(calibration.scene_camera_matrix);
disp('Scene distortion coefficients:');
disp(calibration.scene_distortion_coefficients);

disp('Right camera matrix:');
disp(calibration.right_camera_matrix);
disp('Right distortion coefficients:');
disp(calibration.right_distortion_coefficients);

disp('Left camera matrix:');
disp(calibration.left_camera_matrix);
disp('Left distortion coefficients:');
disp(calibration.left_distortion_coefficients);

%% test gaze datum method

disp(device.receive_gaze_datum());

%% what is time offset

estimate = device.estimate_time_offset();

disp(['Mean time offset: ', num2str(estimate.time_offset_ms.mean), ' ms']);
disp(['Mean roundtrip duration: ', num2str(estimate.roundtrip_duration_ms.mean), ' ms']);

%% stress test comparison

t = [];
for x = 1:500
    tic;
    device.receive_gaze_datum();
    t(x) = toc;
end

figure(3);
hold on;
hist(t);

%% close the device

device.close();