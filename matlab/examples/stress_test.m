clear all; close all; clc;

try
    %% discover and display diagnostic info

    device = Device();

    disp(['Phone IP address: ', device.phone_ip]);
    disp(['Phone name: ', device.phone_name]);
    disp(['Battery level: ', device.battery_level_percent, '%']);
    disp(['Free storage: ', num2str(round(device.memory_num_free_bytes / 1024^3, 2)), ' GB']);
    disp(['Serial number of connected module: ', device.module_serial]);

    %% stress test comparison

    t = [];
    for x = 1:500
        tic;
        device.receive_gaze_datum();
        t(x) = toc;
    end

    figure(3);
    hold on;
    histogram(t);

    %% close the device

    device.close();
catch e
    disp(['Error: ', e.message]);
    device.close();
    clear device;
end