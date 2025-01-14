sca; close all; clear all; clc;

try
    device = Device();
    calibration = device.get_calibration();
    gaze_mapper = GazeMapper(calibration);

    n_tags = 4;
    tag_sz = 64*3;
    wborder_sz = 25;
    for x = 0:n_tags-1
        mpxs = double(MarkerGenerator.generate_marker(x))/255;
        mpxs_rs = imresize(mpxs, [tag_sz-wborder_sz*2, tag_sz-wborder_sz*2], 'nearest');
        mpxs_fin = ones(tag_sz);
        mpxs_fin(wborder_sz:end-(wborder_sz+1), wborder_sz:end-(wborder_sz+1)) = mpxs_rs;
        marker_pixels(x+1, :, :) = mpxs_fin;
    end

    Screen('Preference', 'SkipSyncTests', 1);
    PsychDefaultSetup(2);
    screens = Screen('Screens');
    screenNumber = max(screens);

    grey = 0.5;

    startXpix = 120;
    startYpix = 50;

    dimX = 820;
    dimY = 820;

    [window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey); %, [startXpix, startYpix, startXpix+dimX, startYpix+dimY]);
    [xCenter, yCenter] = RectCenter(windowRect);
    [wszx, wszy] = Screen('WindowSize', window);
    screen_size = [wszx, wszy];

    marker_verts = [0, 0, tag_sz, tag_sz; ...                 % Rect for Maker 1
        wszx-tag_sz, 0, wszx, tag_sz; ...         % Rect for Maker 2
        wszx-tag_sz, wszy-tag_sz, wszx, wszy; ... % Rect for Maker 3
        0, wszy-tag_sz, tag_sz, wszy];            % Rect for Maker 4

    % needs to be the corners of the black square,
    % so excluding white border
    marker_verts_for_py = zeros(size(marker_verts));
    marker_verts_for_py(:, 1) = marker_verts(:, 1) + wborder_sz;
    marker_verts_for_py(:, 2) = marker_verts(:, 2) + wborder_sz;
    marker_verts_for_py(:, 3) = marker_verts(:, 3) - wborder_sz;
    marker_verts_for_py(:, 4) = marker_verts(:, 4) - wborder_sz;

    screen_surface = gaze_mapper.add_surface(marker_verts_for_py, screen_size);

    for x = 1:n_tags
        marker_texs(x) = Screen('MakeTexture', window, squeeze(marker_pixels(x, :, :)));
    end

    baseRect = [0, 0, 100, 100];
    result = py.None;
    while true
        Screen('FillRect', window, grey);

        for x = 1:n_tags
            Screen('DrawTexture', window, marker_texs(x), [], marker_verts(x, :));
        end

        % was the surface detected?
        if result ~= py.None
            surface_gazes = result.mapped_gaze{screen_surface.uid};
            % is the observer's gaze on the surface?
            if length(surface_gazes) > 0
                surface_gaze = surface_gazes{1};

                % psychtoolbox coordinates are in pixels
                gx = surface_gaze.x * wszx;
                gy = (1 - surface_gaze.y) * wszy;

                centeredRect = CenterRectOnPointd(baseRect, gx, gy);
                Screen('FrameOval', window, [1, 0, 0], centeredRect, 10);
            end
        end

        vbl = Screen('Flip', window);

        sc_gz_sample = device.receive_matched_scene_video_frame_and_gaze();
        result = gaze_mapper.process_frame(sc_gz_sample);

        [keyDown, ~, keyCode, ~] = KbCheck;
        if keyDown && (strcmp(KbName(keyCode), 'q') || strcmp(KbName(keyCode), 'Q'))
            disp('quitting!');
            break;
        end
    end

    sca;
catch e
    disp(['Error: ', e.message]);
    sca;
    device.close();
    clear device;
end