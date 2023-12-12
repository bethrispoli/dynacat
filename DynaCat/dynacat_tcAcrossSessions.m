

exp_dir = '/share/kalanit/biac2/kgs/projects/DynamicCategories/data/DynaCat';
%sessions = {'test_subj04', 'test_subj06'};
%subject_sessions = {'test_subj04', 'test_subj05', 'test_subj06', 'subj-07'};
subject_sessions = {'test_subj04', 'test_subj05', 'subj-06', 'subj-07'};

% convert all ROIs in 
for i=1:length(subject_sessions)
    session_path = fullfile(exp_dir, subject_sessions{i}, 'session1');
    cd(session_path)

    load session_setup.mat
    ROI_list_folder = fullfile(setup.fsDir, setup.fsSession, 'label', 'dynacat_rois');
    ROI_list = dir(fullfile(ROI_list_folder, '*.label'));

    ROI_list = {ROI_list.name};
    % ROI_list(1:2) = [];
    ROI_list = strrep(ROI_list, '.label', '');
    
    convert_surf_ROIs_export_betas_from_mrvista(session_path, ROI_list)
end

% %% plot roi in mrVista, run glm, save plot data and plot image
% dt = 'MotionComp_RefScan1';
% for ii=1:length(rois)
%     curr_roi = rois{ii};
%     for i=1:length(subject_sessions)
%         % Set subject session path
%         % ex. '/home/brispoli/DynamicCategories/data/DynaCat/subj-02/session1/'
%         %i = 1;
%         session_path = fullfile(exp_dir, subject_sessions{i}, 'session1');
% 
%         % Load session parameters
%         cd(session_path)
% 
%         % hg = initHiddenGray(dt, 1, rois{i});
%         hg = initHiddenGray(dt, 1, curr_roi);
% 
%         % addpref('VISTA', 'recomputeVoxData', 1) % save a preference for mrVista to recompute voxel data
%         tc = tc_init(hg, curr_roi, 1, dt, 1);
%         tc = tc_applyGlm(tc);
% 
%         [amps, sems] = tc_amps(tc);
% 
%         %save plot as png
%         %exportsetupdlg;
%         %doExport(hSrc, eventData, tc)
%         ROI = strrep(curr_roi, '.label', '');
%         plot_name = strrep(ROI, '.mat', '_timecourseGLM.png');
%         image_folder_path_dir = fullfile(session_path, 'Images', 'ROI_timecourse_plots');
%         if ~exist(image_folder_path_dir, 'dir')
%             mkdir(image_folder_path_dir);
%         end
%         images_folder_path = fullfile(image_folder_path_dir, plot_name);
%         saveas(gcf, images_folder_path);
% 
%         % dump data to workspace
%         tc_dumpDataToWorkspace;
% 
% 
%         % saving glm data for roi one by one until i think of a better plan
% 
%         % Convert the structure to a table
%         glm_struc = tc.glm;
% 
%         % export betas csv
%         betas = glm_struc.betas;
%         data_folder = fullfile(session_path, 'ROI_data');
%         if ~exist(data_folder, 'dir')
%             mkdir(data_folder);
%         end
%         betas_filename = fullfile(data_folder, [ROI '_betas.csv']);
%         writematrix(betas, betas_filename);
% 
%         % export standard deviations csv
%         stdevs = glm_struc.stdevs;
%         stdevs_filename = fullfile(data_folder, [ROI '_stdevs.csv']);
%         writematrix(stdevs, stdevs_filename);
% 
%         % export sems csv
%         sems = glm_struc.sems;
%         sems_filename = fullfile(data_folder, [ROI '_sems.csv']);
%         writematrix(sems, sems_filename);
% 
%     end
% end
%%

% set p
p.viewType = 'Gray';
p.dataType = 'GLMs';
p.scan = 1;
p.studyDir = '/share/kalanit/biac2/kgs/projects/DynamicCategories/data/DynaCat';
p.volumeRoi = 0;
p.eventParams = [];
p.groups = {};
p.sessionPlots = {'betas'};
p.savePlotsPath = '';
p.cachePath = '';
p.methodFlag = 4;
p.openUI = 1;
p.titleType = 1;

%subject_sessions = {'test_subj04/session1', 'test_subj06/session1', 'subj-07/session1'};
subject_sessions = {'test_subj04/session1', 'test_subj05/session1', 'subj-06/session1', 'subj-07/session1'};

% rois = {'rh_aSTS-facesAllMotion_dynacat_thresh3_BR.mat',...
%     'lh_pFus-facesAllMotion_dynacat_thresh3_BR.mat', 'lh_mFus-facesAllMotion_dynacat_thresh3_BR.mat',...
%     'lh_IOG-facesAllMotion_dynacat_thresh3_BR.mat', 'lh_pSTS-facesAllMotion_dynacat_thresh3_BR.mat', 'lh_aSTS-facesAllMotion_dynacat_thresh3_BR.mat'};

rois = {'rh_OTS-handsAllMotion_dynacat_thresh3_BR.mat', 'rh_LOS-handsAllMotion_dynacat_thresh3_BR.mat', ...
    'rh_MOG-handsAllMotion_dynacat_thresh3_BR.mat', 'rh_ITG-handsAllMotion_dynacat_thresh3_BR.mat', ...
    'lh_OTS-handsAllMotion_dynacat_thresh3_BR.mat', 'lh_LOS-handsAllMotion_dynacat_thresh3_BR.mat', ...
    'lh_MOG-handsAllMotion_dynacat_thresh3_BR.mat', 'lh_ITG-handsAllMotion_dynacat_thresh3_BR.mat'};

for i = 1:length(rois)
    %[tc subjectTcs] = tc_acrossSessions(sessions, roi, p, varargin);
    ROI = rois{i};
    [tc subjectTcs] = tc_acrossSessions(subject_sessions, ROI, p);
    
    %save plot as png
    plot_folder = '/share/kalanit/biac2/kgs/projects/DynamicCategories/results/roi_plots_subj04-07';
    plot_name = strrep(ROI, '.mat', '_timecourseGLM.png');
    images_folder_path = fullfile(plot_folder, plot_name);
    saveas(gcf, images_folder_path);
end





%% dump data to workspace -- was gonna try to plot my own bar plots but maybe not
tc_dumpDataToWorkspace;

glm_struc = fig1Data.glm;
betas = glm_struc.betas;
stdevs = glm_struc.stdevs;
sems = glm_struc.sems;

f = betas;
s = sems;


mybar(f,s,xstr,ystr,col,lineWidth,w,we)
% mybar(f,[s],[xstr],[ystr],[color],[lineWidth],[barwidth],[errorbarwidth])



%% multivoxel data gives us voxel per voxel values and not just overall betas
% mv = mv_init()
% mv = mv_applyGlm(mv)
% amps = mv_amps(mv)



