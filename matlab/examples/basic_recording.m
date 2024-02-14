clear all; close all; clc;

try
    %% discover and display diagnostic info

    device = Device();

    disp(['Phone IP address: ', device.phone_ip]);
    disp(['Phone name: ', device.phone_name]);
    disp(['Battery level: ', device.battery_level_percent, '%']);
    disp(['Free storage: ', num2str(round(device.memory_num_free_bytes / 1024^3, 2)), ' GB']);
    disp(['Serial number of connected module: ', device.module_serial]);

    %% run a test recording

    recording_id = device.recording_start();
    disp(['Started recording with id ', recording_id]);

    pause(5);

    device.recording_stop_and_save();

    %% close the device

    device.close();
catch e
    disp(['Error: ', e.message]);
    device.close();
end