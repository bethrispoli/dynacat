
% save visualzations for a bunch of subjects at a time
% because i messed up the function and now need to redo it

subjects = {'test_subj05', 'test_subj06', 'subj-07'};
for i = 1:length(subjects)
    curr_subj = subjects{i};

    session_path = fullfile('/share/kalanit/biac2/kgs/projects/DynamicCategories/data/DynaCat', curr_subj, 'session1');
    cd(session_path)
    
    disp(['Now processing ' curr_subj 'from filepath: ' session_path])

    % Load initialized session
    load mrInit_params.mat
    load mrSESSION.mat
    load session_setup.mat
    
    % Set vAnatomy
    vANATOMYPATH = '3DAnatomy/t1.nii.gz';
    saveSession

    % get an array of all the .mat contrast filenames
    session_gray_dir = fullfile(session_path, 'Gray', 'GLMs');
    gray_GLMs = dir(fullfile(session_gray_dir, '*.*'));
    gray_contrasts_names = {gray_GLMs.name};
    gray_contrasts_names = gray_contrasts_names(5:length(gray_contrasts_names)); 


    % Remove the '.mat' extension from each filename to get an array of just contrast names
    contrasts_names = cellfun(@(x) strrep(x, '.mat', ''), gray_contrasts_names, 'UniformOutput', false);
    
    % generate lateral and ventral visualizations for each contrast 
    for i = 1:length(contrasts_names)
        curr_contrast_name_cell = contrasts_names(i);
        curr_contrast_name = char(curr_contrast_name_cell{1});
        
        disp(['Saving visualization for ' curr_contrast_name '. ' num2str(i) '/' num2str(length(contrasts_names)) ' remaining...'])
        dynacat_saveFreeviewVisualizations(session_path, setup.fsDir, setup.fsSession, curr_contrast_name)
    end
    disp(['Successfully exported visualizations for ' num2str(length(contrasts_names)) ' maps! Saved to subj/session/Images.'])

end


