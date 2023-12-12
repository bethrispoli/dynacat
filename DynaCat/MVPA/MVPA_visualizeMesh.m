function vw=MVPA_visualizeMesh(vw,meshlh, meshrh, meshAngleSettinglh, meshAngleSettingrh)
%% 
% vw=MVPA_visualizeMesh(vw,meshlh, meshrh, meshAngleSettinglh, meshAngleSettingrh)
% This function loads meshes, sets them according to meshAngleSetting if specified
% and updates them
%
if notDefined('vw')
    display ('Error, a gray view is needed\n');
end
% set deaults
if notDefined('meshlh')
    meshlh = fullfile('3DAnatomy', 'lh_inflated_200_1.mat');
end
if notDefined('meshrh')
    meshrh = fullfile('3DAnatomy', 'rh_inflated_200_1.mat');
end


%% load & update meshes

% define lights
L.ambient=[.4 .4 .4];
L.diffuse=[.5 .5 .5];

if exist('meshAngleSettinglh','var')
    vw=MVPA_loadNsetMesh (vw, meshlh, L, 'all', meshAngleSettinglh);
else
    vw=MVPA_loadNsetMesh (vw, meshlh, L);
end
if exist('meshAngleSettingrh','var')
    vw=MVPA_loadNsetMesh (vw, meshrh, L, 'all', meshAngleSettingrh);
else
    vw=MVPA_loadNsetMesh (vw, meshrh, L);
end

vw = meshUpdateAll(vw); % will show meshes in the ventral view with ROIs

fig_counter=1;

for ii = 1:2
    vw = viewSet(vw, 'current mesh n', ii);
    figH(fig_counter)=figure('Color', 'w'); 
    imagesc(mrmGet(viewGet(vw, 'Mesh'), 'screenshot')/255); axis image; axis off; 
    fig_counter=fig_counter+1;
end