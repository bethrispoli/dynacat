
% computing additional face and hand maps across all my subjects at once

% subject_sessions = {'/share/kalanit/biac2/kgs/projects/DynamicCategories/data/DynaCat/test_subj04/session1/',...
%     '/share/kalanit/biac2/kgs/projects/DynamicCategories/data/DynaCat/test_subj05/session1/',...
%     '/share/kalanit/biac2/kgs/projects/DynamicCategories/data/DynaCat/test_subj06/session1/',...
%     '/share/kalanit/biac2/kgs/projects/DynamicCategories/data/DynaCat/subj-07/session1/'};

subject_sessions = {'/share/kalanit/biac2/kgs/projects/DynamicCategories/data/DynaCat/subj-06/session1/'};

for sub=1:length(subject_sessions)
    curr_sub = subject_sessions{sub};
    session_path = curr_sub;
    
    %% Load session parameters
    cd(session_path)
    % Load initialized session
    load mrInit_params.mat
    load mrSESSION.mat
    load session_setup.mat
    
    % Set vAnatomy
    vANATOMYPATH = '3DAnatomy/t1.nii.gz';
    saveSession
    
    %% Load condition info
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
    
    normal = [1 4 7 10 13 16 19 22];
    linear = [2 5 8 11 14 17 20 23];
    still = [3 6 9 12 15 18 21 24];
    
    dynamic_format = {normal linear still};
    dynamic_format_names = {'normal' 'linear' 'still'};
    
    % store functional nifti data fields
    functional_niftis = readFileNifti(params.functionals{1});
    
    %% Initialize list of created additional maps
    additional_maps = {};
    
    %% Compute additional maps
    % put your code here to compute any additional maps you want that weren't
    % already computed with dynacat_computeContrastMaps.m in dynacat_analysis_step2
    % include map_name = [contrast_name '.mat']; and additional_maps = [additional_maps; map_name]; 
    % to keep track of what maps you have made
    
    % initialize hidden inplane
    hi = initHiddenInplane('GLMs', 1);
    
    % faces vs things without faces
    active_conds = faces;
    control_conds = [hands, objects1, objects2, scenes1, scenes2];
    contrast_name = ['faces-allMotion_vs_hands-objects-scenes'];
    
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
    
    
    % faces vs objects + scenes
    active_conds = faces;
    control_conds = [objects1, objects2, scenes1, scenes2];
    contrast_name = ['faces-allMotion_vs_objects-scenes'];
    
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
    
    
    % hands vs things without hands
    active_conds = hands;
    control_conds = [faces, objects1, objects2, scenes1, scenes2];
    contrast_name = ['hands-allMotion_vs_faces-objects-scenes'];
    
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
    
    
    % hands vs objects + scenes
    active_conds = hands;
    control_conds = [objects1, objects2, scenes1, scenes2];
    contrast_name = ['hands-allMotion_vs_objects-scenes'];
    
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
    
    
    % bodies vs objects + scenes
    active_conds = bodies;
    control_conds = [objects1, objects2, scenes1, scenes2];
    contrast_name = ['bodies-allMotion_vs_objects-scenes'];
    
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
    
    % animals vs objects + scenes
    active_conds = animals;
    control_conds = [objects1, objects2, scenes1, scenes2];
    contrast_name = ['animals-allMotion_vs_objects-scenes'];
    
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
    
    
    %% Transform contrast maps to gray
    % rewritten code snippet from ip2volAllParMaps.m to only convert the maps
    % we specify in the additional_maps array
    
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
        %disp(['Transforming ' f{i}]);
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
        curr_contrast_name = char(additional_maps{i});
        map_path = fullfile(session_gray_dir, curr_contrast_name);
        
        dynacat_mrvGray2fsSurf_parameterMaps(session_path, map_path, fullfile(setup.fsDir, setup.fsSession), setup.fsSession)
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
    
    close all
end
