function dynacat_saveFreeviewVisualizations(session_path, fs_path, fs_id, contrast_name)
% dynacat_saveFreeviewVisualizations(fsPath, vistaPath)
% saves FreeView visualized contrast maps into PNGs for both lh and rh
% 
% Inputs
% session_path      path to the subject's DynaCat session folder
% fs_path           path to freesurfer directory 
% fs_id             subject's id within the freesurfer directory
% contrast_name     name of the contrast to visualize
%
% example:
% session_path      '/share/kalanit/biac2/kgs/projects/DynamicCategories/data/DynaCat/subj-03/session1/'
% fs_path           '/share/kalanit/biac2/kgs/anatomy/freesurferRecon'
% fs_id             'ek202011_v60'
% contrast_name     'faces-normal_vs_all'
%
% BR July 2023!
 

% Paths to FreeSurfer data
fsDir = fullfile(fs_path, fs_id);
lh_surf = fullfile(fsDir, 'surf', 'lh.inflated');
rh_surf = fullfile(fsDir, 'surf', 'rh.inflated');
lh_contrast_name = [contrast_name '_lh.mgh'];
lh_contrast = fullfile(fsDir, 'surf', lh_contrast_name);
rh_contrast_name = [contrast_name '_rh.mgh'];
rh_contrast = fullfile(fsDir, 'surf', rh_contrast_name);

% Set-up image saving
images_dir = fullfile(session_path, 'Images');
lh_lateral_image_filename = ['lh_lateral_' contrast_name '.png'];
lh_lateral_outputImage = fullfile(images_dir, lh_lateral_image_filename);
lh_ventral_image_filename = ['lh_ventral_' contrast_name '.png'];
lh_ventral_outputImage = fullfile(images_dir, lh_ventral_image_filename);

rh_lateral_image_filename = ['rh_lateral_' contrast_name '.png'];
rh_lateral_outputImage = fullfile(images_dir, rh_lateral_image_filename);
rh_ventral_image_filename = ['rh_ventral_' contrast_name '.png'];
rh_ventral_outputImage = fullfile(images_dir, rh_ventral_image_filename);

% Load the lh surf and overlay the lh contrast map on the inflated surface
% removed  -colorscale but should add back in if needed later
% lateral view
command = sprintf('freeview -f %s:overlay=%s:overlay_threshold=0.5,3:overlay_color=colorwheel,inverse -viewport 3d -view lateral -layout 1 -zoom 1.5 --screenshot %s', lh_surf, lh_contrast, lh_lateral_outputImage);
system(command);
% ventral view
command = sprintf('freeview -f %s:overlay=%s:overlay_threshold=0.5,3:overlay_color=colorwheel,inverse -viewport 3d -view inferior -cam Roll 90 -layout 1 -zoom 1.5 --screenshot %s', lh_surf, lh_contrast, lh_ventral_outputImage);
system(command);

% Load the rh surf and overlay the rh contrast map on the inflated surface
% lateral view
command = sprintf('freeview -f %s:overlay=%s:overlay_threshold=0.5,3:overlay_color=colorwheel,inverse -viewport 3d -view lateral -layout 1 -zoom 1.5 --screenshot %s', rh_surf, rh_contrast, rh_lateral_outputImage);
system(command);
% ventral view
command = sprintf('freeview -f %s:overlay=%s:overlay_threshold=0.5,3:overlay_color=colorwheel,inverse -viewport 3d -view inferior -cam Roll 90 -layout 1 -zoom 1.5 --screenshot %s', rh_surf, rh_contrast, rh_ventral_outputImage);
system(command);


