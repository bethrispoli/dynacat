% test

map_path = '/share/kalanit/biac2/kgs/projects/DynamicCategories/data/DynaCat/test_subj06/session1/Gray/GLMs/faces-allMotion_vs_all.mat';
%contrast_name = 'faces-allMotion_vs_all.mat';
fsSession_path = '/share/kalanit/biac2/kgs/anatomy/freesurferRecon/ag202309_v72';
fs_id = 'ag202309_v72';

% path to subject data in FreesurferSegmentations
mri_dir = fullfile(fsSession_path, 'mri');
surf_dir = fullfile(fsSession_path, 'surf');

% generate paths to mrVista session directories and FreeSurfer output
[session_path, ~] = fileparts(fileparts(fileparts(map_path)));
[~, dt] = fileparts(fileparts(map_path));
[~, contrast_name] = fileparts(map_path);

% generate FreeSurfer parameter map file from mrVista parameter map
cd(session_path);
load mrSESSION.mat
load('mrInit_params.mat', 'params')

% hg = initHiddenGray(dt, 1);
% hg = loadParameterMap(hg, map_path);
% hg = loadAnat(hg);

%----
% Pathing
share_prefix = '/share/kalanit';
oak_prefix = '/oak/stanford/groups';
% adds Dawn's toonAtlas code to path that includes the alignment tools (alignvolumedata folder)
addpath(genpath(fullfile(share_prefix, 'biac2/kgs/projects/toonAtlas/code')))

% outpth = fullfile(session_path, 'functionals2itkGray.nii.gz');
% scan = viewGet(hg, 'current scan');
% functionals2itkGray(hg, scan, outpth)

%% trying old way with confirming that none of the functions were changed
out_path = fullfile(mri_dir, [contrast_name '.nii.gz']);
% generate FreeSurfer parameter map file from mrVista parameter map
cd(session_path);
hg = initHiddenGray(dt, 1);
hg = loadParameterMap(hg, map_path);
hg = loadAnat(hg);
functionals2itkGray(hg, 1, out_path);
cd(mri_dir);
map_name = contrast_name;
unix(['mri_convert -ns 1 -odt float -rt nearest -rl orig.mgz ' ...
    map_name '.nii.gz ' map_name '.nii.gz --conform']);
movefile(out_path, fullfile(surf_dir, [map_name '.nii.gz']));

%% generate FreeSurfer surface files for each hemisphere
cd(surf_dir);
unix(['mri_vol2surf --mov ' map_name '.nii.gz ' ...
    '--reg register.dat --hemi lh --interp nearest --o ' ...
    map_name '_lh.mgz --projdist 2']); % left hemi
unix(['mri_vol2surf --mov ' map_name '.nii.gz ' ...
    '--reg register.dat --hemi rh --interp nearest --o ' ...
    map_name '_rh.mgz --projdist 2']); % right hemi


%% using emily's code to loop over projfract values to get rid of map holes
cd(surf_dir);
map_path = fullfile(surf_dir, [map_name '.nii.gz']);
proj_values = [-.5:0.1:.5];
for p = 1:length(proj_values)
    unix(['mri_vol2surf --mov ', map_path, ' ', ...
            '--reg register.dat --hemi rh --interp trilin --o ', ...
            fullfile(surf_dir, strcat(map_name, '_rh_proj_', num2str(proj_values(p)), '.mgh')), ...
            ' --projfrac ', num2str(proj_values(p))]); % left hemi
end

if exist(strcat(map_name, '_rh_proj_max.mgh'))
    prev_max_map = strcat(map_name, '_rh_proj_max.mgh');
    delete(prev_max_map)
end

unix(['mri_concat --i ', strcat(map_name, '_rh_proj_*'), ...
        ' --o ', strcat(map_name, '_rh_proj_max.mgh'), ...
        ' --max']);



%% exporting roi
load mrSESSION.mat
load session_setup.mat

% convert label to nifti
label = {'mFus-faces-AllMotion_rh_dynacat_beth.label'};
hemi = 'rh';
dynacat_freesurferLabel2niftiROI(setup.fsDir, setup.fsSession, hemi, label, session_path)

% convert nifti roi to mrvista
savename = 'mFus-faces-AllMotion_rh_dynacat_beth.mat';
roiDir = fullfile(session_path, 'Gray', 'ROIs');
if ~exist(roiDir, 'dir')
    mkdir(roiDir);
end

nifti_roi_dir = fullfile(setup.fsDir, setup.fsSession,'niftiROIs');
roipath = fullfile(nifti_roi_dir, 'mFus-faces-AllMotion_rh_dynacat_beth.nii.gz');

dynacat_niftiROI2mrVistaROI(roipath, 'color', [0 0 0], 'spath', roiDir, 'name', savename)

%% convert mrvista roi back to freesurfer for fun
roiList = {savename};
session = session_path;
t1name = vANATOMYPATH;
t1folder = fullfile(session_path, '3DAnatomy');
outPath_niftiroi = fullfile(nifti_roi_dir, 'mFus-faces-AllMotion_rh_dynacat_beth_reinflated_from_mrvista.nii.gz');

dynacat_mrVistaROI2niftiROI(session,roiList,t1name,t1folder,outPath_niftiroi)

fsDir = fullfile(setup.fsDir, setup.fsSession);
fsid = setup.fsSession;
hemi = 'rh';
dataPath = nifti_roi_dir;
roiVal = 1;
roiList = {'mFus-faces-AllMotion_rh_dynacat_beth_reinflated_from_mrvista.nii.gz'};

dynacat_nii2label_proj(fsDir, fsid, dataPath,roiList,roiVal,hemi) 

