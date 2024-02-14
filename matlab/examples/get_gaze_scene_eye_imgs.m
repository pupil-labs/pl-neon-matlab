clear all; close all; clc;

try
    %% discover and display diagnostic info

    device = Device();

    disp(['Phone IP address: ', device.phone_ip]);
    disp(['Phone name: ', device.phone_name]);
    disp(['Battery level: ', device.battery_level_percent, '%']);
    disp(['Free storage: ', num2str(round(device.memory_num_free_bytes / 1024^3, 2)), ' GB']);
    disp(['Serial number of connected module: ', device.module_serial]);

    %% test gaze datum method

    disp(device.receive_gaze_datum());

    %% receive scene and gaze data

    % [scene_image, gaze_sample] = device.receive_matched_scene_video_frame_and_gaze();
    sc_gz_sample = device.receive_matched_scene_video_frame_and_gaze();

    figure(1);
    imshow(sc_gz_sample.scene_image);
    axis on;
    hold on;
    plot(sc_gz_sample.gaze_data.x, sc_gz_sample.gaze_data.y, 'ro', 'MarkerSize', 30, 'LineWidth', 4);

    %% receive eye, scene and gaze data

    % [eye_image, scene_image, gaze_sample] = device.receive_matched_scene_and_eyes_video_frames_and_gaze();
    ey_sc_gz_sample = device.receive_matched_scene_and_eyes_video_frames_and_gaze();

    figure(2);
    subplot(1, 2, 1);
    imshow(ey_sc_gz_sample.eye_image);
    subplot(1, 2, 2);
    imshow(ey_sc_gz_sample.scene_image);
    axis on;
    hold on;
    plot(ey_sc_gz_sample.gaze_data.x, ey_sc_gz_sample.gaze_data.y, 'ro', 'MarkerSize', 30, 'LineWidth', 4);

    %% close the device

    device.close();
catch e
    disp(['Error: ', e.message]);
    device.close();
end