% DEMO pupil labs simple API and Psychtoolbox

clear; close all; clc;
sca;

try
    % Initiate connection to Neon Companion Device
    device = Device();

    % Get the screen prefs
    Screen('Preference', 'SkipSyncTests', 1);
    Screen('Preference', 'VisualDebugLevel', 0);
    Screen('Preference', 'SuppressAllWarnings', 1);
    [w, rect] = Screen('OpenWindow', max(Screen('Screens')), 0.5);

    % Load some pictures from Unsplash
    I.im1 = imread("https://images.unsplash.com/photo-1617339860632-f53c5b5dce4d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cHVwaWx8ZW58MHx8MHx8&auto=format&fit=crop&w=1600&q=60");
    I.im2 = imread("https://images.unsplash.com/photo-1629872430082-93d8912beccf?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTJ8fHB1cGlsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=1600&q=60");
    I.im3 = imread("https://images.unsplash.com/photo-1603695762547-fba8b88ac8ad?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fHB1cGlsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=1600&q=60");
    I.im4 = imread("https://images.unsplash.com/photo-1560969184-10fe8719e047?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8YmVybGlufGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=1600&q=60");
    I.im5 = imread("https://images.unsplash.com/photo-1580428354768-03a028646bc8?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTF8fHRleHR8ZW58MHx8MHx8&auto=format&fit=crop&w=1600&q=60");

    % Load april tags (Uncomment to load them)
    % apriltags_image = imread('https://docs.pupil-labs.com/assets/img/apriltags_tag36h11_0-23.37196546.jpg');
    % for ind= 1:4
    %     A.(['a',num2str(ind)]) = Screen('MakeTexture',w,...
    %         repmat(uint8(imcrop(apriltags_image, [66 66 382 382]+[0 384*(ind-1) 0 0])), 1 , 1, 3));
    % end

    % Define colors to be used
    c.GrayColor = [256/2 256/2 256/2 0];
    c.WhiteColor = WhiteIndex(max(Screen('Screens')));
    c.BlackColor = BlackIndex(max(Screen('Screens')));
    c.RedColor = [255 0 0]; c.GreenColor = [0 255 0]; c.YellowColor = [255 255 0];

    % Get the screen
    [SP.Xpixels, SP.Ypixels] = Screen('WindowSize', w);
    [SP.xc, SP.yc] = RectCenter(rect);

    % Initiate recording before we actually run the experiment
    device.recording_start();

    % Start screen display
    Screen('Preference', 'SkipSyncTests', 1);

    PsychDefaultSetup(1);
    topPriorityLevel = MaxPriority(w);
    AssertOpenGL;
    % Gray background
    [w, rect] = PsychImaging('OpenWindow', max(Screen('Screens')), c.WhiteColor / 2, [], 32, 2, ...
        [], [], kPsychNeed32BPCFloat);
    HideCursor;
    Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    % Icon pre-display
    Screen('FrameOval', w, c.BlackColor, ...
        [SP.Xpixels / 2 - 450, SP.Ypixels / 2 - 450, SP.Xpixels / 2 + 450, SP.Ypixels / 2 + 450], 100);
    Screen('FrameOval', w, c.BlackColor, ...
        [SP.Xpixels / 2 - 300, SP.Ypixels / 2 - 300, SP.Xpixels / 2 + 300, SP.Ypixels / 2 + 300], 100);
    Screen('Flip', w);

    % Press a key to start
    KbStrokeWait;

    % Show images experiment
    Screen('BlendFunction', w, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

    for n = 1:5
        % Place April tags on the corners (Uncomment to place them)
        % Screen('DrawTexture', w, A.a1, [], [0 0 383 383], 0);
        % Screen('DrawTexture', w, A.a2, [], [SP.Xpixels-384 0 SP.Xpixels 383], 0);
        % Screen('DrawTexture', w, A.a3, [], [0 SP.Ypixels-384 383 SP.Ypixels], 0);
        % Screen('DrawTexture', w, A.a4, [], [SP.Xpixels-384 SP.Ypixels-384 SP.Xpixels SP.Ypixels], 0);
        % Prepare image
        imageTexture = Screen('MakeTexture', w, I.(['im', num2str(n)]));
        Screen('DrawTexture', w, imageTexture, [], [], 0);
        % Update display
        Screen('Flip', w);
        % Send start event annotation
        device.send_event(['Picture_', num2str(n, '%02.0f'), '_start']);
        % Wait 4 sec
        WaitSecs(4);
        % Send event end annotation
        device.send_event(['Picture_', num2str(n, '%02.0f'), '_end']);
    end

    % Now stop and save the recording
    device.recording_stop_and_save();
catch lasterror
    device.recording_cancel();
    disp(['Error: ', lasterror.message]);
    try
        psychrethrow(psychlasterror );
    end
    
    commandwindow;
end

device.close();
clear device;

% Close Psychtoolbox window:
RestrictKeysForKbCheck([]);
FlushEvents;
sca;
Priority(0);
ShowCursor;
