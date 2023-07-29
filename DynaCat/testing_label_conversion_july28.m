% DynaCat: Drawing and converting ROIs test script july 28

%% Set subject session path
% ex. '/home/brispoli/DynamicCategories/data/DynaCat/subj-02/session1/'
session_path = '/share/kalanit/biac2/kgs/projects/DynamicCategories/data/DynaCat/subj-02/session1/';

%% Load session parameters
cd(session_path)
% Load initialized session
load mrInit_params.mat
load mrSESSION.mat

% Set vAnatomy
vANATOMYPATH = '3DAnatomy/t1.nii.gz';
saveSession

%% convert labels

% load only the labels that contain 'dynacat' in the name -- could later
% put the dynacat in their own folder to make things easier lol
label_dir = fullfile(setup.fsDir, setup.fsSession, 'label');
labels = fullfile(labels);
labels = labels(contains(labels, 'dynacat'));

dynacat_freesurferLabel2niftiROI(setup.fsDir, setup.fsSession, 'lh', labels, session_path)

%%