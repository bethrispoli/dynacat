function dynacat_computeContrastMaps(session_path, functional_niftis, cond_num_list, cond_list)
% dynacat_computeContrastMaps(session_path) ---- update to these inputs
% only after confirming that changes work
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
% Outputs: individual conditions vs all other conditions, all category
% conditions vs all, dynamic format contrasts, combined scenes and objects
% contrasts, and animate vs inanimate contrast

%% check if NifitMap folder exists, if not make one
if ~exist('/Inplane/GLMs/NiftiMaps', 'dir')
    mkdir Inplane/GLMs/NiftiMaps
end

% initialize hidden inplane
hi = initHiddenInplane('GLMs', 1);

disp(['Computing DynaCat contrast maps for ' session_path '...'])

%% want to add this here instead of in step 2 but need to test it later:
% Load initialized session
load mrInit_params.mat
load mrSESSION.mat

% Find conditions for computing contrast maps
% complile list of all conditions in parfiles
[cond_nums, conds] = deal([]); cnt = 0;
for rr = 1:length(init_params.functionals)
    fid = fopen(init_params.parfile{rr}, 'r');
    while ~feof(fid)
        ln = fgetl(fid); cnt = cnt + 1;
        if isempty(ln); return; end; ln(ln == sprintf('\t')) = ' ';
        prts = deblank(strsplit(ln, ' ')); prts(cellfun(@isempty, prts)) = [];
        cond_nums(cnt) = str2double(prts{2});
        conds{cnt} = prts{3};
    end
    fclose(fid);
end
% make a list of unique condition numbers and corresponding condition names
cond_num_list = unique(cond_nums); cond_list = cell(1, length(cond_num_list));
for cc = 1:length(cond_num_list)
    cond_list{cc} = conds{find(cond_nums == cond_num_list(cc), 1)};
end
% remove baseline from lists of conditions
bb = find(cond_num_list == 0); cond_num_list(bb) = []; cond_list(bb) = [];
% remove task repeats from lists of conditions
tr = find(cond_num_list == 33); cond_num_list(tr) = []; cond_list(tr) = [];

% store functional nifti data fields
functional_niftis = readFileNifti(init_params.functionals{1});

%% compute each individual condition vs all
% ex. bodies-normal_vs_all, bodies-scrambled_vs_all, etc.
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

%% compute categories constrasts
% ex. bodies-allMotion_vs_all
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
    contrast_name = [strcat(categories_names{category_index}) '-allMotion_vs_all'];
    hi = computeContrastMap2(hi, active_conds, control_conds, contrast_name, 'mapUnits','T');

    % storing contrast map as nifti
    niftiFileName = [contrast_name,'.nii.gz'];
    contrastNifti = contrastMap2Nii(hi.map{1},niftiFileName, functional_niftis);
    % saving nifti under Inplane/GLMs/NiftiMaps
    cd Inplane/GLMs/NiftiMaps
    writeFileNifti(contrastNifti);
    cd ../../..

end

%% compute dynamic format contrasts vs all
% ex. normal_vs_all, linear_vs_all, scrambled_vs_all, still_vs_all
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

%% compute dynamic formats vs each other dynamic format
% ex. normal_vs_linear, normal_vs_scrambled, etc

% compute normal vs each other dynamic format
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

% compute scrambled vs each other dynamic format
% compute scrambled vs normal
active_conds = scrambled;
control_conds = normal;
contrast_name = 'scrambled_vs_normal';
hi = computeContrastMap2(hi, active_conds, control_conds, contrast_name, 'mapUnits','T');
% storing contrast map as nifti
niftiFileName = [contrast_name,'.nii.gz'];
contrastNifti = contrastMap2Nii(hi.map{1},niftiFileName, functional_niftis);
% saving nifti under Inplane/GLMs/NiftiMaps
cd Inplane/GLMs/NiftiMaps
writeFileNifti(contrastNifti);
cd ../../..

% compute scrambled vs normal
active_conds = scrambled;
control_conds = linear;
contrast_name = 'scrambled_vs_linear';
hi = computeContrastMap2(hi, active_conds, control_conds, contrast_name, 'mapUnits','T');
% storing contrast map as nifti
niftiFileName = [contrast_name,'.nii.gz'];
contrastNifti = contrastMap2Nii(hi.map{1},niftiFileName, functional_niftis);
% saving nifti under Inplane/GLMs/NiftiMaps
cd Inplane/GLMs/NiftiMaps
writeFileNifti(contrastNifti);
cd ../../..

% compute scrambled vs still
active_conds = scrambled;
control_conds = still;
contrast_name = 'scrambled_vs_still';
hi = computeContrastMap2(hi, active_conds, control_conds, contrast_name, 'mapUnits','T');
% storing contrast map as nifti
niftiFileName = [contrast_name,'.nii.gz'];
contrastNifti = contrastMap2Nii(hi.map{1},niftiFileName, functional_niftis);
% saving nifti under Inplane/GLMs/NiftiMaps
cd Inplane/GLMs/NiftiMaps
writeFileNifti(contrastNifti);
cd ../../..

