clear all; close all; clc;

try
    %% discover and display diagnostic info

    device = Device();

    disp(['Phone IP address: ', device.phone_ip]);
    disp(['Phone name: ', device.phone_name]);
    disp(['Battery level: ', device.battery_level_percent, '%']);
    disp(['Free storage: ', num2str(round(device.memory_num_free_bytes / 1024^3, 2)), ' GB']);
    disp(['Serial number of connected module: ', device.module_serial]);

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

    %% what is time offset

    estimate = device.estimate_time_offset();

    disp(['Mean time offset: ', num2str(estimate.time_offset_ms.mean), ' ms']);
    disp(['Mean roundtrip duration: ', num2str(estimate.roundtrip_duration_ms.mean), ' ms']);

    %% close the device

    device.close();
catch e
    disp(['Error: ', e.message]);
    device.close();
    clear device;
end