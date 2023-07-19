% This script transforms all parameter maps in the datatype from inplane to
% gray view

function XformInplane2Vol()


    % init hidden inplane and gray view
    hI = initHiddenInplane('GLMs');
    hG = initHiddenGray('GLMs');

    % we would like to xform all of our maps
    ip2volAllParMaps(hI, hG, 'linear')
    
    % clear global
    clear global
    clearvars session idx subject sessionPath hI hG
    
    % init hidden inplane and gray view
    hI = initHiddenInplane('MotionComp_RefScan1');
    hG = initHiddenGray('MotionComp_RefScan1');

    % we would like to xform all of our tSeries
    hG=ip2volTSeries(hI,hG,0,'linear');
    
        
    % clear global
    clear global
    clearvars session idx subject sessionPath hI hG
    

end
