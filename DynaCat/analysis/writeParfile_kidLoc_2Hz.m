function writeParfile_FastLoc_2Hz(script)

% DY 02/06/2007
% Modified from READSCRIPT
% DY 02/07/2007
% Amended to have only one line per block (for new mrVista code)
%
% Reads information from a script file and writes a parfile. The first
% column contains the onset in seconds, the second column contains the
% condition number, and the third column, the label for the condition. Each
% row is a TR. 
%
% To do this, it takes in the TR for the experiment, the number of trials
% per block, the total duration of a block in seconds, the script which the
% parfile is based on, and a base directory (if this isn't entered, it
% assumes the current directory (this should have directories called
% 'scripts' and 'parfiles' in it. If arguments are not passed in,
% assumptions (based on the eye-tracking block design) are assumed. 

%----------
% DEFAULTS
%----------
TR=2;
trialsPerBlock=8;
secondsPerTrial=.5;
blockDur=trialsPerBlock*secondsPerTrial;
baseDir=pwd;
%baseDir=baseDir(1:end-4);
extraFrames=0;

%------
% PATHS
%------
scriptDir = fullfile(baseDir);
outDir = fullfile(baseDir);
cd(scriptDir);

%------------------------
% Initialize PAR and TEMP
%------------------------
par.onset=-1;
par.code=-1;
par.cond=char('');
par.cond=[];
par.numTR=-1;

temp.blockNum=-1;
temp.onset=-1;
temp.cat=-1;
temp.task=-1;
temp.image=char('');

% Get category names
fid=fopen(script);
ignoreheader=fscanf(fid,'%s',1);
cat0='Fixation';
cat1=fscanf(fid,'%s',1); 
cat1=cat1(1:end-1); %remove punctuation
cat2=fscanf(fid,'%s',1); 
cat2=cat2(1:end-1); %remove punctuation
cat3=fscanf(fid,'%s',1); 
cat3=cat3(1:end-1); %remove punctuation
cat4=fscanf(fid,'%s',1); 
cat4=cat4(1:end-1); %remove punctuation
cat5=fscanf(fid,'%s',1); 
cat5=cat5(1:end-1); %remove punctuation
cat6=fscanf(fid,'%s',1); 
cat6=cat6(1:end-1); %remove punctuation
cat7=fscanf(fid,'%s',1); 
cat7=cat7(1:end-1); %remove punctuation
cat8=fscanf(fid,'%s',1); 
cat8=cat8(1:end-1); %remove punctuation
cat9=fscanf(fid,'%s',1); 
cat9=cat9(1:end-1); %remove punctuation
ignoreheader=fscanf(fid,'%s',1);
cat10=fscanf(fid,'%s',1); 
cat10=cat10(1:end-1); %remove punctuation

% Get number of frames
ignoreheader=fscanf(fid,'%s',11);
par.numTR=fscanf(fid,'%i',1);
% Calculate the number of trials in script based on trialsPerBlock and
% blockDur
par.numTR = par.numTR+extraFrames;
duration=par.numTR*TR;
numBlocks=duration/blockDur;
numTrials=numBlocks*trialsPerBlock;

% Get fixation flag
ignoreheader=fgetl(fid);
ignoreheader=fscanf(fid,'%s',2);
ignoreheader=fscanf(fid,'%i',1);
ignoreheader=fgetl(fid);

% Skip column names
ignoreheader=fscanf(fid,'%s',13);

% Read in trials
cnt=1;
blocknum=fscanf(fid,'%s',1); % should start at 1!!!
while ~isempty(blocknum) & strncmp('*',blocknum,1)==0
    % Keep going while the blocknum is not a '*' character
    temp.blockNum(cnt)=str2num(blocknum);
    temp.onset(cnt)=fscanf(fid,'%f',1);
    temp.cat(cnt)=fscanf(fid,'%d',1);
    temp.task(cnt)=fscanf(fid,'%i',1);
    temp.image{cnt}=fscanf(fid,'%s',1);
    skipLine = fgetl(fid);
    cnt=cnt+1;
    blocknum=fscanf(fid,'%s',1);
end

%-------------------------------------------
% Build a matrix with category codes in them
%-------------------------------------------

% First take out only one category code per block
counter=1;
for j=1:trialsPerBlock:numTrials % increment in number of trials per block
    list(counter)=temp.cat(j);
    counter=counter+1;
end

% Now repeat them the correct number of times so that they fill the right
% number of TR rows
numReps = blockDur/TR;
condition=[];
for jj=1:length(list)
    matrix = repmat(list(jj),1,numReps);
    condition = [condition matrix];
end

%------------------------------------------------------
% Fill onset, condition code, label, and color columns
%------------------------------------------------------

% Fill in the struct fields corresponding to the four columns of the
% parfile (onset, condition code, condition label, and color)
onsetNum=0;
c=1;
for i=1:numBlocks
    par.onset(i)=onsetNum*(trialsPerBlock*secondsPerTrial);
    onsetNum=onsetNum+1;
    switch condition(c)
        case 0 
            par.cond{i}=cat0;
            par.color{i}=[1 1 1];
        case 1
            par.cond{i}=cat1;
            par.color{i}=[1 0 0];
        case 2
            par.cond{i}=cat2;
            par.color{i}=[.8 0 0];
        case 3
            par.cond{i}=cat3;
            par.color{i}=[0 0 1];
        case 4
            par.cond{i}=cat4;
            par.color{i}=[0 0 .8];
        case 5
            par.cond{i}=cat5;
            par.color{i}=[1 1 0];
        case 6
            par.cond{i}=cat6;
            par.color{i}=[.8 .8 0];
        case 7
            par.cond{i}=cat7;
            par.color{i}=[0 1 0];
        case 8
            par.cond{i}=cat8;
            par.color{i}=[0 .8 0];
        case 9
            par.cond{i}=cat9;
            par.color{i}=[0 0 0];
        case 10
            par.cond{i}=cat10;
            par.color{i}=[.2 .2 .2];
    end
    par.code(i)=condition(c);
    c=c+(trialsPerBlock*secondsPerTrial/TR);
end

fclose(fid);

%-----------------
% WRITE TO PARFILE
%-----------------
cd(outDir);
outFile = [script(1:(end-4)) '.par'];
fidout = fopen(outFile,'w'); 
for ii=1:numBlocks
    fprintf(fidout,'%d \t %d \t', par.onset(ii), par.code(ii));
    fprintf(fidout,'%s \t', par.cond{ii});
    fprintf(fidout,'%i %i %i \n', par.color{ii});
end

fclose(fidout);
fclose('all');
fprintf(1, 'Wrote parfile %s successfully.', fullfile(outDir,outFile));
return