sca; close all; clear all; clc;

try
    device = Device();
    calibration = device.get_calibration();
    gaze_mapper = GazeMapper(calibration);

    n_tags = 4;
    tag_sz = 64*2;
    wborder = round(0.12*tag_sz);
    for x = 0:n_tags-1
        mpxs = double(MarkerGenerator.generate_marker(x))/255;
        mpxs_rs = imresize(mpxs, [tag_sz-wborder*2, tag_sz-wborder*2], 'nearest');
        mpxs_fin = ones(tag_sz);
        mpxs_fin(wborder:end-(wborder+1), wborder:end-(wborder+1)) = mpxs_rs;
        marker_pixels(x+1, :, :) = mpxs_fin;
    end

    PsychDefaultSetup(2);
    Screen('Preference', 'SkipSyncTests', 1);
    screens = Screen('Screens');
    screenNumber = max(screens);

    grey = 0.5;

    startXpix = 120;
    startYpix = 50;

    dimX = 820;
    dimY = 820;

    [window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey, [startXpix, startYpix, startXpix+dimX, startYpix+dimY]);
    [xCenter, yCenter] = RectCenter(windowRect);
    [wszx, wszy] = Screen('WindowSize', window);
    screen_size = [wszx, wszy];

    marker_verts = [0, 0, tag_sz, tag_sz; ...
                    wszx-tag_sz, 0, wszx, tag_sz; ...
                    wszx-tag_sz, wszy-tag_sz, wszx, wszy; ...
                    0, wszy-tag_sz, tag_sz, wszy];

    screen_surface = gaze_mapper.add_surface(marker_verts, screen_size);

    for x = 1:n_tags
        marker_texs(x) = Screen('MakeTexture', window, squeeze(marker_pixels(x, :, :)));
    end

    baseRect = [0, 0, 100, 100];
    result = [];
    while true
        Screen('FillRect', window, grey);

        for x = 1:n_tags
            Screen('DrawTexture', window, marker_texs(x), [], marker_verts(x, :));
        end

        if ~isempty(result)
            surface_gazes = result.mapped_gaze{screen_surface.uid};
            if ~isempty(surface_gazes)
                surface_gaze = surface_gazes{1};
                gx = surface_gaze.x * wszx;
                gy = (1 - surface_gaze.y) * wszy;
                centeredRect = CenterRectOnPointd(baseRect, gx, gy);
                Screen('FrameOval', window, [1, 0, 0], centeredRect, 10);
            end
        end

        vbl = Screen('Flip', window);

        sc_gz_sample = device.receive_matched_scene_video_frame_and_gaze();
        result = gaze_mapper.process_frame(sc_gz_sample);
    end

    sca;
catch e
    disp(['Error: ', e.message]);
    sca;
    device.close();
end