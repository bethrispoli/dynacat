function dynacat_computeContrastMaps(session_path, functional_niftis, cond_num_list, cond_list)
% dynacat_computeContrastMaps()
% computes contrast maps for dynacat
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
% Outputs: individual conditions vs all other conditions, more maps


% check if NifitMap folder exists, if not make one
if ~exist('/Inplane/GLMs/NiftiMaps', 'dir')
    mkdir Inplane/GLMs/NiftiMaps
end

% initialize hidden inplane
hi = initHiddenInplane('GLMs', 1);


% compute each individual condition vs all
for curr_cond = 1:length(cond_list)
    active_cond = curr_cond;
    control_conds = setdiff(cond_num_list, active_cond);
    contrast_name = [strcat(cond_list{curr_cond}) '_vs_all'];
    hi = computeContrastMap2(hi, active_cond, control_conds, contrast_name, 'mapUnits','T');

    % storing contrast map as nifti
    niftiFileName = [contrast_name,'.nii.gz'];
    contrastNifti = contrastMap2Nii(hi.map{1},niftiFileName,functional_niftis);
    % saving nifti under Inplane/GLMs/NiftiMaps
    cd Inplane/GLMs/NiftiMaps
    writeFileNifti(contrastNifti);
    cd ../../..
end

% compute categories constrasts
hands = [1 2 3 4];
faces = [5 6 7 8];
bodies = [9 10 11 12];
animals = [13 14 15 16];
objects1 = [17 18 19 20];
objects2 = [21 22 23 24];
scenes1 = [25 26 27 28];
scenes2 = [29 30 31 32];

categories = {hands faces bodies animals objects1 objects2 scenes1 scenes2};
categories_names = {'hands' 'faces' 'bodies' 'animals' 'objects1' 'objects2' 'scenes1' 'scenes2'};

for category_index = 1:length(categories)
    curr_category = categories{category_index};

    active_conds = curr_category;
    control_conds = setdiff(cond_num_list, active_conds);
    contrast_name = [strcat(categories_names{category_index}) '_vs_all'];
    hi = computeContrastMap2(hi, active_conds, control_conds, contrast_name, 'mapUnits','T');

    % storing contrast map as nifti
    niftiFileName = [contrast_name,'.nii.gz'];
    contrastNifti = contrastMap2Nii(hi.map{1},niftiFileName, functional_niftis);
    % saving nifti under Inplane/GLMs/NiftiMaps
    cd Inplane/GLMs/NiftiMaps
    writeFileNifti(contrastNifti);
    cd ../../..

end


%compute animate vs inanimate
active_conds = [hands faces bodies animals];
control_conds = [objects1 objects2 scenes1 scenes2];
contrast_name = 'animate_vs_inanimate';
hi = computeContrastMap2(hi, active_conds, control_conds, contrast_name, 'mapUnits','T');
% storing contrast map as nifti
niftiFileName = [contrast_name,'.nii.gz'];
contrastNifti = contrastMap2Nii(hi.map{1},niftiFileName, functional_niftis);
% saving nifti under Inplane/GLMs/NiftiMaps
cd Inplane/GLMs/NiftiMaps
writeFileNifti(contrastNifti);
cd ../../..


% compute dynamic format contrasts
normal = [1 5 9 13 17 21 25 29];
scrambled = [3 7 11 15 19 23 27 31];
linear = [2 6 10 14 18 22 26 30];
still = [4 8 12 16 20 24 28 32];

dynamic_format = {normal scrambled linear still};
dynamic_format_names = {'normal' 'scrambled' 'linear' 'still'};

for dynamic_format_index = 1:length(dynamic_format)
    curr_dynamic_format = dynamic_format{dynamic_format_index};

    active_conds = curr_dynamic_format;
    control_conds = setdiff(cond_num_list, active_conds);
    contrast_name = [strcat(dynamic_format_names{dynamic_format_index}) '_vs_all'];
    hi = computeContrastMap2(hi, active_conds, control_conds, contrast_name, 'mapUnits','T');

    % storing contrast map as nifti
    niftiFileName = [contrast_name,'.nii.gz'];
    contrastNifti = contrastMap2Nii(hi.map{1},niftiFileName, functional_niftis);
    % saving nifti under Inplane/GLMs/NiftiMaps
    cd Inplane/GLMs/NiftiMaps
    writeFileNifti(contrastNifti);
    cd ../../..

end


% compute linear vs still
active_conds = linear;
control_conds = still;
contrast_name = 'linear_vs_still';
hi = computeContrastMap2(hi, active_conds, control_conds, contrast_name, 'mapUnits','T');
% storing contrast map as nifti
niftiFileName = [contrast_name,'.nii.gz'];
contrastNifti = contrastMap2Nii(hi.map{1},niftiFileName, functional_niftis);
% saving nifti under Inplane/GLMs/NiftiMaps
cd Inplane/GLMs/NiftiMaps
writeFileNifti(contrastNifti);
cd ../../..

% compute normal vs linear
active_conds = normal;
control_conds = linear;
contrast_name = 'normal_vs_linear';
hi = computeContrastMap2(hi, active_conds, control_conds, contrast_name, 'mapUnits','T');
% storing contrast map as nifti
niftiFileName = [contrast_name,'.nii.gz'];
contrastNifti = contrastMap2Nii(hi.map{1},niftiFileName, functional_niftis);
% saving nifti under Inplane/GLMs/NiftiMaps
cd Inplane/GLMs/NiftiMaps
writeFileNifti(contrastNifti);
cd ../../..

% compute normal vs scrambled
active_conds = normal;
control_conds = scrambled;
contrast_name = 'normal_vs_scrambled';
hi = computeContrastMap2(hi, active_conds, control_conds, contrast_name, 'mapUnits','T');
% storing contrast map as nifti
niftiFileName = [contrast_name,'.nii.gz'];
contrastNifti = contrastMap2Nii(hi.map{1},niftiFileName, functional_niftis);
% saving nifti under Inplane/GLMs/NiftiMaps
cd Inplane/GLMs/NiftiMaps
writeFileNifti(contrastNifti);
cd ../../..

% compute normal vs still
active_conds = normal;
control_conds = still;
contrast_name = 'normal_vs_still';
hi = computeContrastMap2(hi, active_conds, control_conds, contrast_name, 'mapUnits','T');
% storing contrast map as nifti
niftiFileName = [contrast_name,'.nii.gz'];
contrastNifti = contrastMap2Nii(hi.map{1},niftiFileName, functional_niftis);
% saving nifti under Inplane/GLMs/NiftiMaps
cd Inplane/GLMs/NiftiMaps
writeFileNifti(contrastNifti);
cd ../../..

