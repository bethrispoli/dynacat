% DynaCat Analysis: Step 1
% Subj-XX
%
% Adapted from automated analysis of fMRI data from fLoc funcional localizer experiment 
% using vistasoft functions (https://github.com/vistalab/vistasoft). See
% notion for in-depth notes on how to run.
%
% Each session directory must contain the following files:
% 1) An inplane nifti that contains 'inplane' in the file name and ends in
%    nii.gz inside a folder titled 'Inplane'
% 2) Functional nifti's ending in runX.nii.gz where X is the corresponding
%    run number inside a folder titled 'functionals'
% 3) Parfiles ending in runX.par where X is the corresponding run number
%    inside a folder titled 'parfiles'
%
% Other set-up:
% 1) Make a COPY of this script in each subject's code folder and 
%    name that script subjxx_dynacat_analysis_step1.m 
% 2) Set subject's freesurfer recon info in dynacat_setSessions.m before
%    running step 1
% 
% INPUTS (set below)
% 1) session_path: fullpath to scanning session directory in ~/DynaCat/data/ that 
%             is being analyzed (string), ex. ~/DynaCat/data/subj-01/session1/
% 2) init_params: optional preprocessing parameters organized into a
%                 structure appropriate for vistasoft's mrInit function
% 3) glm_parms: optional GLM analysis parameters organized into a structure
%               appropriate for vistasoft's er_setParams
% 4) clip: number of TRs to clip from beginnning of each run (int)
% 5) QA: optional flag controlling whether analysis will return if
%        within scan or between scan motion exceeds 2 voxels (boolean, default is
%        false)
%
% OUTPUT
% 1) mrSession.m
% 2) Within-scan and between-scan motion correction
% 3) Alignment
% 4) GLMs based on parfiles
% 5) installed segmentation

%% Set subject session path
% ex. '/home/brispoli/DynamicCategories/data/DynaCat/subj-02/session1/'
session_path = '/share/kalanit/biac2/kgs/projects/DynamicCategories/data/DynaCat/subj-XX/session1/';
subID = 'subj-XX';
sessionNum = 1;
clip = 0; 
QA = false;

%% Set subject session information based on the session path, clip, and QA inputs
[~, init_params, dglm_params] = dynacat_AnalysisParams(session_path, clip);
glm_params = dglm_params;

% save init_params and glm_params
cd(session_path);
save dynacat_AnalysisParams.mat init_params glm_params
[sessions, fs_sessions] = dynacat_setSessions(subID, sessionNum);

% Freesurfer paths setup
% Pathing
share_prefix = '/share/kalanit';
oak_prefix = '/oak/stanford/groups';
% adds Dawn's toonAtlas code to path that includes the alignment tools (alignvolumedata folder)
addpath(genpath(fullfile(share_prefix, 'biac2/kgs/projects/toonAtlas/code')))
% adds Beth's dynacat functions to the path
addpath(genpath(fullfile(share_prefix, 'biac2/kgs/projects/DynamicCategories/code/DynaCat/')))

% Use setSessions_dynacat.m to setup the subject, session, and FreeSurfer directories
setup.vistaDir = fullfile(share_prefix, 'biac2', 'kgs', 'projects', 'DynamicCategories', 'data', 'DynaCat'); % change for other experiments
setup.fsDir = fullfile(share_prefix, 'biac2','kgs','anatomy','freesurferRecon');
setup.subID = subID;
setup.fsSession = fs_sessions;
setup.sessionID = sessions;
subjid = setup.fsSession;
sessionID = session_path;

% Save freesurfer setup
save session_setup.mat

% Set FreeSurfer Directory
setenv('SUBJECTS_DIR', setup.fsDir);

% Set vista and anataomy directories
cd(session_path)

anatDir = fullfile(setup.vistaDir, setup.subID, setup.sessionID, '3DAnatomy');
if ~exist(anatDir,'dir')
    fprintf(1, 'Error: 3DAnatomy link does not exist. Make softlink')
    return
end

%% Read nifti files
nii = readFileNifti(init_params.functionals{1}); 
nslices = size(nii.data, 3);

% open logfile to track progress of analysis
logFileName = fullfile('./dynacatAnalysis_log.txt');
lid = fopen(logFileName, 'w+');
fprintf(lid, 'Starting analysis for session %s. \n\n', session_path);
fprintf('Starting analysis for session %s. \n\n', session_path);

%% Initialize vistasoft session and open hidden inplane view
fprintf(lid, 'Initializing vistasoft session directory in: \n%s \n\n', session_path);
fprintf('Initializing vistasoft session directory in: \n%s \n\n', session_path);
setpref('VISTA', 'verbose', false); % suppress wait bar

mrsession_path = fullfile(session_path, 'MrSESSION.mat');
if exist(mrsession_path, 'file') == 0
    mrInit(init_params); % saves mrSESSION.mat under session's folder
