function [mean_dist_from_pd_traj_reach, mean_dist_from_pd_traj_grasp, mean_dist_from_dig_traj_reach, mean_dist_from_dig_traj_grasp] = ...
    breakDownDistFromTrajByOutcome(reachData,validTrialOutcomes)

num_trials = length(reachData);
cur_traj_pd_reach = NaN(100,3,num_trials);
cur_traj_pd_grasp = NaN(100,3,num_trials);
cur_traj_dig_reach = NaN(100,3,num_trials);
cur_traj_dig_grasp = NaN(100,3,num_trials);
mean_dist_from_pd_traj_reach = NaN(1,length(validTrialOutcomes));
mean_dist_from_pd_traj_grasp = NaN(1,length(validTrialOutcomes));
mean_dist_from_dig_traj_reach = NaN(1,length(validTrialOutcomes));
mean_dist_from_dig_traj_grasp = NaN(1,length(validTrialOutcomes));
outcomeFlag = false(num_trials,length(validTrialOutcomes));

% orientation_traj = NaN(num_trials, length(z_interp_digits));
for iTrial = 1 : num_trials
    
    current_outcome = reachData(iTrial).trialScores;
    
    for i_validType = 1 : length(validTrialOutcomes)
        if any(ismember(current_outcome,validTrialOutcomes{i_validType}))
            outcomeFlag(iTrial,i_validType) = true;   % this could be slightly inaccurate, but most trials only have 1 outcome
        end
    end

    if isempty(reachData(iTrial).segmented_pd_trajectory_reach)
        continue;
    end

    cur_traj_pd_reach(:,:,iTrial) = reachData(iTrial).segmented_pd_trajectory_reach;
    if ~isempty(reachData(iTrial).segmented_pd_trajectory_grasp)
        cur_traj_pd_grasp(:,:,iTrial) = reachData(iTrial).segmented_pd_trajectory_grasp;
    end
    cur_traj_dig_reach(:,:,iTrial) = reachData(iTrial).segmented_dig_trajectory_reach(:,:,2);
    if ~isempty(reachData(iTrial).segmented_pd_trajectory_grasp)
        cur_traj_dig_grasp(:,:,iTrial) = reachData(iTrial).segmented_dig_trajectory_grasp(:,:,2);
    end
end

for i_outcome = 1 : length(validTrialOutcomes)
    all_traj_pd_reach = cur_traj_pd_reach(:,:,outcomeFlag(:,i_outcome));
    all_traj_pd_grasp = cur_traj_pd_grasp(:,:,outcomeFlag(:,i_outcome));
    all_traj_dig_reach = cur_traj_dig_reach(:,:,outcomeFlag(:,i_outcome));
    all_traj_dig_grasp = cur_traj_dig_grasp(:,:,outcomeFlag(:,i_outcome));
    if size(all_traj_pd_reach,3) < 2
        mean_dist_from_pd_traj_reach(i_outcome) = NaN;
        mean_dist_from_pd_traj_grasp(i_outcome) = NaN;
        mean_dist_from_dig_traj_reach(i_outcome) = NaN;
        mean_dist_from_dig_traj_grasp(i_outcome) = NaN;
        continue;
    end
    [~,dist_from_traj_pd_reach,~] = calcTrajectoryStats(all_traj_pd_reach);
    [~,dist_from_traj_pd_grasp,~] = calcTrajectoryStats(all_traj_pd_grasp);
    [~,dist_from_traj_dig_reach,~] = calcTrajectoryStats(all_traj_dig_reach);
    [~,dist_from_traj_dig_grasp,~] = calcTrajectoryStats(all_traj_dig_grasp);
    mean_dist_from_pd_traj_reach(i_outcome) = nanmean(dist_from_traj_pd_reach);
    mean_dist_from_pd_traj_grasp(i_outcome) = nanmean(dist_from_traj_pd_grasp);
    mean_dist_from_dig_traj_reach(i_outcome) = nanmean(dist_from_traj_dig_reach);
    mean_dist_from_dig_traj_grasp(i_outcome) = nanmean(dist_from_traj_dig_grasp);
end

end