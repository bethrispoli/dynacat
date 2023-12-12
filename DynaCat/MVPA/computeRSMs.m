function [RSM, MVP]=computeRSMs(DataDir,sessions, ROIs,listRuns,ampType)

%% [RSM ,MVP]=computeRSMs(DataDir,sessions, ROIs, listRuns, ampType)
% This function computes the  MVPS and RSMs for individual subjects and plots these.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUTS: 
% 
% (1) DataDir
%  Full path to the data directory on your computer
%
% (2) sessions
% Please specify the sessions, e.g.,
% sessions =  {'OS_4_1'}
%
% (3) ROIs
% ROIs={'rh_vtc_lateral', 'lh_vtc_lateral', 'rh_vtc_medial', 'lh_vtc_medial'};
%
% (4) listRuns: scans default:  [ 1 2 3]
%
% (5) ampType: 'betas','subtractedBetas','zscore'
%
% OUTPUTs:
% RSM: Symmeterized RSM containing the average pairwise correlation between
% runs
% mvs: cell array of multivoxel patterns for each run and ROI
% 
% written by MN 2018; edit by KGS 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% set defaults
if notDefined('DataDir')
    DataDir='/share/kalanit/biac2/kgs/projects/DynamicCategories/data/DynaCat/';
end

if notDefined('sessions')
    sessions =  {'subj-06'};
end
if notDefined ('listRuns')
    listRuns=  [1 2 3 4 5 6 7 8];
end
if notDefined('ROIs')
    ROIs={'lh_anat_roi_STS', 'rh_anat_roi_STS', 'lh_anat_roi_LOTC', 'rh_anat_roi_LOTC', 'lh_anat_roi_VTC', 'rh_anat_roi_VTC'};
end

if notDefined('ampType')
    ampType='zscore';
end

if notDefined('plotFlag')
 plotFlag=1; % flag for plotting MVPs
end

% Set parameters.
dataType=3;
numconds = 24;
eventsPerBlock=4; % length of trial is 4s and the TR is 1s
nrRuns = 8;

%%


