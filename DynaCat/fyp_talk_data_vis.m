
% making visualzations for fyp talk

subjects = {'test_subj04', 'test_subj05', 'test_subj06', 'subj-07'};

%% make binary maps
% binarized map labels for faces-allMotion, faces-normal, faces-still,
% hands-allMotion, hands-normal, and hands-still
hemi = 'rh';
labels = {'faces-allMotion_vs_all_rh_proj_max', 'faces-normal_vs_allNormal_rh_proj_max', 'faces-still_vs_allStill_rh_proj_max', ...
    'hands-allMotion_vs_all_rh_proj_max', 'hands-normal_vs_allNormal_rh_proj_max', 'hands-still_vs_allStill_rh_proj_max'};
for i=1:length(subjects)
    subject = subjects{i};
    session_path = fullfile('/share/kalanit/biac2/kgs/projects/DynamicCategories/data/DynaCat', subject, 'session1');
    cd(session_path)

    load session_setup.mat

    dynacat_niftiMaps2BinaryLabels(setup.fsDir, setup.fsSession, labels, hemi, setup.vistaDir)

    clear session_path
    clear setup

end

%puts binary maps in labels/binarized_contrasts