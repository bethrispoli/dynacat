%% Do this when there are no parfiles for the kidLoc data
% First, get file names
projectFolder = '/oak/stanford/groups/kalanit/biac2/kgs/projects/spatiotemporal/experiments/fLoc/';

sessionFolder = fullfile(pth,'data','subj15','session1');
runBase = 'dl_20-Jul-2022_kidLoc_2Hz_E1R1S';
runNrs = 1:3;

scriptBase = 's15_kidLoc_2Hz_run';

if ~exist(fullfile(sessionFolder,'stimuli'),'dir')
    mkdir(fullfile(sessionFolder,'stimuli'));
    mkdir(fullfile(sessionFolder,'stimuli','parfiles'));
end

for runNr = runNrs
    % load the mat file for each run
    load(fullfile(sessionFolder,'behavior', sprintf('%s%d.mat',runBase,runNr)))
    
    % get the script needed for the par file and copy into a new text file.
    theSubject.scriptUsed
    fLocFileName = sprintf('%s%d.txt',scriptBase,runNr);
    
    fid = fopen(fullfile(sessionFolder,'stimuli',fLocFileName), 'wt');
    fprintf(fid, ...
        theSubject.scriptUsed
    fclose(fid);

    % Then load script and write parfile
    writeParfile_kidLoc_2Hz(fullfile(DataFolder,fLocFileName))
    copyfile(fullfile(sessionFolder,'stimuli',sprintf('%s%d.par',scriptBase,runNr)), ...
        fullfile(sessionFolder,'stimuli','parfiles',sprintf('%s%d.par',scriptBase,runNr)))
end
