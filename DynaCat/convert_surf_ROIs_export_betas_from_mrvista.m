function convert_surf_ROIs_export_betas_from_mrvista(session_path, ROI_list)
% will convert freesurfer ROI labels into mrVista .mat ROIs, then export
% the GLM timecourse values
%
% ROI_list:     list of ROI label names from freesurfer recon labelssubfolder

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
    label_dir = fullfile(setup.fsDir, setup.fsSession, 'label', 'dynacat_rois');
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
    
        label_file_path = fullfile(fsDir,'label', 'dynacat_rois', [labelName, '.label']);
    
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
    nifti_labels = nifti_labels(contains(nifti_labels, curr_ROI));

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

    %% run tc and save data
    ROI = [curr_ROI, '.mat']; % add .mat extension to ROI name to locate the mrVista ROI

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
    image_folder_path_dir = fullfile(session_path, 'Images', 'ROI_timecourse_plots');
    if ~exist(image_folder_path_dir, 'dir')
        mkdir(image_folder_path_dir);
    end
    images_folder_path = fullfile(image_folder_path_dir, plot_name);
    saveas(gcf, images_folder_path);
    
    % dump data to workspace
    tc_dumpDataToWorkspace;
    
    
    % % saving glm data for roi one by one until i think of a better plan
    % 
    % % Convert the structure to a table
    % glm_struc = tc.glm;
    % 
    % % export betas csv
    % betas = glm_struc.betas;
    % betas_filename = [curr_ROI '_betas.csv'];
    % writematrix(betas, betas_filename);
    % 
    % % export standard deviations csv
    % stdevs = glm_struc.stdevs;
    % stdevs_filename = [curr_ROI '_stdevs.csv'];
    % writematrix(stdevs, stdevs_filename);
    % 
    % % export sems csv
    % sems = glm_struc.sems;
    % sems_filename = [curr_ROI '_sems.csv'];
    % writematrix(sems, sems_filename);
end

close all
clear all

