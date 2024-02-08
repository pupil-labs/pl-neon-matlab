clear all; close all; clc;

%%

device = Device();
calibration = device.get_calibration();
gaze_mapper = GazeMapper(calibration);

%%

marker_pixels = MarkerGenerator.generate_marker(0);
figure(1);
imshow(marker_pixels);

%%

marker_verts = struct( ...
   'm0', { ...      % this will be registered as marker id 0
      [32, 32], ... % Top left marker corner
      [96, 32], ... % Top right
      [96, 96], ... % Bottom right
      [32, 96], ... % Bottom left
   } ...
);

screen_size = [1920, 1080];

screen_surface = gaze_mapper.add_surface(marker_verts, screen_size);

%%
 
sc_gz_sample = device.receive_matched_scene_video_frame_and_gaze();
result = gaze_mapper.process_frame(sc_gz_sample);

surface_gazes = result.mapped_gaze{screen_surface.uid};
for sgc = 1:numel(surface_gazes)
   surface_gaze = surface_gazes{sgc};
   disp(['Gaze at ', num2str(surface_gaze.x), ', ', num2str(surface_gaze.y)]);
end

figure(2);
imshow(sc_gz_sample.scene_image);

%%

device.close();