end

cd(fullfile(session_path))
hi = initHiddenInplane('Original', 1);

%% Within-scan motion correction

% run within-scan motion compensation
fprintf(lid, 'Starting within-scan motion compensation... \n');
fprintf('Starting within-scan motion compensation... \n');
setpref('VISTA', 'verbose', false); % suppress wait bar
if exist(fullfile(session_path, 'Images', 'Within_Scan_Motion_Est.fig'), 'file') ~= 2
    hi = motionCompSelScan(hi, 'MotionComp', 1:length(init_params.functionals), ...
        init_params.motionCompRefFrame, init_params.motionCompSmoothFrames);
    saveSession; close all;
end

% check to see if there is too much motion
fig = openfig(fullfile('Images', 'Within_Scan_Motion_Est.fig'), 'invisible');
L = get(get(fig, 'Children'), 'Children');
if QA
    for rr = 1:length(init_params.functionals)
        motion_est = L{rr + 1}.YData;
        if max(motion_est(:)) > 2
            fprintf(lid, 'Warning -- Within-scan motion exceeds 2 voxels. \n');
            fprintf('Warning -- Within-scan motion exceeds 2 voxels. \n');
            fprintf(lid,'Exited analysis'); 
            fprintf('Exited analysis');
            ffclose(lid); 
            return; 
        end
        fprintf(lid,'QA checks passed for run %i. ',rr);
        fprintf('QA checks passed for run %i. ',rr);
    end
end

fprintf(lid, 'Within-scan motion compensation complete. \n\n');
fprintf('Within-scan motion compensation complete. \n\n');


%% Between-scan motion correction

% group motion compensation scans
hi = initHiddenInplane('MotionComp', init_params.scanGroups{1}(1));
hi = er_groupScans(hi, init_params.scanGroups{1});

% run between-scan motion compensation
fprintf(lid, 'Starting between-scan motion compensation... \n');
fprintf('Starting between-scan motion compensation... \n');
if exist(fullfile(session_path, 'Between_Scan_Motion.txt'), 'file') ~= 2
    hi = initHiddenInplane('MotionComp', 1);
    baseScan = 1; targetScans = 1:length(init_params.functionals);
    [hi, M] = betweenScanMotComp(hi, 'MotionComp_RefScan1', baseScan, targetScans);
    fname = fullfile('Inplane', 'MotionComp_RefScan1', 'ScanMotionCompParams');
    save(fname, 'M', 'baseScan', 'targetScans');
    hi = selectDataType(hi, 'MotionComp_RefScan1');
    saveSession; close all;
end

% calculate between-scan motion
fid = fopen(fullfile('Between_Scan_Motion.txt'), 'r');
motion_est = zeros(length(init_params.functionals) - 1, 3);
for rr = 1:length(init_params.functionals) - 1
    ln = strsplit(fgetl(fid), ' ');
    motion_est(rr, 1) = str2double(ln{8});
    motion_est(rr, 2) = str2double(ln{11});
    motion_est(rr, 3) = str2double(ln{14});
end
fclose(fid);

% check to see if there is too much motion
if QA
    if max(motion_est(:)) > 2
        fprintf(lid, 'Warning -- Between-scan motion exceeds 2 voxels. \nExited analysis.');
        fprintf('Warning -- Between-scan motion exceeds 2 voxels. \nExited analysis.');
    	fclose(lid); return; 
    else
        fprintf(lid,'QA checks passed. \n\n');
        fprintf('QA checks passed. \n\n');
    end
end

fprintf(lid, 'Between-scan motion compensation complete.\n\n');
fprintf('Between-scan motion compensation complete.\n\n');


%% Initialize new inplane, group scans, and set glm parameters and parfiles
hi = initHiddenInplane('MotionComp_RefScan1', init_params.scanGroups{1}(1));
hi = er_groupScans(hi, init_params.scanGroups{1});
er_setParams(hi, glm_params);
hi = er_assignParfilesToScans(hi, init_params.scanGroups{1}, init_params.parfile);
saveSession; close all;

%% Run GLM
fprintf(lid, 'Performing GLM analysis for %s... \n\n', session_path);
fprintf('Performing GLM analysis for %s... \n\n', session_path);
hi = initHiddenInplane('MotionComp_RefScan1', init_params.scanGroups{1}(1));
hi = applyGlm(hi, 'MotionComp_RefScan1', init_params.scanGroups{1}, glm_params);

%% Align session to whole brain anatomy
% opens alignment script. run alignment script one seciton at a time and
% skip step 4'

% Convert T1 for mrvista and fix class file
% Get subject's FreeSurfer recon path 
cd(fullfile(setup.fsDir, setup.fsSession))

