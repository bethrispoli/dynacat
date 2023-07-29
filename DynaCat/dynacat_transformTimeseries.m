function dynacat_transformTimeseries(session_path)
% dynacat_transformTimeseries(session_path)
% 
% Transforms the time series from the inplane to volume anatomy.
% Xform time series from inplane to gray using trilinear interpolation.
%
% Inputs
% session_path: path to subject's session folder, ex. '/share/kalanit/biac2/kgs/projects/DynamicCategories/data/DynaCat/subj-01/session1/'
%
% BR July 2023 (adapted from code by AS & SP & DF for fLoc and Toon)

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

%% Transform tseries
% Now we can open a gray view
hg = initHiddenGray('MotionComp_RefScan1', 1);

% Xform time series from inplane to gray using trilinear interpolation
hg = ip2volTSeries(hi,hg,0,'linear');

% save Session with the new dataTYPE
saveSession;

