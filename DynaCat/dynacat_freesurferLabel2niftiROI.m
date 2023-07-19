function freesurferLabel2niftiROI(subject_dir, subject, hemis, labels, vistaDir)
%
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
fsDir = fullfile(subject_dir, subject)

for h = 1:numel(hemis)
    for l = 1:numel(labels)
        
        % load the label file
        labelName = [hemis{h}, '.', labels{l}, '_toon'];

        % volume to align nifti to
        tmp = fullfile(fsDir,'mri','T1.mgz');

        % output volume name
        outname = fullfile(anatDir,'niftiROIs',[labelName,'.nii.gz']);
        
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
         ' --hemi ',hemis{h},...
         ' --fill-ribbon --o ',outname];
        system(cmd)        
    end
end

end
