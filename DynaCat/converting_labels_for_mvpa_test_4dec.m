

% converting anat rois

session_path = '/share/kalanit/biac2/kgs/projects/DynamicCategories/data/DynaCat/subj-06/session1/';
anat_folder = fullfile(session_path, '3DAnatomy/label/dynacat_rois/anat_rois');

labels = dir(fullfile(anat_folder, '*'));
labels = {labels.name};
labels = labels(contains(labels, 'anat'));
ROI_list = labels;


%%
% Load session parameters
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


for i = 1:numel(ROI_list)
    curr_ROI = ROI_list(i);
    curr_ROI = cell2mat(curr_ROI);
    hemi = curr_ROI(1:2); % hemisphere label is the first two characters of the ROI name

    % convert labels to nifti
    label_dir = anat_folder;
    labels = dir(fullfile(label_dir, '*'));
    labels = {labels.name};
    labels = labels(contains(labels, curr_ROI));
    

    % this is all from dynacat_freesurferLabel2niftiROI.m but reformatted to include dynacat_roi folder
    % Setup
    anatDir = fullfile(session_path,'3DAnatomy');
    fsDir = fullfile(setup.fsDir, setup.fsSession);
    subject = setup.fsSession;
    
    nifti_roi_dir = fullfile(fsDir,'niftiROIs');
    if ~exist(nifti_roi_dir, 'dir')
        mkdir(nifti_roi_dir);
    end
    
    for l = 1:numel(labels)
    
        % load the label file
        labelName = cell2mat(strrep(labels(l), '.label', ''));
    
        % volume to align nifti to
        tmp = fullfile(fsDir,'mri','T1.mgz');
    
        % output volume name
        niftiFileName = [labelName '.nii.gz'];
        %outname = fullfile(anatDir,'niftiROIs',niftiFileName);
        outname = fullfile(nifti_roi_dir,niftiFileName);
    
        % create registration file if it doesn't exist
        reg = fullfile(fsDir,'surf','register.dat');
        if ~isfile(reg)
         origPath = [fsDir, '/mri/orig.mgz'];
         outFile = [fsDir, '/surf/register.dat'];
         cmd = ['tkregister2 --mov ' origPath ' --noedit --s ' subject ' --regheader --reg ' outFile];
         unix(cmd)
        end
    
        label_file_path = fullfile(fsDir,'label', 'dynacat_rois', 'anat_rois', [labelName, '.label']);
    
        % convert the .label file to nifti format
        cmd = [' mri_label2vol --label ', label_file_path,...
         ' --temp ', tmp,...
         ' --reg ', reg,...
         ' --proj frac 0 1 .1',...
         ' --subject ' subject,...
         ' --hemi ',hemi,...
         ' --fill-ribbon --o ',outname];
        system(cmd)        
    end

    %% convert labels to mrVista
    nifti_labels_dir = fullfile(setup.fsDir, setup.fsSession, 'niftiROIs');
    nifti_labels = dir(fullfile(nifti_labels_dir, '*'));
    nifti_labels = {nifti_labels.name};
    curr_ROI_name = strrep(curr_ROI, '.label', '');
    nifti_labels = nifti_labels(contains(nifti_labels, curr_ROI_name));

    for l = 1:numel(nifti_labels)
        % load nifti label
        labelName = cell2mat(strrep(nifti_labels(l), '.nii.gz', ''));
        % set paths
        roiPath = fullfile(nifti_labels_dir, nifti_labels(l));
        roiPath = cell2mat(roiPath);
        savename = cell2mat(strrep(nifti_labels(l), '.nii.gz', '.mat'));

        roiDir = fullfile(setup.fsDir, setup.fsSession, 'mrVistaROIs');
        if ~exist(roiDir, 'dir')
            mkdir(roiDir);
        end
    
        dynacat_niftiROI2mrVistaROI(roiPath, 'color', [0 0 0], 'spath', roiDir, 'name', savename)
    end
end