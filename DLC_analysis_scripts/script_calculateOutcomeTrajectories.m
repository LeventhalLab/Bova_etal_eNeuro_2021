% script_calculateOutcomeTrajectories

% calculate the following kinematic parameters for each reach outcome:
% 1. aperture as function of z digit 2
% 2. orientation as function of z digit 2
% 3. digit flexion as function of z digit 2
% 4. average distance of paw trajectory from mean trajectory (reach)
% 5. average distance of paw trajectory from mean trajectory (grasp)
% 6. average distance of digit2 trajectory from mean trajectory (reach)
% 7. average distance of digit2 trajectory from mean trajectory (grasp)

validTrialOutcomes = {0:10,1,2,[3,4,7],0,11,6};
validOutcomeNames = {'all','1st success','any success','failed','no pellet','paw through slot','no reach'};

labeledBodypartsFolder = '/Volumes/DLC_data/DLC_output';
xlDir = labeledBodypartsFolder;
csvfname = fullfile(xlDir,'test.csv');
ratInfo = readRatInfoTable(csvfname);

ratSummaryDir = fullfile('/Volumes/DLC_data/rat kinematic summaries');
if ~exist(ratSummaryDir,'dir')
    mkdir(ratSummaryDir);
end

ratInfo_IDs = [ratInfo.ratID];

cd(labeledBodypartsFolder)
ratFolders = dir('R0*');
numRatFolders = length(ratFolders);

z_interp_digits = 20:-0.1:-15;  % for interpolating z-coordinates for aperture and orientation calculations

for i_rat = 1:numRatFolders
    
    ratID = ratFolders(i_rat).name
    ratIDnum = str2double(ratID(2:end));
    
    
    ratInfo_idx = find(ratInfo_IDs == ratIDnum);
    if isempty(ratInfo_idx)
        error('no entry in ratInfo structure for rat %d\n',C{1});
    end
    thisRatInfo = ratInfo(ratInfo_idx,:);
    pawPref = thisRatInfo.pawPref;
    if iscategorical(pawPref)
        pawPref = char(pawPref);
    end
    if iscell(pawPref)
        pawPref = pawPref{1};
    end
    
    ratRootFolder = fullfile(labeledBodypartsFolder,ratID);
    
    cd(ratRootFolder);
    ratSummaryName = [ratID '_outcomeTrajectory.mat'];
    
    sessionDirectories = listFolders([ratID '_2*']);
    
    sessionCSV = [ratID '_sessions.csv'];
    sessionTable = readSessionInfoTable(sessionCSV,ratIDnum);
    
    sessions_analyzed = getTrainingSessions(sessionTable,ratIDnum);
    numSessions = size(sessions_analyzed,1);
    
    switch ratID
        case 'R0159'
            startSession = 5;
            endSession = numSessions;
        otherwise
            startSession = 1;
            endSession = numSessions;
    end
    
    % create summary structure
    ratSummary = initializeRatSummaryStructOutcomeTraj(ratID,validTrialOutcomes,sessions_analyzed,z_interp_digits);
    
    % load the first file to set up array dimensions
    sessionDate = sessions_analyzed.date(startSession);
    sessionDateString = datestr(sessionDate,'yyyymmdd');

    cd(ratRootFolder);
    testDirName = [ratID '_' sessionDateString '*'];
    validSessionDir = dir(testDirName);
    if isempty(validSessionDir)
        continue;
    end
    curSessionDir = validSessionDir.name;
    fullSessionDir = fullfile(ratRootFolder,curSessionDir);

    cd(fullSessionDir);
    % not sure if the following is necessary, but it's been working
    C = textscan(curSessionDir,[ratID '_%8c']);
    sessionDateString = C{1}; % this will be in format yyyymmdd
                        % note date formats from the scores spreadsheet
                        % are in m/d/yy
    sessionDate = datetime(sessionDateString,'inputformat','yyyyMMdd');

    curSessionTableRow = (sessions_analyzed.date == sessionDate);
    cur_sessionInfo = sessions_analyzed(curSessionTableRow,:);

    reachDataName = [ratID '_' sessionDateString '_processed_reaches.mat'];
    reachDataName = fullfile(fullSessionDir,reachDataName);

    if ~exist(reachDataName,'file')
        fprintf('no reach data summary found for %s\n',curSessionDir);
        continue;
    end
    load(reachDataName);
    
    for iSession = startSession : endSession
        
        sessionDate = sessions_analyzed.date(iSession);
        sessionDateString = datestr(sessionDate,'yyyymmdd');
        
        cd(ratRootFolder);
        testDirName = [ratID '_' sessionDateString '*'];
        validSessionDir = dir(testDirName);
        if isempty(validSessionDir)
            continue;
        end
        curSessionDir = validSessionDir.name;
        fullSessionDir = fullfile(ratRootFolder,curSessionDir);
        
        if ~isfolder(fullSessionDir)
            continue;
        end
        
        cd(fullSessionDir);
        % not sure if the following is necessary, but it's been working
        C = textscan(curSessionDir,[ratID '_%8c']);
        sessionDateString = C{1}; % this will be in format yyyymmdd
                            % note date formats from the scores spreadsheet
                            % are in m/d/yy
        sessionDate = datetime(sessionDateString,'inputformat','yyyyMMdd');
        
        curSessionTableRow = (sessions_analyzed.date == sessionDate);
        cur_sessionInfo = sessions_analyzed(curSessionTableRow,:);
        
        reachDataName = [ratID '_' sessionDateString '_processed_reaches.mat'];
        reachDataName = fullfile(fullSessionDir,reachDataName);
        
        if ~exist(reachDataName,'file')
            sprintf('no reach data summary found for %s\n',curSessionDir);
            continue;
        end
        
        load(reachDataName);
       
        numTrials = length(reachData);
        
        ratSummary.aperture_traj(iSession,:,:) = breakDownFullApertureByOutcome2(reachData,z_interp_digits,validTrialOutcomes);
        ratSummary.orientation_traj(iSession,:,:) = breakDownFullOrientationByOutcome2(reachData,z_interp_digits,validTrialOutcomes);
        ratSummary.flex_traj(iSession,:,:) = breakDownFullFlexionByOutcome2(reachData,z_interp_digits,validTrialOutcomes);
        [ratSummary.mean_dist_from_pd_traj_reach(iSession,:),ratSummary.mean_dist_from_pd_traj_grasp(iSession,:),...
            ratSummary.mean_dist_from_dig_traj_reach(iSession,:), ratSummary.mean_dist_from_dig_traj_grasp(iSession,:)] = ...
                breakDownDistFromTrajByOutcome(reachData,validTrialOutcomes);
        
    end
    
    cd(ratRootFolder);
    save(fullfile(ratSummaryDir,ratSummaryName),'ratSummary','thisRatInfo');
    clear ratSummary
    clear sessions_analyzed;
    
end
        
        