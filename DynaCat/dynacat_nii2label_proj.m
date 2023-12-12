%% transforms ROIs from niftis to fs labels
% Edited to remove adding hemisphere prefixes
% DF 11/2019
% edited by EK 09/2020

function dynacat_nii2label_proj(fsDir, fsid,dataPath,roiList,roiVal,hemi)

    labelPath = fullfile(fsDir, 'label');

	for roi = 1:length(roiList)

		if isempty(roiVal)
			roiVal(roi) = 1;
		end

		reslicePath = fullfile(fsDir,'mri', 'orig.mgz');
		%inName=strcat(hemi,'_',roiList(roi),'.nii.gz');
        inName=strcat(roiList(roi),'.nii.gz');
		%inFile=fullfile(dataPath,inName);
        inFile = fullfile(dataPath,'mFus-faces-AllMotion_rh_dynacat_beth_reinflated_from_mrvista.nii.gz');
		%outName=strcat(hemi,'_',roiList(roi),'_conformed.nii.gz');
        outName=strcat(roiList(roi));
		outFile=fullfile(dataPath,'mFus-faces-AllMotion_rh_dynacat_beth_reinflated_from_mrvista_conformed.nii.gz');
		
		cmd = ['mri_convert -rl ' reslicePath ' -rt nearest -ns 1 --conform ' inFile ' ' outFile];
		unix(cmd);
		
        outpath = fullfile(labelPath, outName);
		%labelName = strcat(hemi,'.',roiList(roi),'.label');
        labelName = strcat(roiList(roi),'.label');
		saveLabel=fullfile(labelPath,labelName);
% 		cmd = ['mri_vol2label --c ' outFile{1} ' --id ' num2str(roiVal(roi)) ' --l ' saveLabel{1}];
% 		unix(cmd);
        
        mgz = strcat(roiList(roi),'.mgz');
		mgzSave=fullfile(labelPath,mgz);
        
        %proj_values = [0:0.1:1];
        proj_values = [-0.5:0.1:0.5];
        for p = 1:length(proj_values)
            p_out = fullfile(labelPath,strcat(roiList(roi), '_proj_', num2str(proj_values(p)), '.mgz'));
            cmd = ['mri_vol2surf  --src ' outFile ' --out ' p_out{1} ' --srcreg ' fullfile(fsDir, 'surf', 'register.dat') ' --hemi ' hemi ' --projfrac ' num2str(proj_values(p))];
            unix(cmd)
        end
        stem = fullfile(labelPath,roiList(roi));
        unix(['mri_concat --i ', strcat(stem{1},  '_proj_*'), ...
                        ' --o ', mgzSave{1}, ...
                        ' --max']);
                    
        cmd = ['mri_cor2label --i ' mgzSave{1} ' --id ' num2str(roiVal(roi)) ' --l ' saveLabel{1} ' --surf ' fsid ' ' hemi ' inflated '];
 		unix(cmd);

	end

