%function dynacat_getTimecourseForROI(session_path, ROI)
% dynacat_computeContrastMaps(session_path) ---- update to these inputs
% only after confirming that changes work
% computes contrast maps for dynacat
% 
% Inputs:s
% session_path: path to subject's session folder, 
%               ex: '/share/kalanit/biac2/kgs/projects/DynamicCategories/data/DynaCat/subj-01/session1/'
% 
% Outputs:

%%
session_path = '/share/kalanit/biac2/kgs/projects/DynamicCategories/data/DynaCat/subj-03/session1/';
cd(session_path)
ROI = 'lh_dynacat-danya_pFus-faces-allmotion_t3_DO.mat';

%% Default inputs
if notDefined('session_path')
    fprintf(1,'Error, you need to define a session_path \n');
    return
end

%% Checks
% Check and validate inputs and path to vistasoft
if isempty(which('mrVista'))
    vista_path = 'https://github.com/vistalab/vistasoft';
    error(['Add vistasoft to your matlab path: ', vista_path]);
end

%% Load initialized session
cd(session_path);

load mrInit_params.mat
load mrSESSION.mat

%% 
% Open hidden gray
hg = initHiddenGray('MotionComp_RefScan1', 1);

ROI_path = fullfile(session_path, '3DAnatomy', 'mrVistaROIs', ROI);

%Load ROI
VOLUME{1}=loadROI(hg, ROI_path,[],[],1,0); %loadROI(vw, filename, select, clr, absPathFlag, local)
VOLUME{1}= restrictROIfromMenu(VOLUME{1});

%plot timecourse
tc_plotScans(VOLUME{1},1);

%apply GLM to timecourse
tc_applyGlm;
tc = tc_visualizeGlm; 

%save plot as png
%exportsetupdlg;
%doExport(hSrc, eventData, tc)
plot_name = strrep(ROI, '.mat', '_timecourseGLM.png');
images_folder_path = fullfile(session_path, 'Images', 'ROI_timecourse_plots', plot_name);
saveas(gcf, images_folder_path);

% dump data to workspace
tc_dumpDataToWorkspace;


% saving glm data for roi one by one until i think of a better plan

% Convert the structure to a table
glm_struc = fig1Data.glm;

% export betas csv
betas = glm_struc.betas;
betas_filename = [ROI '_betas.csv'];
writematrix(betas, betas_filename);

% export standard deviations csv
stdevs = glm_struc.stdevs;
stdevs_filename = [ROI '_stdevs.csv'];
writematrix(stdevs, stdevs_filename);

% export sems csv
sems = glm_struc.sems;
sems_filename = [ROI '_sems.csv'];
writematrix(sems, sems_filename);




%% trying out the function i just wrote that takes a list of freesurfer ROIs, converts them to mrVista, and then runs and exports the GLM tc data

session_path = '/share/kalanit/biac2/kgs/projects/DynamicCategories/data/DynaCat/subj-07/session1/';
cd(session_path)

% getting all the lables from the folder labels_to_convert and getting them
% in a list without their file extentions for funciton, had to copy the
% labels also into the labels folder to get ROI conversion to work lol
folderPath = fullfile(session_path, '3DAnatomy', 'label', 'dynacat_rois');
fileList = dir(fullfile(folderPath, '*.*')); % List all files
ROI_list = cell(length(fileList), 1);

% Loop through the file list and extract filenames without extensions
for i = 1:length(fileList)
    [~, name, ~] = fileparts(fileList(i).name);
    ROI_list{i} = name;
end

ROI_list(1:2) = []; % getting rid of the first two entries-- might not need to do this later
disp(ROI_list);

convert_surf_ROIs_export_betas_from_mrvista(session_path, ROI_list)



