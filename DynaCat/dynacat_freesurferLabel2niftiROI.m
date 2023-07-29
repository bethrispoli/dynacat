function dynacat_freesurferLabel2niftiROI(subject_dir, subject, hemi, labels, vistaDir)
%function dynacat_freesurferLabel2niftiROI(subject_dir, subject, hemis, labels, vistaDir)
% This function converts labels/ROIs drawn in freesurfer to niftis that can
% be read by mrVista. It will need to be converted into .mat format using
% niftiROI2mrVistaROI.
%   subject_dir: freesurfer directory
%   subject: freesurfer subject ID
%   hemis: rh and/or lh
%   labels: vector of labels 
%   vistaDir: path to 3DAnatomy 
%
% right now just taking the register.dat making code snippet for dynacat
% but might need the rest later

% Setup
anatDir = fullfile(vistaDir,'3DAnatomy');
fsDir = fullfile(subject_dir, subject);

for l = 1:numel(labels)
    
    % load the label file
    %labelName = labels(l);
    labelName = cell2mat(strrep(labels(l), '.label', ''));

    % volume to align nifti to
    tmp = fullfile(fsDir,'mri','T1.mgz');

    % output volume name
    niftiFileName = [labelName '.nii.gz'];
    %outname = fullfile(anatDir,'niftiROIs',niftiFileName);
    outname = fullfile(fsDir,'niftiROIs',niftiFileName);
    
    % create registration file if it doesn't exist
    reg = fullfile(fsDir,'surf','register.dat');
    if ~isfile(reg)
     origPath = [fsDir, subject, '/mri/orig.mgz'];
     outFile = [fsDir, subject, '/surf/register.dat'];
     cmd = ['tkregister2 --mov ' origPath ' --noedit --s ' subject ' --regheader --reg ' outFile];
     unix(cmd)
    end

    % convert the .label file to nifti format
    cmd = [' mri_label2vol --label ',fullfile(fsDir,'label',[labelName, '.label']),...
     ' --temp ', tmp,...
     ' --identity', ...
     ' --proj frac 0 1 .1',...
     ' --subject ' subject,...
     ' --hemi ',hemi,...
     ' --fill-ribbon --o ',outname];
    system(cmd)        
end

