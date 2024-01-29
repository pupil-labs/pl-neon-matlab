clear all; close all; clc;

%% discover and display diagnostic info

device = py.pupil_labs.realtime_api.simple.discover_one_device();
% device = py.pupil_labs.realtime_api.simple.Device('192.168.1.172', '8080');

disp(['Phone IP address: ', char(device.phone_ip)]);
disp(['Phone name: ', char(device.phone_name)]);
disp(['Battery level: ', char(device.battery_level_percent), '%']);
disp(['Free storage: ', num2str(round(double(device.memory_num_free_bytes) / 1024^3, 2)), ' GB']);
disp(['Serial number of connected module: ', char(device.module_serial)]);

%% run a test recording

recording_id = device.recording_start();
disp(['Started recording with id ', char(recording_id)]);

pause(5);

device.recording_stop_and_save();

%% send some test events

device.recording_start();

% events are not registered... hmm...
disp(device.send_event('test event 1'));

pause(5);

% send event with current timestamp
% GetSecs is a Psychtoolbox function, and is listed in the 'top 10 worst
% function names of all time'
% fails in Python with following error:
% Python Error: ContentTypeError: 0, message='Attempt to decode JSON
% with unexpected mimetype: text/plain',
% url=URL('http://192.168.1.172:8080/api/event')
%
% something goes wrong across the matlab-python boundary...
% disp(device.send_event('test event 2', GetSecs()));

device.recording_stop_and_save();

%% receive scene and gaze data

scene_and_gaze_sample = device.receive_matched_scene_video_frame_and_gaze();

scene_image_rgb = py.cv2.cvtColor(scene_sample.bgr_pixels, py.cv2.COLOR_BGR2RGB);

figure(1);
imshow(scene_image_rgb);
plot(gaze_sample.x, gaze_sample.y, 'ro');

%% investigate IMU data

imu_sample = device.receive_imu_datum();

% dt = datetime.fromtimestamp(imu_sample.timestamp_unix_seconds);
dt = imu_sample.timestamp_unix_seconds;
disp(['This IMU sample was recorded at ', num2str(dt)]);

disp('It contains the following data:');

disp('Head pose:');
disp(imu_sample.quaternion);

disp('Acceleration data:');
disp(imu_sample.accel_data);

disp('Gyro data:');
disp(imu_sample.gyro_data);

%% print out scene camera calibration data

calibration = device.get_calibration();
calibration = cell(calibration.tolist());
calibration = calibration{1};

scene_camera_matrix = calibration(3);
scene_distortion_coefficients = calibration(4);
right_camera_matrix = calibration(6);
right_distortion_coefficients = calibration(7);
left_camera_matrix = calibration(9);
left_distortion_coefficients = calibration(10);

disp('Scene camera matrix:');
disp(scene_camera_matrix);
disp('Scene distortion coefficients:');
disp(scene_distortion_coefficients);

disp('Right camera matrix:');
disp(right_camera_matrix);
disp('Right distortion coefficients:');
disp(right_distortion_coefficients);

disp('Left camera matrix:');
disp(left_camera_matrix);
disp('Left distortion coefficients:');
disp(left_distortion_coefficients);

%% test some other methods

device.receive_imu_datum();
device.receive_gaze_datum();

%% stress test comparison
t = [];
for x = 1:500
    tic;
    % pupil_labs_realtime_api('Command', 'status', 'URLhost', 'http://neon.local:8080/');
    pupil_labs_realtime_api('Command', 'status', 'URLhost', 'http://192.168.1.172:8080/');
    t(x) = toc;
end

t2 = [];
for x = 1:500
    tic;
    device.receive_gaze_datum();
    t2(x) = toc;
end

figure(2);
hold on;
histogram(t);
histogram(t2);