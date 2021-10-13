% script_collectRatSummaries_learning

% collects average kinematics for each rat into one summary structure

labeledBodypartsFolder = '/Volumes/DLC_data/DLC_output';
ratSummaryDir = fullfile('/Volumes/DLC_data/rat kinematic summaries');
if ~exist(ratSummaryDir,'dir')
    mkdir(ratSummaryDir)
end

xlDir = labeledBodypartsFolder;
csvfname = fullfile(xlDir,'test.csv');
ratInfo = readRatInfoTable(csvfname);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(ratSummaryDir)
curRats = dir('R0*ary.mat');
curRatNames = NaN(size(curRats,1),1);
for i_rat = 1:size(curRats,1)
    curRatNames(i_rat,1) = convertCharsToStrings(curRats(i_rat).name(3:5));
end 

for i_rat = 1 : size(curRatNames)
    ratRow = find(ratInfo.ratID == curRatNames(i_rat));
    curRatList(i_rat,:) = ratInfo(ratRow,:);
end 

ratIDs = [curRatList.ratID];
numRats = length(ratIDs);

for i_rat = 1 : numRats

    % load session info for this rat

    ratIDstring = sprintf('R%04d',ratIDs(i_rat));
    ratSummaryName = [ratIDstring '_kinematicsSummary.mat'];
    summary(i_rat) = load(ratSummaryName);

end

learning_summary = summarizeKinematicsAcrossSessions(summary);

cd(ratSummaryDir)
save('learning_summaries.mat','learning_summary')