% compute linear vs each other dynamic format
% compute linear vs normal
active_conds = linear;
control_conds = normal;
contrast_name = 'linear_vs_normal';
hi = computeContrastMap2(hi, active_conds, control_conds, contrast_name, 'mapUnits','T');
% storing contrast map as nifti
niftiFileName = [contrast_name,'.nii.gz'];
contrastNifti = contrastMap2Nii(hi.map{1},niftiFileName, functional_niftis);
% saving nifti under Inplane/GLMs/NiftiMaps
cd Inplane/GLMs/NiftiMaps
writeFileNifti(contrastNifti);
cd ../../..

% compute linear vs scrambled
active_conds = linear;
control_conds = scrambled;
contrast_name = 'linear_vs_scrambled';
hi = computeContrastMap2(hi, active_conds, control_conds, contrast_name, 'mapUnits','T');
% storing contrast map as nifti
niftiFileName = [contrast_name,'.nii.gz'];
contrastNifti = contrastMap2Nii(hi.map{1},niftiFileName, functional_niftis);
% saving nifti under Inplane/GLMs/NiftiMaps
cd Inplane/GLMs/NiftiMaps
writeFileNifti(contrastNifti);
cd ../../..

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

% compute still vs each other dynamic format
% compute still vs normal
active_conds = still;
control_conds = normal;
contrast_name = 'still_vs_normal';
hi = computeContrastMap2(hi, active_conds, control_conds, contrast_name, 'mapUnits','T');
% storing contrast map as nifti
niftiFileName = [contrast_name,'.nii.gz'];
contrastNifti = contrastMap2Nii(hi.map{1},niftiFileName, functional_niftis);
% saving nifti under Inplane/GLMs/NiftiMaps
cd Inplane/GLMs/NiftiMaps
writeFileNifti(contrastNifti);
cd ../../..

% compute still vs normal
active_conds = still;
control_conds = scrambled;
contrast_name = 'still_vs_scrambled';
hi = computeContrastMap2(hi, active_conds, control_conds, contrast_name, 'mapUnits','T');
% storing contrast map as nifti
niftiFileName = [contrast_name,'.nii.gz'];
contrastNifti = contrastMap2Nii(hi.map{1},niftiFileName, functional_niftis);
% saving nifti under Inplane/GLMs/NiftiMaps
cd Inplane/GLMs/NiftiMaps
writeFileNifti(contrastNifti);
cd ../../..

% compute still vs linear
active_conds = still;
control_conds = linear;
contrast_name = 'still_vs_linear';
hi = computeContrastMap2(hi, active_conds, control_conds, contrast_name, 'mapUnits','T');
% storing contrast map as nifti
niftiFileName = [contrast_name,'.nii.gz'];
contrastNifti = contrastMap2Nii(hi.map{1},niftiFileName, functional_niftis);
% saving nifti under Inplane/GLMs/NiftiMaps
cd Inplane/GLMs/NiftiMaps
writeFileNifti(contrastNifti);
cd ../../..

%% compute normal vs still all categories
% added after making addtional maps for subj02 still needs to be tested 
for category_index = 1:length(categories)
    curr_category = categories{category_index};

    active_conds = curr_category(1); %normal motion condition for the category
    control_conds = curr_category(4); %still condition for the category

    contrast_name = [categories_names{category_index} '-normal_vs_' categories_names{category_index} '-still'];

    hi = computeContrastMap2(hi, active_conds, control_conds, contrast_name, 'mapUnits','T');
    % storing contrast map as nifti
    niftiFileName = [contrast_name,'.nii.gz'];
    contrastNifti = contrastMap2Nii(hi.map{1},niftiFileName, functional_niftis);
    % saving nifti under Inplane/GLMs/NiftiMaps
    cd Inplane/GLMs/NiftiMaps
    writeFileNifti(contrastNifti);
    cd ../../..
end

%% compute combined scenes contrast
% scenesCombined_vs_all
scenes = [25 26 27 28 29 30 31 32];
active_cond = scenes;
control_conds = setdiff(cond_num_list, active_cond);
contrast_name = 'scenesCombined_vs_all';
hi = computeContrastMap2(hi, active_cond, control_conds, contrast_name, 'mapUnits','T');
% storing contrast map as nifti
niftiFileName = [contrast_name,'.nii.gz'];
contrastNifti = contrastMap2Nii(hi.map{1},niftiFileName, functional_niftis);
% saving nifti under Inplane/GLMs/NiftiMaps
cd Inplane/GLMs/NiftiMaps
writeFileNifti(contrastNifti);
cd ../../..

%% compute combined objects contrast
% objectsCombined_vs_all
objects = [17 18 19 20 21 22 23 24];
active_cond = objects;
control_conds = setdiff(cond_num_list, active_cond);
contrast_name = 'objectsCombined_vs_all';
hi = computeContrastMap2(hi, active_cond, control_conds, contrast_name, 'mapUnits','T');
% storing contrast map as nifti
niftiFileName = [contrast_name,'.nii.gz'];
contrastNifti = contrastMap2Nii(hi.map{1},niftiFileName, functional_niftis);
% saving nifti under Inplane/GLMs/NiftiMaps
cd Inplane/GLMs/NiftiMaps
writeFileNifti(contrastNifti);
cd ../../..

%% compute animate vs inanimate
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

%%
disp(['Successfully computed DynaCat contrast maps for ' session_path '!'])
