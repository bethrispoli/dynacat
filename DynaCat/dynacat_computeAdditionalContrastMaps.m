% DynaCat Analysis: Compute Addtional Contrast Maps
%
% Use to create any additional contrast maps not set in dynacat_computeContrastMaps.m
% 
% INPUTS (set below)
% 1) session_path: fullpath to scanning session directory in ~/DynaCat/data/ that 
%             is being analyzed (string), ex. ~/DynaCat/data/subj-01/session1/
% OUTPUT
% 1) additionally coded contrast maps
% 2) contrast maps converted into the Gray
% 3) contrast maps converted into FreeSurfer surfaces
% 4) visualizations of contrast maps on the surface using parameters set in dynacat_saveFreeviewVisualizations.m

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

%% Find conditions info
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

% seperate conditions by category and dynamic format
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

normal = [1 5 9 13 17 21 25 29];
scrambled = [3 7 11 15 19 23 27 31];
linear = [2 6 10 14 18 22 26 30];
still = [4 8 12 16 20 24 28 32];

dynamic_format = {normal scrambled linear still};
dynamic_format_names = {'normal' 'scrambled' 'linear' 'still'};

% store functional nifti data fields
functional_niftis = readFileNifti(init_params.functionals{1});

%% Initialize list of created additional maps
additional_maps = {};

%% Compute additional maps
% put your code here to compute any additional maps you want that weren't
% already computed with dynacat_computeContrastMaps.m in dynacat_analysis_step2
% include map_name = [contrast_name '.mat']; and additional_maps = [additional_maps; map_name]; 
% to keep track of what maps you have made

% compute normal for each category vs still for that category
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

    map_name = [contrast_name '.mat'];
    additional_maps = [additional_maps; map_name];
end

%% Transform contrast maps to gray
% rewritten code snippet from ip2volAllParMaps.m to only convert the maps
% we specify in the additional_maps array

% Open hidden inplane
hi = initHiddenInplane('MotionComp_RefScan1', 1);
% Open hidden gray
hg = initHiddenGray('MotionComp_RefScan1', 1);

%transform maps
hi = initHiddenInplane('GLMs',1);
hg = initHiddenGray('GLMs',1);

inplane = hi;
volume = hg;

%check data types
[inplane ,volume] = checkTypes(inplane, volume);


for i = 1:length(additional_maps)
    mapPath = fullfile(dataDir(inplane), additional_maps{i});
    disp(['Transforming ' f{i}]);
    test = load( mapPath );
    if isfield(test, 'map')   % has a param map
        inplane = loadParameterMap(inplane, mapPath);
        ip2volParMap(inplane, volume, 0, 1, 'linear');
    end
end

% save Session
saveSession;

%% Import contrast maps into FreeSurfer
% go through all the generated constrast maps for Gray and convert them
% into FreeSurfer compatible maps in 3DAnatomy/surf

session_gray_dir = fullfile(session_path, 'Gray', 'GLMs');

% convert each contrast map into a Freesurfer compatible map
for i = 1:length(additional_maps)
    curr_contrast_name_cell = additional_maps(i);
    curr_contrast_name = char(additional_maps{1});
    map_path = fullfile(session_gray_dir, curr_contrast_name);
    
    dynacat_mrv2fs_parameterMap(map_path, setup.fsDir, setup.fsSession)
end

%% Save contrast map visualizations
% using Freeview commands, load each contrast map in Freeview and save a
% screenshot in subj-xx/session1/Images

% Remove the '.mat' extension from each filename to get an array of just contrast names
contrasts_names = cellfun(@(x) strrep(x, '.mat', ''), additional_maps, 'UniformOutput', false);

% generate lateral and ventral visualizations for each contrast 
for i = 1:length(contrasts_names)
    curr_contrast_name_cell = contrasts_names(i);
    curr_contrast_name = char(curr_contrast_name_cell{1});
    
    disp(['Saving visualization for ' curr_contrast_name '. ' num2str(i) '/' num2str(length(contrasts_names)) ' remaining...'])
    dynacat_saveFreeviewVisualizations(session_path, setup.fsDir, setup.fsSession, curr_contrast_name)
end
disp(['Successfully exported visualizations for ' num2str(length(contrasts_names)) ' maps! Saved to subj/session/Images.'])

%%
% slay
