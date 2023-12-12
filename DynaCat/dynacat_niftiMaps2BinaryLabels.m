function dynacat_niftiMaps2BinaryLabels(subject_dir, subject, labels, hemi, vistaDir)
%CREATE_MASKS Create thresholded masks and labels using FreeSurfer commands
%
%   subject: string of subject's freesurfer name
%   hemispheres: a string of a hemisphere ex. 'lh' or 'rh'
%   subjects_dir: A string specifying the FreeSurfer subjects directory - subjects_dir = '/path/to/subjects/dir';
% 

% Setup
anatDir = fullfile(vistaDir,'3DAnatomy');
fsDir = fullfile(subject_dir, subject);

for i = 1:numel(labels)
    label = cell2mat(labels(i));
    label_file_path = fullfile(fsDir, 'surf', 'dynacat_maps', 'dynacat_proj_max_maps', [label '.mgh']);

    mask_outname = [label '-thresh3binary.mgh'];
    output_folder_path = fullfile(fsDir, 'label', 'binarized_contrasts');
    if ~exist(output_folder_path, 'dir')
        mkdir(output_folder_path)
    end
    mask_outpath = fullfile(output_folder_path, mask_outname);

    % Create thresholded mask
    cmd = ['mri_binarize --i ', label_file_path, ' --mask-thresh 3 --min 3', ' --o ', mask_outpath];
    system(cmd);

    label_outname = [label '-thresh3binary.label'];
    label_outpath = fullfile(output_folder_path, label_outname);

    cmd = ['mri_vol2label --i ', mask_outpath, ' --surf ', subject, ' ', hemi, ' --id 1 --l ', label_outpath];
    system(cmd)

end


