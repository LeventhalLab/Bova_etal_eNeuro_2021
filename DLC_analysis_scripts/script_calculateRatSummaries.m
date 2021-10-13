% script_calculateRatSummaries

% calculate the following kinematic parameters:
    % number of trials
    % percent outcome
    % number of reaches per trial
    % max velocity, by reach type
    % average reach duration, by reach type
    % first paw part to contact pellet, by reach type
    % average endpoints for reach and grasp components
    % average trajectory for a session, by reach time
    % deviation from that trajectory for a session
    % distance between trajectories
    % closest distance paw to pellet
    % minimum z, by type
    % number of reaches, by type
    % aperture of reach orientation at reach and grasp end
    % orientation of reach orientation at reach and grasp end
    % digit flexion of reach orientation at reach and grasp end
    % orientation and digit flexion MRL of reach orientation at reach end

trialOutcomeColors = {'k','g','b','r','y','c','m'};
validTrialOutcomes = {0:10,1,2,[3,4,7],0,11,6};
validOutcomeNames = {'all','1st success','any success','failed','no pellet','paw through slot','no reach'};

labeledBodypartsFolder = '/Volumes/DLC_data/DLC_output';
xlDir = labeledBodypartsFolder;
csvfname = fullfile(xlDir,'test.csv');
ratInfo = readRatInfoTable(csvfname);

ratSummaryDir = fullfile('/Volumes/DLC_data','rat kinematic summaries');
if ~exist(ratSummaryDir,'dir')
    mkdir(ratSummaryDir);
end

ratInfo_IDs = [ratInfo.ratID];

cd(labeledBodypartsFolder)
ratFolders = dir('R0*');
numRatFolders = length(ratFolders);

% temp_reachData = initializeReachDataStruct();

z_interp_digits = 20:-0.1:-15;  % for interpolating z-coordinates for aperture and orientation calculations

for i_rat = 1: numRatFolders
    
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
    ratSummaryName = [ratID '_kinematicsSummary.mat'];
    
    sessionDirectories = listFolders([ratID '_2*']);
    
    sessionCSV = [ratID '_sessions.csv'];
    sessionTable = readSessionInfoTable(sessionCSV,ratIDnum);

    sessions_analyzed = getTrainingSessions(sessionTable,ratIDnum);
    numSessions = size(sessions_analyzed,1);
    
    switch ratID
        case 'R0159'
            startSession = 2;
            endSession = numSessions;
        case 'R0160'
            startSession = 1;
            endSession = 10;
        otherwise
            startSession = 1;
            endSession = numSessions;
    end
    
    ratSummary = initializeRatSummaryStructLearning(ratID,validTrialOutcomes,validOutcomeNames,sessions_analyzed,z_interp_digits);
    
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
        
    num_trajectory_points_reach = size(sessionSummary.mean_pd_trajectory_reach,1);
    ratSummary.mean_pd_trajectory_reach = NaN(numSessions,num_trajectory_points_reach,3);
    ratSummary.mean_dist_from_pd_trajectory_reach = NaN(numSessions,num_trajectory_points_reach);
    ratSummary.mean_dig_trajectories_reach = NaN(numSessions,num_trajectory_points_reach,3,4);
    ratSummary.mean_dist_from_dig_trajectories_reach = NaN(numSessions,num_trajectory_points_reach,4);
    ratSummary.mean_dig_trajectories_reach_fromPaw = NaN(numSessions,num_trajectory_points_reach,3,4);
    ratSummary.mean_dist_from_dig_trajectories_reach_fromPaw = NaN(numSessions,num_trajectory_points_reach,4);
    
    num_trajectory_points_grasp = size(sessionSummary.mean_pd_trajectory_grasp,1);
    ratSummary.mean_pd_trajectory_grasp = NaN(numSessions,num_trajectory_points_grasp,3);
    ratSummary.mean_dist_from_pd_trajectory_grasp = NaN(numSessions,num_trajectory_points_grasp);
    ratSummary.mean_dig_trajectories_grasp = NaN(numSessions,num_trajectory_points_grasp,3,4);
    ratSummary.mean_dist_from_dig_trajectories_grasp = NaN(numSessions,num_trajectory_points_grasp,4);
    ratSummary.mean_dig_trajectories_grasp_fromPaw = NaN(numSessions,num_trajectory_points_grasp,3,4);
    ratSummary.mean_dist_from_dig_trajectories_grasp_fromPaw = NaN(numSessions,num_trajectory_points_grasp,4);
    
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
        ratSummary.outcomePercent(iSession,:) = ratSummary.num_trials(iSession,:) / ratSummary.num_trials(iSession,1);
        
        [ratSummary.mean_num_reaches(iSession,:), ratSummary.std_num_reaches(iSession,:)] = ...
            breakDownReachesByOutcome(reachData,validTrialOutcomes);
        
        [ratSummary.mean_pd_endPt_reach(iSession,:,:),ratSummary.mean_pd_endPt_grasp(iSession,:,:),...
            ratSummary.cov_pd_endPts_reach(iSession,:,:,:),ratSummary.cov_pd_endPts_grasp(iSession,:,:,:),...
            ratSummary.mean_dig_endPts_reach(iSession,:,:,:),ratSummary.mean_dig_endPts_grasp(iSession,:,:,:),...
            ratSummary.cov_dig_endPts_reach(iSession,:,:,:,:),ratSummary.cov_dig_endPts_grasp(iSession,:,:,:,:),...
            ratSummary.mean_dig_endPts_reach_fromPaw(iSession,:,:,:),ratSummary.mean_dig_endPts_grasp_fromPaw(iSession,:,:,:),...
            ratSummary.cov_dig_endPts_reach_fromPaw(iSession,:,:,:,:),ratSummary.cov_dig_endPts_grasp_fromPaw(iSession,:,:,:,:)] = ...
                breakDownReachEndPointsByOutcome(reachData,sessionSummary,validTrialOutcomes);

        [ratSummary.mean_pd_v(iSession,:), ratSummary.std_pd_v(iSession,:)] = ...
            breakDownVelocityByOutcome(reachData,validTrialOutcomes);
        
        [ratSummary.mean_reach_dur(iSession,:)] = breakDownReachDurationByOutcome(reachData,validTrialOutcomes);
                
        [ratSummary.mean_end_aperture(iSession,:), ratSummary.std_end_aperture(iSession,:),...
            ratSummary.mean_end_aperture_grasp(iSession,:), ratSummary.std_end_aperture_grasp(iSession,:)] = ...
            breakDownApertureByOutcome(reachData,validTrialOutcomes);
        
        [ratSummary.mean_end_orientations(iSession,:),ratSummary.end_MRL(iSession,:),...
            ratSummary.mean_end_orientations_grasp(iSession,:),ratSummary.end_MRL_grasp(iSession,:)] =...
            breakDownOrientationByOutcome(reachData,validTrialOutcomes,pawPref);
        
        [ratSummary.mean_end_flex(iSession,:), ratSummary.MRL_end_flex(iSession,:),...
            ratSummary.mean_end_flex_grasp(iSession,:), ratSummary.MRL_end_flex_grasp(iSession,:)] = ...
            breakDownFlexionByOutcome(reachData,validTrialOutcomes);
        
        [temp_aperture_traj,ratSummary.mean_aperture_traj(iSession,:),ratSummary.std_aperture_traj(iSession,:),ratSummary.sem_aperture_traj(iSession,:)] = ...
            breakDownFullApertureByOutcome(reachData,z_interp_digits);
