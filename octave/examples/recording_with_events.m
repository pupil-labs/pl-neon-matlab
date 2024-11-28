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

    %% detemine clock offset to send offset corrected events

    est = device.estimate_time_offset();
    clock_offset_ns = int64(fix(est.time_offset_ms.mean * 1000000));

    %% send some test events

    device.recording_start();
    
    pause(2);

    disp(device.send_event('test event 1'));

    pause(2);

    % send event with current timestamp (make sure it is an integer,
    % otherwise you will get a cryptic error!)
    % disp(device.send_event('test event 2', get_ns()));

    % send event with user-provided offset corrected timestamp
    % (make sure it is an integer, otherwise you will get a cryptic error!)
    % See following links for more info:
    %
    % https://docs.pupil-labs.com/neon/data-collection/time-synchronization/#improving-synchronization-further
    %
    % https://pupil-labs-realtime-api.readthedocs.io/en/stable/examples/simple.html#send-event
    current_time_ns_in_client_clock = get_ns();
    current_time_ns_in_neon_clock = current_time_ns_in_client_clock - clock_offset_ns;
    disp(device.send_event('test event 2', current_time_ns_in_neon_clock));

    pause(2);

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