% Path to T1.mgz file created by FreeSurfer
T1.mgz = sprintf('./mri/T1.mgz');

% Path to t1.nii.gz to be output by conversion
T1.nii = sprintf('./nifti/t1.nii.gz');
if ~exist('/nifti', 'dir')
    mkdir('nifti');
end

% Convert FS recon t1.mgz to nifti format (using nearest neighbor).
% This function cannot overwrite any existing files, so if there is an
% existing file, it will ask the user what to do. 
if exist(T1.nii, 'file')
    prompt = 'This file already exists. Are you sure you want to overwrite it? Press 1 for yes, 2 for no: ';
    x = input(prompt);
    if x == 1
        delete './nifti/t1.nii.gz'
        str = sprintf('mri_convert --resample_type nearest --out_orientation RAS -i %s -o %s', T1.mgz, T1.nii);
        system(str)
    end
else
    str = sprintf('mri_convert --resample_type nearest --out_orientation RAS -i %s -o %s', T1.mgz, T1.nii);
    system(str)
end

% Convert the FS ribbon.mgz to a nifti class file (which is used by mrVista
% to create 3D meshes)
fsRibbonFile  = fullfile('./mri/ribbon.mgz');  % Full path to the ribbon.mgz file, or it can be name of directory in freesurfer subject directory (string). 
outfile       = fullfile('./nifti/t1_class.nii.gz');
fillWithCSF   = true;
alignTo       = T1.nii;
resample_type = [];
if exist(outfile, 'file')
    x = input(prompt);
    if x == 1
        delete './nifti/t1_class.nii.gz'
        fs_ribbon2itk(fsRibbonFile, outfile, fillWithCSF, alignTo, resample_type)
    end
else
    fs_ribbon2itk(fsRibbonFile, outfile, fillWithCSF, alignTo, resample_type)
end

% Copy our T1 and class file over to the mrVista session
copyfile(T1.nii, anatDir)
copyfile(outfile, anatDir)

cd(session_path)

% Set vAnatomy
vANATOMYPATH = '3DAnatomy/t1.nii.gz';
saveSession
% check volume anatomy path
msgbox(['Reference Anatomy Path: ' getVAnatomyPath], 'getVAnatomyPath');


%% Align inplane anatomy to volume anatomy
% step through s_alignInplaneToAnatomical.m
% (or align using rxAlign and Nestares) 
% First by hand: rxAlign. Then run the other sections, up to fitting
% ellipse. Make sure that the ellipse covers the brain (or most of it) but
% excludes the skull. 
% Keep running the other sections (except for 4d' (OPTIONAL) Automatic
% alignment). Then continue the rest of the sectionss to save.

%s_alignInplaneToAnatomical
edit dynacat_alignInplaneToAnatomical % opens alignment, run one section at a time

%% Install segmentation
dynacat_installSegmentation(session_path)

%% Transform timeseries to the volume
dynacat_transformTimeseries(session_path)

%% Import FreeSurfer mesh into mrVista
fsSurfPath = fullfile(setup.fsDir,  setup.fsSession, 'surf');
vista3DAnatomyPath = fullfile(session_path, '3DAnatomy');
dynacat_surf2msh(fsSurfPath, vista3DAnatomyPath)ß

%% Add documentation

% add MATLAB and Mr Vista Version to logfile 
fprintf(lid,['---------------------------------------------------','\n\n']);
fprintf(lid,['MATLAB version ',version,'\n\n']);
load mrSESSION.mat
fprintf(lid,['mrVista Version ',mrSESSION.mrVistaVersion,'\n\n']);

% add all parameters used to logfile
fprintf(lid,['---------------------------------------------------','\n\n']);
load mrInit_params.mat
% initialization params
fprintf(lid,['Initialization parameters used\n\n',evalc('disp(params)')]);
fprintf(lid,['including: functionals\n\n',evalc('disp(params.functionals(:))')]);
fprintf(lid,['keepFrames\n\n',evalc('disp(params.keepFrames)')]);
fprintf(lid,['parfiles\n\n',evalc('disp(params.parfile(:))')]);
fprintf(lid,['---------------------------------------------------','\n\n']);
% scan params
for l = 1:length(dataTYPES(1).scanParams)
    fprintf(lid,['Original data type scan ',num2str(l),' params:\n\n',l,evalc( 'disp(dataTYPES(1).scanParams(l))' )]);
end
fprintf(lid,['GLM data type scan params:\n\n',evalc('disp(dataTYPES(4).scanParams)')]);
fprintf(lid,['---------------------------------------------------','\n\n']);
% GLM params
fprintf(lid,['Event analysis parameters used\n\n',evalc('disp(dataTYPES(length(dataTYPES)).eventAnalysisParams)')]);

% close log file
fclose(lid);

%Clear workspace
close all
clear all

%end
