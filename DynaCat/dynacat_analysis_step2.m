% DynaCat Analysis: Step 2
% Subj-XX
%
% See step 1 of analysis code for subject session folder set-up.Make a copy
% of this script for each subject inside their code folder 
% 
% Loads mrSESSION created in step 1 and creates contrast maps as set in
% dynacat_computeContrastMaps.m. Transforms these maps into the gray in
% mrVista and then into FreeSurfer surfaces. Saves visualizations of each
% map to Images subject folder.
% 
% INPUTS (set below)
% 1) session_path: fullpath to scanning session directory in ~/DynaCat/data/ that 
%             is being analyzed (string), ex. ~/DynaCat/data/subj-01/session1/
% OUTPUT
% 1) contrast maps for all condition contrasts set in dynacat_computeContrastMaps.m
% 2) contrast maps converted into the Gray
% 3) contrast maps converted into FreeSurfer surfaces
% 4) visualizations of contrast maps on the surface using parameters set in dynacat_saveFreeviewVisualizations.m


%% Set subject session path
% ex. '/home/brispoli/DynamicCategories/data/DynaCat/subj-02/session1/'
session_path = '/share/kalanit/biac2/kgs/projects/DynamicCategories/data/DynaCat/subj-XX/session1/';

%% Load session parameters
cd(session_path)
% Load initialized session
load mrInit_params.mat
load mrSESSION.mat
load session_setup.mat

% Set vAnatomy
vANATOMYPATH = '3DAnatomy/t1.nii.gz';
saveSession

% open logfile to track progress of analysis
logFileName = fullfile('./dynacatAnalysis_log.txt');
lid = fopen(logFileName, 'w+');
fprintf(lid, 'Starting setp 2 analysis for session %s. \n\n', session_path);

%% Compute contrast maps
% computes contrast maps specified in dynacat_computeContrastMaps.m
dynacat_computeContrastMaps(session_path)

fprintf(lid, 'GLM parameter maps saved in: \n%s/GLMs/... \n\n', session_path);
fprintf('GLM parameter maps saved in: \n%s/GLMs/... \n\n', session_path);

% Transform contrast maps to gray
dynacat_maps2gray(session_path)

% Import contrast maps into FreeSurfer
% go through all the generated constrast maps for Gray and convert them
% into FreeSurfer compatible maps in 3DAnatomy/surf
% this takes a while because it's converting all the maps at once!

% get an array of all the .mat contrast filenames
session_gray_dir = fullfile(session_path, 'Gray', 'GLMs');
gray_GLMs = dir(fullfile(session_gray_dir, '*.*'));
gray_contrasts_names = {gray_GLMs.name};
gray_contrasts_names = gray_contrasts_names(5:length(gray_contrasts_names)); %skips the first 4 entries of the .mat file arrays

% convert each contrast map into a Freesurfer compatible map
for i = 1:length(gray_contrasts_names)
    curr_contrast_name_cell = gray_contrasts_names(i);
    curr_contrast_name = char(curr_contrast_name_cell{1});
    map_path = fullfile(session_gray_dir, curr_contrast_name);
    
    dynacat_mrvGray2fsSurf_parameterMaps(session_path, map_path, fullfile(setup.fsDir, setup.fsSession), setup.fsSession)
end

disp(['Successfully converted ' num2str(length(gray_contrasts_names)) ' mrVista contrast maps into Freesurfer compatible maps! Saved to ' session_gray_dir '.'])
fprintf(lid,'Successfully converted %d mrVista contrast maps into Freesurfer compatible maps.\n\n', length(gray_contrasts_names));


%% Save contrast map visualizations
% using Freeview commands, load each contrast map in Freeview and save a
% screenshot in subj-xx/session1/Images

% Remove the '.mat' extension from each filename to get an array of just contrast names
contrasts_names = cellfun(@(x) strrep(x, '.mat', ''), gray_contrasts_names, 'UniformOutput', false);

% generate lateral and ventral visualizations for each contrast 
for i = 1:length(contrasts_names)
    curr_contrast_name_cell = contrasts_names(i);
    curr_contrast_name = char(curr_contrast_name_cell{1});
    
    disp(['Saving visualization for ' curr_contrast_name '. ' num2str(i) '/' num2str(length(contrasts_names)) ' remaining...'])
    dynacat_saveFreeviewVisualizations(session_path, setup.fsDir, setup.fsSession, curr_contrast_name)
end
disp(['Successfully exported visualizations for ' num2str(length(contrasts_names)) ' maps! Saved to subj/session/Images.'])

%%



