function plotSessionTraj(iSess)

% plots individual trial and average reach trajectories from session 1 from exemplar rat

ratID = 'R0283'; % select rat you want to analyze
txtSz = 10;
labeledBodypartsFolder = '/Volumes/DLC_data/DLC_output';    % folder where DLC output data is stored

ratInfoFile = fullfile(labeledBodypartsFolder,'test.csv');
ratInfo = readRatInfoTable(ratInfoFile);    % load in file with rat's session info

ratNum = str2double(ratID(3:end));  % get rat ID
curRatRow = find(ratInfo.ratID == ratNum);  % find row of selected rat in rat info table
pawPref = ratInfo.pawPref(curRatRow);   % get rat's paw preference

ratFolder = fullfile(labeledBodypartsFolder,ratID);
cd(ratFolder)   % set directory with DLC output data

sessionDirectories = listFolders([ratID '_2*']);    % get folder names (i.e., session dates) 

curSessFolder = fullfile(ratFolder,sessionDirectories{iSess});
cd(curSessFolder)
curSessData = load([sessionDirectories{iSess}(1:end-1) '_processed_reaches.mat']);
curSessData = curSessData.reachData;    % pull out individual reach kinematic data for selected session

ratSummaryDir = fullfile('/Volumes/DLC_data/rat kinematic summaries'); 
cd(ratSummaryDir)   % go to folder with rat's kinematic summary

avgSessData = load([ratID '_kinematicsSummary.mat']);
avgSessData = avgSessData.ratSummary; % pull out averaged kinematic data 

plot_3Dtraj_full(curSessData,avgSessData,iSess,pawPref) % plot individual reach and average trajectories
