function dynacat_2gray(session_path)
% dynacat_2gray(session_path);
% 
% Step 3 of the workflow for analyzing toonotopy
% Transforms the time series from the inplane to volume anatomy and
% averages the time series
%
% Default Input values
% session_path       '/share/kalanit/biac2/kgs/projects/DynamicCategories/data/DynaCat/subj-01/session1/'
%
% DF 2020 (adapted from code by AS & SP for fLoc)
% adpting for dynacat beth July 2023

%% Default inputs
if notDefined('session_path')
    fprintf(1,'Error, you need to define a session_path \n');
    return
end

%% Checks
% Check and validate inputs and path to vistasoft
if isempty(which('mrVista'))
    vista_path = 'https://github.com/vistalab/vistasoft';
    error(['Add vistasoft to your matlab path: ', vista_path]);
end

cd(session_path);

%% Load initialized session
load mrInit_params.mat
load mrSESSION.mat

% Open hidden inplane
hi = initHiddenInplane('MotionComp_RefScan1', 1);

%% Install segmentation
% Guess class file path
pattern = fullfile(pwd, '3DAnatomy', '*class*nii*');
w = dir(pattern);
if ~isempty(w),  
    defaultClass = fullfile(pwd, '3DAnatomy', w(1).name);
end
if exist(defaultClass)
    installSegmentation([],[],defaultClass, 3); 
else %open GUI prompt for file name
    installSegmentation([],[],[],3); 
end

%% Transform tseries
% Now we can open a gray view
hg = initHiddenGray('MotionComp_RefScan1', 1);

% Xform time series from inplane to gray using trilinear interpolation
hg = ip2volTSeries(hi,hg,0,'linear');


%% Transform all constrast maps to gray
hi = initHiddenInplane('GLMs',1);
hg = initHiddenGray('GLMs',1);
ip2volAllParMaps(hi, hg, 'linear');


% save Session with the new dataTYPE
saveSession;
