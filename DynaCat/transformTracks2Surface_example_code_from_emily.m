%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Transforms the trackmaps to the cortical surface
%
%
% Updated adapted from s2_transformTracks2surface by DF.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function transformTracks2Surface(fatDir,fsDir,sessid,anatid,fsid,ROIs,...
    rad,runName,t1_name,hems,fibername,fmriyear,fmrisession)



%% Loop through hemis 
for tt = 1:length(fibername)
for h = 1:2

    % loop through sessions and transform maps to fsaverage surfaces using CBA
    for s = 1:length(sessid)
        year = int2str(fmriyear(s));
        sess = int2str(fmrisession(s));
        % path to subject data in 3Danat
        anat_dir = fullfile(fatDir, sessid{s}, '96dir_run1/t1');
        % path to subject data in FreesurferSegmentations
        fs_dir = fullfile(fsDir, fsid{s});
        % paths to subject mri and surf directories
        mri_dir = fullfile(fs_dir, 'mri');
        surf_dir = fullfile(fs_dir, 'surf');

        track_dir = fullfile(anat_dir, 'tracks');

        for n = 1:length(ROIs)
            %ROIName = strsplit(ROIs{n}, '.');

            map_name = [hems{h},'_',ROIs{n}, '_0',year,'_',sess, '_disk_3mm_projed_gmwmi_r', num2str(rad), '.00_',fibername{tt},'_track'];
            trkName = [hems{h},'_',ROIs{n}, '_0',year,'_',sess, '_disk_3mm_projed_gmwmi_r', num2str(rad), '.00_',fibername{tt},'.tck'];
            fg = fullfile(fatDir, sessid{s}, runName{1}, 'dti96trilin/fibers/afq', trkName)

            if exist(fg)
                map_path = fullfile(anat_dir, 'tracks', [map_name, '_resliced.nii.gz']);
                cd(fullfile(anat_dir, 'tracks'));
                unix(['mri_convert -ns 1 -odt float -rt interpolate -rl ', mri_dir, '/orig.mgz ', ...
                    track_dir, '/', map_name, '.nii.gz ', track_dir, '/', map_name, '_resliced.nii.gz --conform']);

                % generate freesurfer-compatible surface files for each hemisphere
                cd(surf_dir);

                proj_values = [-.5:0.1:.5];
                for p = 1:length(proj_values)
                    unix(['mri_vol2surf --mov ', map_path, ' ', ...
                            '--reg register.dat --hemi ' hems{h} ' --interp trilin --o ', ...
                            fullfile(surf_dir, strcat(map_name, '_', hems{h}, '_proj_', num2str(proj_values(p)), '.mgh')), ...
                            ' --projfrac ', num2str(proj_values(p))]); % left hemi
                end
                
                if exist(strcat(map_name, '_', hems{h}, '_proj_max.mgh'))
                    prev_max_map = strcat(map_name, '_', hems{h}, '_proj_max.mgh');
                    delete(prev_max_map)
                end
                
                unix(['mri_concat --i ', strcat(map_name, '_', hems{h}, '_proj_*'), ...
                        ' --o ', strcat(map_name, '_', hems{h}, '_proj_max.mgh'), ...
                        ' --max']);
            end

        end
    end
end
end

clear all;
close all