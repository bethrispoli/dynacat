function contrastNifti = dynacat_contrastMap2Nii(map, fileName, anatNifti)
%
% Conversion of a contrast map stored as an array to a nifti structure
%
% contrastNifti = contrastMap2Nii(map,fileName,functionalNifti)
%
% INPUTS
% 1) map: contrast map to be stored as a nifti, for instance from hidden 
%         inplane hi.map{1} (three dimensional array)
% 2) fileName: filename for the nifti to be created (string)
% 3) anatNifti: nifti structure produced by the vistasoft function
%                     readFileNifti on the T1 anatomy nifti (use readFileNifti(vANATOMYPATH).This
%                     structure will be used to designate data fields for contrastNifti (struct)
%
% OUTPUT
% 1) contrastNifti: structure that can be written into a nifti using the
%                   vistasoft function writeFileNifti (struct)

% use data fields already defined in anat nifti
contrastNifti = anatNifti;

% assign map to contrastNifti's data, and reorganizing the array
uint8data = uint8(map); % convert map datatype into uint8 from double
contrastNifti.data = uint8data;

% assigning filename
contrastNifti.fname = fileName;
contrastNifti.descrip = 'NIFIT-1 contrast map for dynacat';

% recalculating number of dimensions, max and min
contrastNifti.ndim = length(size(contrastNifti.data));
contrastNifti.dim = size(contrastNifti.data);
contrastNifti.pixdim = contrastNifti.pixdim(1:contrastNifti.ndim);
contrastNifti.cal_min = min(contrastNifti.data(:));
contrastNifti.cal_max = max(contrastNifti.data(:));

%data = cell2mat(contrastNifti.data.map);
%contrastNifti.cal_min = min(data);
%contrastNifti.cal_max = max(data);

end