for r=1:length(ROIs) % loop over ROIs
ROI
    
    for s=1:length(sessions) % loop over sessions
        session = sessions{s};
        % we have a nested data structure, so we need to identify the
        % subject ID
        sessionPath =  fullfile(DataDir, session, 'session1');
        cd(sessionPath)
        
        % init session
        hg=initHiddenGray(dataType, 1, ROIname);
        currentview = 'gray';

        % Initialize multivoxel pattern for each run
        mv1=mv_init(hg,ROIname,listRuns(s,1),dataType);
        mv2=mv_init(hg,ROIname,listRuns(s,2),dataType);
        mv3=mv_init(hg,ROIname,listRuns(s,3),dataType);
        mv4=mv_init(hg,ROIname,listRuns(s,4),dataType);
        mv5=mv_init(hg,ROIname,listRuns(s,5),dataType);
        mv6=mv_init(hg,ROIname,listRuns(s,6),dataType);
        mv7=mv_init(hg,ROIname,listRuns(s,7),dataType);
        mv8=mv_init(hg,ROIname,listRuns(s,8),dataType);
        
        mvs = {mv1, mv2, mv3, mv4, mv5, mv6, mv7, mv8};
        % Set parameters in each mv.
        
        for m=1:nrRuns %% loop over runs
            params = mvs{m}.params;
            params.eventAnalysis = 1;
            params.detrend = 1; % high-pass filter (remove the low frequency trend)
            params.detrendFrames = 20;
            params.inhomoCorrection = 1; % divide by mean (transforms from raw scanner units to % signal)
            params.temporalNormalization = 0; % no matching 1st temporal frame
            params.ampType = 'betas';
            params.glmHRF = 3; % SPM hrf
            params.eventsPerBlock = eventsPerBlock;
            params.lowPassFilter = 0; % no temporal low pass filter of the data
            
            if m==1
                mv1.params = params;
            elseif m==2
                mv2.params = params;
            elseif m==3
                mv3.params = params;
            elseif m==4
                mv4.params = params;
            elseif m==5
                mv5.params = params;
            elseif m==6
                mv6.params = params;
            elseif m==7
                mv7.params = params;
            elseif m==8
                mv8.params = params;
            end
        end
        
        % Apply GLM to each multivoxel pattern
        mv1 = mv_applyGlm(mv1);
        mv2 = mv_applyGlm(mv2);
        mv3 = mv_applyGlm(mv3);
        mv4 = mv_applyGlm(mv4);
        mv5 = mv_applyGlm(mv5);
        mv6 = mv_applyGlm(mv6);
        mv7 = mv_applyGlm(mv7);
        mv8 = mv_applyGlm(mv8);
    
        
        % get betas for each run and voxel
        amps1=mv_amps(mv1);
        amps2=mv_amps(mv2);
        amps3=mv_amps(mv3);
        amps4=mv_amps(mv4);
        amps5=mv_amps(mv5);
        amps6=mv_amps(mv6);
        amps7=mv_amps(mv7);
        amps8=mv_amps(mv8);


        % removes task condition from amps 
        amps1=amps1(:, 1:numconds);
        amps2=amps2(:, 1:numconds);
        amps3=amps3(:, 1:numconds);
        amps4=amps4(:, 1:numconds);
        amps5=amps5(:, 1:numconds);
        amps6=amps6(:, 1:numconds);
        amps7=amps7(:, 1:numconds);
        amps8=amps8(:, 1:numconds);


        % values to plot
        z_values1=mv_amps(mv1);
        z_values2=mv_amps(mv2);
        z_values3=mv_amps(mv3);
        z_values4=mv_amps(mv4);
        z_values5=mv_amps(mv5);
        z_values6=mv_amps(mv6);
        z_values7=mv_amps(mv7);
        z_values8=mv_amps(mv8);
              
        
        if strcmp(ampType, 'subtractedBetas')|| strcmp(ampType, 'zscore')
            % subtract mean beta from each voxel
            mean1=mean(amps1,2);
            meanmat1=mean1*ones(1,numconds);
            subbetas1=amps1-meanmat1;
            
            mean2=mean(amps2,2);
            meanmat2=mean2*ones(1,numconds);
            subbetas2=amps2-meanmat2;
            
            mean3=mean(amps3,2);
            meanmat3=mean3*ones(1,numconds);
            subbetas3=amps3-meanmat3;

            mean4=mean(amps4,2);
            meanmat4=mean4*ones(1,numconds);
            subbetas4=amps4-meanmat4;

            mean5=mean(amps5,2);
            meanmat5=mean5*ones(1,numconds);
            subbetas5=amps5-meanmat5;

            mean6=mean(amps6,2);
            meanmat6=mean6*ones(1,numconds);
            subbetas6=amps6-meanmat6;

            mean7=mean(amps7,2);
            meanmat7=mean7*ones(1,numconds);
            subbetas7=amps7-meanmat7;

            mean8=mean(amps8,2);
            meanmat8=mean8*ones(1,numconds);
            subbetas8=amps8-meanmat8;


            % the values used for the correlations
            z_values1=subbetas1;
            z_values2=subbetas2;
            z_values3=subbetas3;
            z_values4=subbetas4;
            z_values5=subbetas5;
            z_values6=subbetas6;
            z_values7=subbetas7;
            z_values8=subbetas8;
            
        end
        
        if strcmp(ampType, 'zscore')
            % normalize by the residual variance of the GLM in each voxel
            % effectively after this step you have z-scoed your pattern
            residualV1 = mv1.glm.residual; % make this into functions
            dof1 = mv1.glm.dof;
            residualvar1 = sum(residualV1.^2)/dof1;
            resd1 = sqrt(residualvar1);
            resd1 = resd1';
            resd_mat1 = repmat(resd1, [1 numconds]);
            z_values1 = subbetas1./resd_mat1;
            
            % Same for Run 2
            residualV2 = mv2.glm.residual;
            dof2 = mv2.glm.dof;
            residualvar2 = sum(residualV2.^2)/dof2;
            resd2 = sqrt(residualvar2);
            resd2 = resd2';
            resd_mat2 = repmat(resd2, [1 numconds]);
            z_values2 = subbetas2./resd_mat2;
            
            % Same for Run 3
            residualV3 = mv3.glm.residual;
            dof3 = mv3.glm.dof;
            residualvar3 = sum(residualV3.^2)/dof3;
            resd3 = sqrt(residualvar3);
            resd3 = resd3';
            resd_mat3 = repmat(resd3, [1 numconds]);
            z_values3 = subbetas3./resd_mat3;

            residualV4 = mv4.glm.residual;
            dof4 = mv4.glm.dof;
            residualvar4 = sum(residualV4.^2)/dof4;
            resd4 = sqrt(residualvar4);
            resd4 = resd4';
            resd_mat4 = repmat(resd4, [1 numconds]);
            z_values4 = subbetas4./resd_mat4;

            residualV5 = mv5.glm.residual;
            dof5 = mv5.glm.dof;
            residualvar5 = sum(residualV5.^2)/dof5;
            resd5 = sqrt(residualvar5);
            resd5 = resd5';
            resd_mat5 = repmat(resd5, [1 numconds]);
            z_values5 = subbetas5./resd_mat5;

            residualV6 = mv6.glm.residual;
            dof6 = mv6.glm.dof;
            residualvar6 = sum(residualV6.^2)/dof6;
            resd6 = sqrt(residualvar6);
            resd6 = resd6';
            resd_mat6 = repmat(resd6, [1 numconds]);
            z_values6 = subbetas6./resd_mat6;

            residualV7 = mv7.glm.residual;
            dof7 = mv7.glm.dof;
            residualvar7 = sum(residualV7.^2)/dof7;
            resd7 = sqrt(residualvar7);
            resd7 = resd7';
            resd_mat7 = repmat(resd7, [1 numconds]);
            z_values7 = subbetas7./resd_mat7;

            residualV8 = mv8.glm.residual;
            dof8 = mv8.glm.dof;
            residualvar8 = sum(residualV8.^2)/dof8;
            resd8 = sqrt(residualvar8);
            resd8 = resd8';
            resd_mat8 = repmat(resd8, [1 numconds]);
            z_values8 = subbetas8./resd_mat8;
        end
        
        % make into a funciton
        if plotFlag
            figure('color', [ 1 1 1], 'name', ['MVP' ROIs{r} '_' sessions{s} '_' ampType], 'Units', 'normalized', 'Position', [0.1, 0.1, 0.8, 0.4]);
            
            allvals=[z_values1; z_values2; z_values3; z_values4; z_values5; z_values6; z_values7; z_values8];
            maxvalue=max(max(allvals));
            minvalue=min(min(allvals));
            
            subplot (1,8,1); imagesc(z_values1,[minvalue maxvalue]); colorbar;
            %set(gca,'Xtick', [1:1:numconds], 'XtickLabel',new_labels,'FontSize',10);
            ylabel('voxel number'); xlabel('condition');
           
            subplot (1,8,2); imagesc(z_values2, [minvalue maxvalue]); colorbar;
            %set(gca,'Xtick', [1:1:numconds], 'XtickLabel',new_labels,'FontSize',10);
            myTitle = sprintf('%s %s %s', session, ROIs{r}, ampType);
            title(myTitle, 'Interpreter','none', 'FontSize',10);
      
            subplot (1,8,3); imagesc(z_values3, [minvalue maxvalue]); colorbar;
            
            %set(gca,'Xtick', [1:1:numconds], 'XtickLabel',new_labels,'FontSize',10);

            subplot (1,8,4); imagesc(z_values4, [minvalue maxvalue]); colorbar;
            subplot (1,8,5); imagesc(z_values5, [minvalue maxvalue]); colorbar;
            subplot (1,8,6); imagesc(z_values6, [minvalue maxvalue]); colorbar;
            subplot (1,8,7); imagesc(z_values7, [minvalue maxvalue]); colorbar;
            
            subplot (1,8,8); imagesc(z_values3, [minvalue maxvalue]); hcb=colorbar; title(hcb, ampType);
        end
        
        % Compute crosscorrelation matrices between each pair of runs
        allvalues = [z_values1 z_values2 z_values3 z_values4 z_values5 z_values6 z_values7 z_values8];

        rsm = corrcoef(allvalues);

        
        %% visualize & save individual RSMs as images
        figure('color', [ 1 1 1], 'name', [session ' '  ROIname],'units','norm', 'position', [ 0.1 .1 .6 .6]);
        imagesc(rsm, [-.7 .7]); axis('image');
        cmap=mrvColorMaps('coolhot'); colormap(cmap);
        hcb=colorbar; title(hcb, 'correlation');
        set(gca,'Fontsize',12);
        myTitle = sprintf('RSM %s %s %s', session, ROIs{r}, ampType);
        
        title(myTitle, 'Interpreter','none', 'FontSize',14);
        set(gca,'Xtick', [1:1:10], 'XtickLabel',new_labels,'FontSize',12);
        set(gca,'Ytick', [1:1:10], 'YtickLabel',new_labels, 'FontSize',12);
        % set x and y tick with labels for conditions
        
        OutDir= fullfile(DataDir ,session ,'results');
        if ~exist(OutDir,'dir')
            command=['!mkdir ' OutDir];
            eval(command)
        end
        %         RSM_filename_png=sprintf('RSM_%s_%s_%s.png',session,ROIname, currentview');
        %         outfile=fullfile(OutDir , RSM_filename_png);
        %         saveas(gcf, outfile, 'png')
        %

        % saves data 
        % figure out how to fix that (save data structure with rsm data for
        % averaging across rois, save rsm and multivoxel patterns
        % RSM.(ROIs{r}).(subject).(sessions{s}).rsm = rsm;
        % MVP.(ROIs{r}).(subject).(sessions{s}).mv1=mv1;
        % MVP.(ROIs{r}).(subject).(sessions{s}).mv2=mv2;
        % MVP.(ROIs{r}).(subject).(sessions{s}).mv3=mv3;
        % MVP.(ROIs{r}).(subject).(sessions{s}).mv4=mv4;
        % MVP.(ROIs{r}).(subject).(sessions{s}).mv5=mv5;
        % MVP.(ROIs{r}).(subject).(sessions{s}).mv6=mv6;
        % MVP.(ROIs{r}).(subject).(sessions{s}).mv7=mv7;
        % MVP.(ROIs{r}).(subject).(sessions{s}).mv8=mv8;
        
        clear global
        clearvars -except DataDir OutDir dataType ROIs numconds eventsPerBlock nrRuns s r session sessions listRuns  ROIname RSM MVP ampType plotFlag
    end
    
    % % store data (across subjects)
    % dataIndFilePath=fullfile(OutDir,['RSM_' ampType]);
    % save(dataIndFilePath, 'RSM')
    % dataIndFilePath=fullfile(OutDir,['MVP_' ampType]);
    % save(dataIndFilePath, 'MVP')
end
