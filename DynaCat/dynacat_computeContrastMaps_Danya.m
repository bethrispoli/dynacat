%function dynacat_computeContrastMaps_Danya(session_path, functional_niftis, cond_num_list, cond_list)
% computes contrast maps for Danya's summer project.
% 
% Inputs:
% session_path: path to subject's session folder, 
%               ex: '/share/kalanit/biac2/kgs/projects/DynamicCategories/data/DynaCat/subj-01/session1/'
% functional_niftis: read nifti files for the functional data, ran by using
%                    readFileNifti(init_params.functionals{1}); in the main analysis script
% cond_num_list: list of all the condition numbers in the experiement without baseline 0 
%                or task repeat, in dyncat: numbers 1-32
% cond_list: list of all the conditions in the experiemnt not including baseline
%             or task repeats, 32 for dynacat
% 
% Outputs:



% check if NifitMap folder exists, if not make one
if ~exist('/Inplane/GLMs/NiftiMaps', 'dir')
    mkdir Inplane/GLMs/NiftiMaps
end

% initialize hidden inplane
hi = initHiddenInplane('GLMs', 1);


%% Faces contrast
faces = [5 6 7 8];

active_cond = faces;
control_conds = setdiff(cond_num_list, active_cond);

contrast_name = 'faces_vs_all_danya';
hi = computeContrastMap2(hi, active_cond, control_conds, contrast_name, 'mapUnits','T');

% storing contrast map as nifti
niftiFileName = [contrast_name,'.nii.gz'];
contrastNifti = contrastMap2Nii(hi.map{1},niftiFileName, functional_niftis);
% saving nifti under Inplane/GLMs/NiftiMaps
cd Inplane/GLMs/NiftiMaps
writeFileNifti(contrastNifti);
cd ../../..

%% Hands contrast 
hands = [1 2 3 4];

active_cond = hands;
control_conds = setdiff(cond_num_list, active_cond);
contrast_name = 'hands_vs_all_danya';
hi = computeContrastMap2(hi, active_cond, control_conds, contrast_name, 'mapUnits','T');

% storing contrast map as nifti
niftiFileName = [contrast_name,'.nii.gz'];
contrastNifti = contrastMap2Nii(hi.map{1},niftiFileName, functional_niftis);
% saving nifti under Inplane/GLMs/NiftiMaps
cd Inplane/GLMs/NiftiMaps
writeFileNifti(contrastNifti);
cd ../../..