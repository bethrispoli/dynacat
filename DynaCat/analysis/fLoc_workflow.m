%% fLoc Analysis
% This script preprocesses and applies GLM to fLoc dataset.
% This script requires vistasoft, alignvolumedata, KNK toolboxes, which can
% added with the following:
%
% addpath(genpath('~/matlab/git/toolboxes/knkutils/'))
% addpath(genpath('~/matlab/git/toolboxes/alignvolumedata/'))
% addpath(genpath('/share/kalanit/software/vistasoft/'))
% 
% If you get the error about unitConvert, you have to remove the Symbolic
% toolbox from your path: 
rmpath(genpath(fullfile('/software/matlab/R2020b/toolbox/symbolic/symbolic')))
%% Set session information and paths 
% Go to project path on native oak 
cd('/oak/stanford/groups/kalanit/biac2/kgs/projects')
currDir             = pwd; 
nativeOakProjectPth =  currDir; 
cd(nativeOakProjectPth)

anatDir = fullfile('./anatomy');
expDir  = fullfile('./spatiotemporal','experiments','fLoc');
codeDir = fullfile(expDir, 'code');

% [ek]: Preferably this should also added to the ToolboxToolbox and synced on github
% [IK]: Agreed!
addpath(genpath(fullfile(currDir, codeDir))); 
cd(expDir)
%% Define subject
subjNumber = 15;
% For S14, fLoc data come from Emoji study, and anatomy lives on oak:
% /oak/stanford/groups/kalanit/biac2/kgs/anatomy/ST (both freesurferRecon
% and vistavol combined)
anatNames  = {'kgs201310','kis202008','ek202011', 'hk2019', ... S1-S4
               'lm202105','ac202105','jj202105','jr202105', ... S5-S8
               'xy202105', 'yc202106', 'yf202202','em201611',...S9-S12
               'bf202111','st202204','dal202207'}; % S13, S14, S15 
usedSessions = {'session1','session1','session2', 'session1', ... S1-S4
               'session3','session1','session1','session1', ... S5-S8
               'session1','session1', 'session1','session1_050317',... % S9-S11
               'session1','16_ST22_fLOC_070821','session1'}; % S13, S14, S15
subjID       = sprintf('subj%02d', subjNumber);

anatName    = anatNames{subjNumber};
session     = usedSessions{subjNumber};
sessionPth  = [ 'data/' subjID '/' session];

%% Make symbolic link to main anatomy folder
if ~exist(fullfile(expDir, sessionPth, '3DAnatomy'), 'dir')
    vistaPath = fullfile('../../../../../../../',anatDir,'vistaVol',anatName);
    line = sprintf('ln -s %s %s/3DAnatomy',vistaPath,fullfile(expDir, sessionPth));
    cd(nativeOakProjectPth)
system(line);
end

%% run fLoc
% input variables: session, init_params, glm_params, clip, QA
cd(fullfile(nativeOakProjectPth,expDir,['data/' subjID],session))
if subjID == 14 % For S14, fLoc data come from Emoji study, pre-clipped already
    clip = 1;
else
    clip = 6; % frames clipped at the beginning of a run (12s count down = 6 frames)
end
dataPath =  fullfile(nativeOakProjectPth,expDir,['data/' subjID], session);

fLocAnalysis(dataPath, [], [], clip, 0);

%% Align inplane anatomy to T1 anatomy (ONLY NEEDED ONCE)
% This requires the vistasoft, alignvolumedata AND KNK toolbox 
load('mrSESSION.mat')
if ~isfield(mrSESSION, 'alignment') || isempty(mrSESSION.alignment)
    % rxAlign;
    s_alignInplaneToAnatomical
end

%% inplane2vol
%choose gray layer = 3
cd(dataPath)
anatPath = ['./3DAnatomy' ];
setVAnatomyPath([anatPath,'/t1.nii.gz'])

XformInplane2Vol

%% Old stuff
% cd(dataPath)

% vw = initHiddenInplane
% 
% query = 0;
% keepAllNodes = false;
% filePaths = {'3DAnatomy/nifti/t1_class.nii.gz'};
% numGrayLayers = 3;
% installSegmentation(query, keepAllNodes, filePaths, numGrayLayers)
% 
% 
% ip = mrVista('inplane');
% gr = mrVista('3View');
% vo = open3ViewWindow('volume');
%
% mrmInflate('rightNoSmooth.mat',200);
% 
% cd(dataPath)
% fName = [dataPath '/3DAnatomy/t1_class.nii.gz'];
% 
% msh = meshBuildFromClass(fName,[],'right');
% msh = meshSet(msh,'smooth_iterations',200);
% msh = meshSmooth(msh);
% msh = meshColor(msh);
% mrmWriteMeshFile(msh,'right_200')
% 
% 
% [nodes,edges,classData] = mrgGrowGray(fName,3); 
% wm = uint8( (classData.data == classData.type.white) | (classData.data == classData.type.gray));
% msh = meshColor(meshSmooth(meshBuildFromClass(wm,[1 1 1])));
% % meshVisualize(msh,2);

% fLocAnalysis(sessions{ss}, [], [], clip(ss), QA)
