clear all; close all; clc;

try
    %% discover and display diagnostic info

    device = Device();

    disp(['Phone IP address: ', device.phone_ip]);
    disp(['Phone name: ', device.phone_name]);
    disp(['Battery level: ', device.battery_level_percent, '%']);
    % octave's round does not accept additional arguments
    disp(['Free storage: ', num2str(round(device.memory_num_free_bytes / 1024^3)), ' GB']);
    disp(['Serial number of connected module: ', device.module_serial]);

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
    disp(device.send_event('test event 3 (from octave on Windows!)'));

    device.recording_stop_and_save();

    %% close the device

    device.close();
catch e
    disp(['Error: ', e.message]);
    device.close();
    __py_objstore_clear__();
    clear device;
end