%         [temp_aperture_traj_grasp,ratSummary.mean_aperture_traj_grasp(iSession,:),ratSummary.std_aperture_traj_grasp(iSession,:),ratSummary.sem_aperture_traj_grasp(iSession,:)] = ...
%             breakDownFullApertureByOutcomeGrasp(reachData,z_interp_digits);
        [temp_orientation_traj,ratSummary.mean_orientation_traj(iSession,:),ratSummary.MRL_traj(iSession,:)] = ...
            breakDownFullOrientationByOutcome(reachData,z_interp_digits);
%         [temp_orientation_traj_grasp,ratSummary.mean_orientation_traj_grasp(iSession,:),ratSummary.MRL_traj_grasp(iSession,:)] = ...
%             breakDownFullOrientationByOutcomeGrasp(reachData,z_interp_digits);
        [temp_flex_traj,ratSummary.mean_flexion_traj(iSession,:),ratSummary.MRL_flexion_traj(iSession,:)] = ...
            breakDownFullFlexByOutcome(reachData,z_interp_digits);
        
        ratSummary.mean_pd_trajectory_reach(iSession,:,:) = sessionSummary.mean_pd_trajectory_reach;
        ratSummary.mean_dist_from_pd_trajectory_reach(iSession,:) = sessionSummary.pd_mean_euc_dist_from_trajectory_reach';
        ratSummary.mean_dig_trajectories_reach(iSession,:,:,:) = sessionSummary.mean_dig_trajectories_reach;
        ratSummary.mean_dist_from_dig_trajectories_reach(iSession,:,:) = sessionSummary.dig_mean_euc_dist_from_trajectory_reach;
        ratSummary.mean_dig_trajectories_reach_fromPaw(iSession,:,:,:) = sessionSummary.mean_dig_trajectories_reach_fromPaw;
        ratSummary.mean_dist_from_dig_trajectories_reach_fromPaw(iSession,:,:) = sessionSummary.dig_mean_euc_dist_from_trajectory_reach_fromPaw;
        
        ratSummary.mean_pd_trajectory_grasp(iSession,:,:) = sessionSummary.mean_pd_trajectory_grasp;
        ratSummary.mean_dist_from_pd_trajectory_grasp(iSession,:) = sessionSummary.pd_mean_euc_dist_from_trajectory_grasp';
        ratSummary.mean_dig_trajectories_grasp(iSession,:,:,:) = sessionSummary.mean_dig_trajectories_grasp;
        ratSummary.mean_dist_from_dig_trajectories_grasp(iSession,:,:) = sessionSummary.dig_mean_euc_dist_from_trajectory_grasp;
        ratSummary.mean_dig_trajectories_grasp_fromPaw(iSession,:,:,:) = sessionSummary.mean_dig_trajectories_grasp;
        ratSummary.mean_dist_from_dig_trajectories_grasp_fromPaw(iSession,:,:) = sessionSummary.dig_mean_euc_dist_from_trajectory_grasp;
        
        [ratSummary.first_part_contact(iSession,:)] = calculatePercentFirstPawContact(reachData,numTrials,pawPref);
        
%         coor = 1;
%         [ratSummary.mean_digit_trajectory_from_paw_X(iSession,:,:)] = calculateDigTrajectoryFromPawOverZ(reachData,z_interp_digits,coor);
%         coor = 2;
%         [ratSummary.mean_digit_trajectory_from_paw_Y(iSession,:,:)] = calculateDigTrajectoryFromPawOverZ(reachData,z_interp_digits,coor);
%         coor = 3;
%         [ratSummary.mean_digit_trajectory_from_paw_Z(iSession,:,:)] = calculateDigTrajectoryFromPawOverZ(reachData,z_interp_digits,coor);
     
    end
    
    cd(ratRootFolder);
    save(fullfile(ratSummaryDir,ratSummaryName),'ratSummary','thisRatInfo');
    clear ratSummary
    clear sessions_analyzed;
    
end
        
        