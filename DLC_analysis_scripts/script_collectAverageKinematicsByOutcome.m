% script_collectAverageKinematicsByOutcome

% creates a .mat file with all average kinematics for each outcome type for all rats 

% 1.outcomePercent 
% 2. fullOutcomePercent
% 3. average number reaches per trial
% 4. average max velocity
% 5. average paw orientation at reach end
% 6. average orientation MRL at reach end 
% 7. average aperture at reach end
% 8. average std aperture at reach end
% 9. average digit flexion at reach end
% 10. average flexion MRL at reach end
% 11. average endpoints of paw and dig2 (X,Y,and Z)
% 12. covariance of paw and digit endpoints
% 13. averge aperture, orientation, and digit flexion over reach trajectories
% 14. average distance from mean trajectories (reach and grasp, paw and dig2)
% 15. outcome names

ratSummaryDir = fullfile('/Volumes/DLC_data/rat kinematic summaries');
if ~exist(ratSummaryDir,'dir')
    mkdir(ratSummaryDir);
end

labeledBodypartsFolder = '/Volumes/DLC_data/DLC_output';
xlDir = labeledBodypartsFolder;
csvfname = fullfile(xlDir,'test.csv');
ratInfo = readRatInfoTable(csvfname);

cd(xlDir)

ratFolders = dir('R0*');
numRatFolders = length(ratFolders);

for i_rat = 1 : numRatFolders
    
    % load kinematic session data for this rat 
    cd(ratSummaryDir);
    ratIDstring = ratFolders(i_rat).name;
    ratSummaryName = [ratIDstring '_kinematicsSummary.mat'];
    trajSummaryName = [ratIDstring '_outcomeTrajectory.mat'];
    outcomeSummaryName = [ratIDstring '_outcomeDistribution.mat'];
    summary(i_rat) = load(ratSummaryName);
    trajSummary(i_rat) = load(trajSummaryName);
    outcomeSummary(i_rat) = load(outcomeSummaryName);

end

cur_summary = summarizeKinematicsAcrossSessionsByOutcomes(summary,trajSummary,outcomeSummary);   

exptOutcomeSummary = cur_summary;

clear cur_summary
clear summary

save('experiment_summaries_by_outcome.mat','exptOutcomeSummary')

