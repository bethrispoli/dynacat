function dynacat_saveFreeviewVisualizations(session_path, fs_path, fs_id, contrast_name)
% dynacat_saveFreeviewVisualizations(fsPath, vistaPath)
% saves FreeView visualized contrast maps into PNGs for both lh and rh using proj_max maps.
% Currently set at a 3 threshold where values at 5 are visualized in red
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
% BR 9/2023
 

% Paths to FreeSurfer data
fsDir = fullfile(fs_path, fs_id);
lh_surf = fullfile(fsDir, 'surf', 'lh.inflated');
rh_surf = fullfile(fsDir, 'surf', 'rh.inflated');

lh_contrast_name = [contrast_name '_lh_proj_max.mgh'];
lh_contrast = fullfile(fsDir, 'surf', 'dynacat_maps', 'dynacat_proj_max_maps', lh_contrast_name);
rh_contrast_name = [contrast_name '_rh_proj_max.mgh'];
rh_contrast = fullfile(fsDir, 'surf', 'dynacat_maps', 'dynacat_proj_max_maps', rh_contrast_name);

% Set-up image saving
images_dir = fullfile(session_path, 'Images');
contrast_vis_filepath = fullfile(images_dir, 'contrast_maps');
if ~exist(contrast_vis_filepath, 'dir')
    mkdir(contrast_vis_filepath);
end

lh_lateral_image_filename = [contrast_name '_proj_max_lh_lateral.png'];
lh_lateral_outputImage = fullfile(contrast_vis_filepath, lh_lateral_image_filename);
lh_ventral_image_filename = [contrast_name '_proj_max_lh_ventral.png'];
lh_ventral_outputImage = fullfile(contrast_vis_filepath, lh_ventral_image_filename);

rh_lateral_image_filename = [contrast_name '_proj_max_rh_lateral.png'];
rh_lateral_outputImage = fullfile(contrast_vis_filepath, rh_lateral_image_filename);
rh_ventral_image_filename = [contrast_name '_proj_max_rh_ventral.png'];
rh_ventral_outputImage = fullfile(contrast_vis_filepath, rh_ventral_image_filename);

% Load the lh surf and overlay the lh contrast map on the inflated surface
% removed  -colorscale but should add back in if needed later
% lateral view
command = sprintf('freeview -f %s:overlay=%s:overlay_threshold=3,5:overlay_color=colorwheel,inverse -viewport 3d -view lateral -layout 1 -zoom 1.5 --screenshot %s', lh_surf, lh_contrast, lh_lateral_outputImage);
system(command);
% ventral view
command = sprintf('freeview -f %s:overlay=%s:overlay_threshold=3,5:overlay_color=colorwheel,inverse -viewport 3d -view inferior -cam Roll 90 -layout 1 -zoom 1.5 --screenshot %s', lh_surf, lh_contrast, lh_ventral_outputImage);
system(command);

% Load the rh surf and overlay the rh contrast map on the inflated surface
% lateral view
command = sprintf('freeview -f %s:overlay=%s:overlay_threshold=3,5:overlay_color=colorwheel,inverse -viewport 3d -view lateral -layout 1 -zoom 1.5 --screenshot %s', rh_surf, rh_contrast, rh_lateral_outputImage);
system(command);
% ventral view
command = sprintf('freeview -f %s:overlay=%s:overlay_threshold=3,5:overlay_color=colorwheel,inverse -viewport 3d -view inferior -cam Roll 90 -layout 1 -zoom 1.5 --screenshot %s', rh_surf, rh_contrast, rh_ventral_outputImage);
system(command);


