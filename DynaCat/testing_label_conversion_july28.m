% DynaCat: Drawing and converting ROIs test script july 28

%% Set subject session path
% ex. '/home/brispoli/DynamicCategories/data/DynaCat/subj-03/session1/'
session_path = '/share/kalanit/biac2/kgs/projects/DynamicCategories/data/DynaCat/subj-03/session1/';

%% Load session parameters
cd(session_path)
% Load initialized session
load mrInit_params.mat
load mrSESSION.mat
load session_setup.mat

% Set vAnatomy
vANATOMYPATH = '3DAnatomy/t1.nii.gz';
saveSession

% Set FreeSurfer Directory
setenv('SUBJECTS_DIR', setup.fsDir);

%% convert labels to nifti

% load only the labels that contain 'dynacat' in the name -- could later
% put the dynacat in their own folder to make things easier lol
label_dir = fullfile(setup.fsDir, setup.fsSession, 'label');
labels = dir(fullfile(label_dir, '*'));
labels = {labels.name};
labels = labels(contains(labels, 'lh_dynacat-danya_IOG-faces-allmotion_t3_BR_CorrectedForDanya'));


dynacat_freesurferLabel2niftiROI(setup.fsDir, setup.fsSession, 'lh', labels, session_path)

%% convert labels to mrVista
nifti_labels_dir = fullfile(setup.fsDir, setup.fsSession, 'niftiROIs');
nifti_labels = dir(fullfile(nifti_labels_dir, '*'));
nifti_labels = {nifti_labels.name};
nifti_labels = nifti_labels(contains(nifti_labels, 'lh_dynacat-danya_IOG-faces-allmotion_t3_BR_CorrectedForDanya'));


for l = 1:numel(nifti_labels)
    % load nifti label
    labelName = cell2mat(strrep(nifti_labels(l), '.nii.gz', ''));
    % set paths
    roiPath = fullfile(nifti_labels_dir, nifti_labels(l));
    roiPath = cell2mat(roiPath);
    savename = cell2mat(strrep(nifti_labels(l), '.nii.gz', '.mat'));
    roiDir = fullfile(setup.fsDir, setup.fsSession, 'mrVistaROIs');

    dynacat_niftiROI2mrVistaROI(roiPath, 'color', [0 0 0], 'spath', roiDir, 'name', savename)

end


%% testing map to binary to label conversion to visualize multiple maps on one surface (lh)
labels = {'faces-normal_vs_allNormal_lh', 'faces-scrambled_vs_allScrambled_lh', 'faces-linear_vs_allLinear_lh', 'faces-still_vs_allStill_lh',...
    'hands-normal_vs_allNormal_lh', 'hands-scrambled_vs_allScrambled_lh', 'hands-linear_vs_allLinear_lh', 'hands-still_vs_allStill_lh',...
    'bodies-normal_vs_allNormal_lh', 'bodies-scrambled_vs_allScrambled_lh', 'bodies-linear_vs_allLinear_lh', 'bodies-still_vs_allStill_lh',...
    'animals-normal_vs_allNormal_lh', 'animals-scrambled_vs_allScrambled_lh', 'animals-linear_vs_allLinear_lh', 'animals-still_vs_allStill_lh',...
    'objects1-normal_vs_allNormal_lh', 'objects1-scrambled_vs_allScrambled_lh', 'objects1-linear_vs_allLinear_lh', 'objects1-still_vs_allStill_lh',...
    'objects2-normal_vs_allNormal_lh', 'objects2-scrambled_vs_allScrambled_lh', 'objects2-linear_vs_allLinear_lh', 'objects2-still_vs_allStill_lh',...
    'scenes1-normal_vs_allNormal_lh', 'scenes1-scrambled_vs_allScrambled_lh', 'scenes1-linear_vs_allLinear_lh', 'scenes1-still_vs_allStill_lh',...
    'scenes2-normal_vs_allNormal_lh', 'scenes2-scrambled_vs_allScrambled_lh', 'scenes2-linear_vs_allLinear_lh', 'scenes2-still_vs_allStill_lh'};
dynacat_niftiMaps2BinaryLabels(setup.fsDir, setup.fsSession, labels, 'lh', session_path)

labels = {'faces-normal_vs_allNormal_rh', 'faces-scrambled_vs_allScrambled_rh', 'faces-linear_vs_allLinear_rh', 'faces-still_vs_allStill_rh',...
    'hands-normal_vs_allNormal_rh', 'hands-scrambled_vs_allScrambled_rh', 'hands-linear_vs_allLinear_rh', 'hands-still_vs_allStill_rh',...
    'bodies-normal_vs_allNormal_rh', 'bodies-scrambled_vs_allScrambled_rh', 'bodies-linear_vs_allLinear_rh', 'bodies-still_vs_allStill_rh',...
    'animals-normal_vs_allNormal_rh', 'animals-scrambled_vs_allScrambled_rh', 'animals-linear_vs_allLinear_rh', 'animals-still_vs_allStill_rh',...
    'objects1-normal_vs_allNormal_rh', 'objects1-scrambled_vs_allScrambled_rh', 'objects1-linear_vs_allLinear_rh', 'objects1-still_vs_allStill_rh',...
    'objects2-normal_vs_allNormal_rh', 'objects2-scrambled_vs_allScrambled_rh', 'objects2-linear_vs_allLinear_rh', 'objects2-still_vs_allStill_rh',...
    'scenes1-normal_vs_allNormal_rh', 'scenes1-scrambled_vs_allScrambled_rh', 'scenes1-linear_vs_allLinear_rh', 'scenes1-still_vs_allStill_rh',...
    'scenes2-normal_vs_allNormal_rh', 'scenes2-scrambled_vs_allScrambled_rh', 'scenes2-linear_vs_allLinear_rh', 'scenes2-still_vs_allStill_rh'};
dynacat_niftiMaps2BinaryLabels(setup.fsDir, setup.fsSession, labels, 'rh', session_path)

%%


