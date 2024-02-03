clear all; close all; clc;

d = Device();
c = d.get_calibration();
g = GazeMapper(c);
mpx = MarkerGenerator.generate_marker(0);

marker_verts = struct( ...
   'm0', { ... % this will be registered as marker id 0
      [32, 32], ... % Top left marker corner
      [96, 32], ... % Top right
      [96, 96], ... % Bottom right
      [32, 96], ... % Bottom left
   } ...
);

screen_size = [1920, 1080];

screen_surface = g.add_surface(marker_verts, screen_size);

sc_gz_sample = d.receive_matched_scene_video_frame_and_gaze();
result = g.process_frame(sc_gz_sample);

surface_gazes = result.mapped_gaze{screen_surface.uid};
for sgc = 1:numel(surface_gazes)
    surface_gaze = surface_gazes{sgc};
    disp(['Gaze at ', num2str(surface_gaze.x), ', ', num2str(surface_gaze.y)]);
end

figure(1);
imshow(sc_gz_sample.scene_image);

d.close();