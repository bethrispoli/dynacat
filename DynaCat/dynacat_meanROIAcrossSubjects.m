function [tc subjectTcs] = meanROI_acrossSubjects_Localizer(sessions, whichROIs)
% mean roi time course across subjects for FaceMorphAdapt (4 runs)

ExpDir=fullfile('/biac2','kgs','projects','Longitudinal','FMRI','Localizer', 'data');
eval(['cd ' ExpDir])

whichROIs

   %for i=1:nsubj
   %  sessions{i} = ['Subj', num2str(i)];
   %end
 
   sessions{1} = 'JTE11_05112014'; 
  % sessions{2}='SDS07_05112014';
   sessions{2} = 'STM10_05112014';
   %sessions{1} = 'Subj6'
   %sessions{2} = 'Subj7' 
  
for i=1:length(whichROIs)
    
    roi=whichROIs{i};
    
    % change to first session
    % get event params
    % set them to the value i want to make sure this is correct
    subDir=fullfile('/biac2','kgs','projects','Longitudinal','FMRI','Localizer', 'data', sessions{1});
    eval(['cd ' subDir]);

    hi=initHiddenInplane(2,1);
    eventParams=er_getParams(hi);
  
    % set the eventParams
    eventParams.glmHRF=3; % SPM HRF
    eventParams.eventsPerBlock=4;
    % set params
    params.viewType='Inplane'
    params.dataType=3; % motion comp between data
    params.scan=1;
    params.studyDir=ExpDir;
    params.eventParams=eventParams;
    params.sessionPlots={'betas'};
  % params.sessionPlots={'zscore'};
    params.methodFlag=4;
    params.openUI=1;
    params.ampType='betas'
   
    % extract timecourses
    [tc subjectTcs] = tc_acrossSessions(sessions, roi, params,'scan',[1 2])
    
end
