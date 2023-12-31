function dynacat_computeContrastMaps(session_path)
% dynacat_computeContrastMaps(session_path)
% computes contrast maps for dynacat
% 
% Inputs:s
% session_path: path to subject's session folder, 
%               ex: '/share/kalanit/biac2/kgs/projects/DynamicCategories/data/DynaCat/subj-01/session1/'
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

%% Load condition info
% Load initialized session
load mrInit_params.mat
load mrSESSION.mat

% Find conditions for computing contrast maps
% complile list of all conditions in parfiles
[cond_nums, conds] = deal([]); cnt = 0;
for rr = 1:length(params.functionals)
    fid = fopen(params.parfile{rr}, 'r');
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

% store functional nifti data field
functional_niftis = readFileNifti(params.functionals{1});

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
faces = [1 2 3];
hands = [4 5 6];
bodies = [7 8 9];
animals = [10 11 12];
objects1 = [13 14 15];
objects2 = [16 17 18];
scenes1 = [19 20 21];
scenes2 = [22 23 24];

categories = {faces hands bodies animals objects1 objects2 scenes1 scenes2};
categories_names = {'faces' 'hands' 'bodies' 'animals' 'objects1' 'objects2' 'scenes1' 'scenes2'};

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
normal = [1 4 7 10 13 16 19 22];
linear = [2 5 8 11 14 17 20 23];
still = [3 6 9 12 15 18 21 24];

dynamic_format = {normal linear still};
dynamic_format_names = {'normal' 'linear' 'still'};

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
% ex. normal_vs_linear, normal_vs_still, etc

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
for category_index = 1:length(categories)
    curr_category = categories{category_index};

    active_conds = curr_category(1); %normal motion condition for the category
    control_conds = curr_category(3); %still condition for the category

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

%% compute normal for each category normal vs normal for all categories
for category_index = 1:length(categories)
    curr_category = categories{category_index};

    active_conds = curr_category(1); %normal motion condition for the categories
    control_conds = setdiff(normal, active_conds); %all other normal motion conditions

    contrast_name = [categories_names{category_index} '-normal_vs_allNormal'];

    hi = computeContrastMap2(hi, active_conds, control_conds, contrast_name, 'mapUnits','T');
    % storing contrast map as nifti
    niftiFileName = [contrast_name,'.nii.gz'];
    contrastNifti = contrastMap2Nii(hi.map{1},niftiFileName, functional_niftis);
    % saving nifti under Inplane/GLMs/NiftiMaps
    cd Inplane/GLMs/NiftiMaps
    writeFileNifti(contrastNifti);
    cd ../../..

end

%% compute still for each category still vs still for all categories
for category_index = 1:length(categories)
    curr_category = categories{category_index};

    active_conds = curr_category(3); %still motion condition for the categories
    control_conds = setdiff(still, active_conds); %all other normal motion conditions

    contrast_name = [categories_names{category_index} '-still_vs_allStill'];

    hi = computeContrastMap2(hi, active_conds, control_conds, contrast_name, 'mapUnits','T');
    % storing contrast map as nifti
    niftiFileName = [contrast_name,'.nii.gz'];
    contrastNifti = contrastMap2Nii(hi.map{1},niftiFileName, functional_niftis);
    % saving nifti under Inplane/GLMs/NiftiMaps
    cd Inplane/GLMs/NiftiMaps
    writeFileNifti(contrastNifti);
    cd ../../..

end

%% compute linear for each category vs linear for all categories
for category_index = 1:length(categories)
    curr_category = categories{category_index};

    active_conds = curr_category(2); %still motion condition for the categories
    control_conds = setdiff(linear, active_conds); %all other normal motion conditions

    contrast_name = [categories_names{category_index} '-linear_vs_allLinear'];

    hi = computeContrastMap2(hi, active_conds, control_conds, contrast_name, 'mapUnits','T');
    % storing contrast map as nifti
    niftiFileName = [contrast_name,'.nii.gz'];
    contrastNifti = contrastMap2Nii(hi.map{1},niftiFileName, functional_niftis);
    % saving nifti under Inplane/GLMs/NiftiMaps
    cd Inplane/GLMs/NiftiMaps
    writeFileNifti(contrastNifti);
    cd ../../..

end

%%

% % compute combined scenes contrast
% scenesCombined_vs_all
% scenes = [25 26 27 28 29 30 31 32];
% active_cond = scenes;
% control_conds = setdiff(cond_num_list, active_cond);
% contrast_name = 'scenesCombined_vs_all';
% hi = computeContrastMap2(hi, active_cond, control_conds, contrast_name, 'mapUnits','T');
% storing contrast map as nifti
% niftiFileName = [contrast_name,'.nii.gz'];
% contrastNifti = contrastMap2Nii(hi.map{1},niftiFileName, functional_niftis);
% saving nifti under Inplane/GLMs/NiftiMaps
% cd Inplane/GLMs/NiftiMaps
% writeFileNifti(contrastNifti);
% cd ../../..
% 
% % compute combined objects contrast
% objectsCombined_vs_all
% objects = [17 18 19 20 21 22 23 24];
% active_cond = objects;
% control_conds = setdiff(cond_num_list, active_cond);
% contrast_name = 'objectsCombined_vs_all';
% hi = computeContrastMap2(hi, active_cond, control_conds, contrast_name, 'mapUnits','T');
% storing contrast map as nifti
% niftiFileName = [contrast_name,'.nii.gz'];
% contrastNifti = contrastMap2Nii(hi.map{1},niftiFileName, functional_niftis);
% saving nifti under Inplane/GLMs/NiftiMaps
% cd Inplane/GLMs/NiftiMaps
% writeFileNifti(contrastNifti);
% cd ../../..

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
% compute normal for each category vs still for that category
for category_index = 1:length(categories)
    curr_category = categories{category_index};

    active_conds = curr_category(1); %normal motion condition for the category
    control_conds = curr_category(3); %still condition for the category

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


%%
disp(['Successfully computed DynaCat contrast maps for ' session_path '!'])
