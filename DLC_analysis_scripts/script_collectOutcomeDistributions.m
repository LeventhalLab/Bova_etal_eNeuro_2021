% script_collectOutcomeDistributions

% finds the number of reach score outcome types and calculates percent
% outcomes

validTrialOutcomes = {0,1,2,3,4,5,6,7,8,9,10,11};
validOutcomeNames = {'no pellet','first success','any success','drop in box','pellet knocked off',...
    'used tongue','trigger error','pellet remained','contralateral paw','laser error','tongue and paw','paw through slot'};

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

for i_rat = 1 : numRatFolders
    
    ratID = ratFolders(i_rat).name
    ratIDnum = str2double(ratID(2:end));
    
    ratInfo_idx = find(ratInfo_IDs == ratIDnum);
    if isempty(ratInfo_idx)
        error('no entry in ratInfo structure for rat %d\n',{1});
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
    ratSummaryName = [ratID '_outcomeDistribution.mat'];
    
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

    ratSummary = initializeRatSummaryStructOutcomeDistribution(ratID,validTrialOutcomes,validOutcomeNames,sessions_analyzed);
    
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
        
        [ratSummary.num_trials(iSession,:),~] = breakDownTrialScores(reachData,validTrialOutcomes);        
        ratSummary.outcomePercent(iSession,:) = ratSummary.num_trials(iSession,:) / sum(ratSummary.num_trials(iSession,:));
        
    end

    cd(ratRootFolder);
    save(fullfile(ratSummaryDir,ratSummaryName),'ratSummary','thisRatInfo');
    clear ratSummary
    clear sessions_analyzed;
    
end
        