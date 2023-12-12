function [session, fs_session] = dynacat_setSessions(subj, sessionNum)
%
%[session, fs_session] = setSessions_dynacat(subjNum, sessionNum)
% Links subject and session information to subject code.
% Input subject code (ex. subj-01) and desired session number (ex. 1)
% Outputs freesurfer session code and session code
% ex. setSessions_dynacat('subj-01', 1)
% BR June 2023 (adapted from DF for toon)


switch subj
    case 'subj-01'
         if sessionNum == 1
            session = 'session1';
            fs_session = 'kis202308_v72'; %name of subject's freesurferRecon folder on share
        % elseif sessionNr == 2
        %     session = 'AOK07_191207_21927_time_04_1';
        %     fs_session = 'AOK07_scn191214_recon0920_v6'; 
        %     if ~isempty(testFolder)
        %         session = [session '_' testFolder];
        %     end
        else
             error('[%]: Cannot find sessionNr!',mfilename)
         end 
    
    case 'subj-02'
        if sessionNum == 1
            session = 'session1';
            fs_session = 'ax202306_v72';
        % elseif sessionNr == 2
        %     session = 'RJ09_190112_19741_time_03_1';
        %     fs_session = 'RJ09_scn181028_recon0920_v6'; 
        %     if ~isempty(testFolder)
        %         session = [session '_' testFolder];
        %     end
        else
             error('[%]: Cannot find sessionNr!',mfilename)
        end
    
    case 'subj-03'
        if sessionNum == 1
            session = 'session1';
            fs_session = 'ek202011_v60';
        % elseif sessionNr == 2
        %     session = 'RJ09_190112_19741_time_03_1';
        %     fs_session = 'RJ09_scn181028_recon0920_v6'; 
        %     if ~isempty(testFolder)
        %         session = [session '_' testFolder];
        %     end
        else
             error('[%]: Cannot find sessionNr!',mfilename)
        end
    
    case 'subj-04'
        if sessionNum == 1
            session = 'session1';
            fs_session = 'ie202309_v72';
        % elseif sessionNr == 2
        %     session = 'RJ09_190112_19741_time_03_1';
        %     fs_session = 'RJ09_scn181028_recon0920_v6'; 
        %     if ~isempty(testFolder)
        %         session = [session '_' testFolder];
        %     end
        else
             error('[%]: Cannot find sessionNr!',mfilename)
        end

    case 'subj-05'
        if sessionNum == 1
            session = 'session1';
            fs_session = 'jy202309_v72';
        % elseif sessionNr == 2
        %     session = 'RJ09_190112_19741_time_03_1';
        %     fs_session = 'RJ09_scn181028_recon0920_v6'; 
        %     if ~isempty(testFolder)
        %         session = [session '_' testFolder];
        %     end
        else
             error('[%]: Cannot find sessionNr!',mfilename)
        end

    case 'subj-06'
        if sessionNum == 1
            session = 'session1';
            fs_session = 'ag202309_v72';
        % elseif sessionNr == 2
        %     session = 'RJ09_190112_19741_time_03_1';
        %     fs_session = 'RJ09_scn181028_recon0920_v6'; 
        %     if ~isempty(testFolder)
        %         session = [session '_' testFolder];
        %     end
        else
             error('[%]: Cannot find sessionNr!',mfilename)
        end

    case 'test_subj06'
        if sessionNum == 1
            session = 'session1';
            fs_session = 'ag202309_v72';
        % elseif sessionNr == 2
        %     session = 'RJ09_190112_19741_time_03_1';
        %     fs_session = 'RJ09_scn181028_recon0920_v6'; 
        %     if ~isempty(testFolder)
        %         session = [session '_' testFolder];
        %     end
        else
             error('[%]: Cannot find sessionNr!',mfilename)
        end

    case 'test_subj05'
        if sessionNum == 1
            session = 'session1';
            fs_session = 'jy202309_v72';
        % elseif sessionNr == 2
        %     session = 'RJ09_190112_19741_time_03_1';
        %     fs_session = 'RJ09_scn181028_recon0920_v6'; 
        %     if ~isempty(testFolder)
        %         session = [session '_' testFolder];
        %     end
        else
             error('[%]: Cannot find sessionNr!',mfilename)
        end
    
    case 'subj-07'
        if sessionNum == 1
            session = 'session1';
            fs_session = 'jh202309_v72';
        % elseif sessionNr == 2
        %     session = 'RJ09_190112_19741_time_03_1';
        %     fs_session = 'RJ09_scn181028_recon0920_v6'; 
        %     if ~isempty(testFolder)
        %         session = [session '_' testFolder];
        %     end
        else
             error('[%]: Cannot find sessionNr!',mfilename)
        end


end
