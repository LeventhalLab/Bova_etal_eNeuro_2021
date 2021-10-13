function mean_orientation_traj = breakDownFullOrientationByOutcome2(reachData,z_interp_digits,validTrialOutcomes)

num_trials = length(reachData);

traj_limits = align_trajectory_to_reach(reachData);
orientation_traj = NaN(num_trials, length(z_interp_digits));

mean_orientation_traj = NaN(1,length(z_interp_digits),length(validTrialOutcomes));

outcomeFlag = false(num_trials,length(validTrialOutcomes));

for iTrial = 1 : num_trials
    
    current_outcome = reachData(iTrial).trialScores;
    
    for i_validType = 1 : length(validTrialOutcomes)
        if any(ismember(current_outcome,validTrialOutcomes{i_validType}))
            outcomeFlag(iTrial,i_validType) = true;   % this could be slightly inaccurate, but most trials only have 1 outcome
        end
    end

    if isempty(reachData(iTrial).orientation)
        continue;
    end
    if isempty(reachData(iTrial).orientation{1})
        continue;
    end
    
    graspFrames = traj_limits(iTrial).reach_aperture_lims(1,1) : ...
        traj_limits(iTrial).reach_aperture_lims(1,2);
%     dig2_z = reachData(iTrial).dig2_trajectory{1}(graspFrames,3);
    dig2_z = reachData(iTrial).dig_trajectory_reach{1}(graspFrames,3,2);
    
    if length(reachData(iTrial).aperture{1}) > 1
        cur_orientations = pchip(dig2_z,reachData(iTrial).orientation{1},z_interp_digits);
    else
        cur_orientations = NaN(size(z_interp_digits));
    end
    
    cur_orientations(z_interp_digits < min(dig2_z)) = NaN;
    cur_orientations(z_interp_digits > max(dig2_z)) = NaN;
    orientation_traj(iTrial,:) = cur_orientations;
end

for i_pt = 1 : size(orientation_traj,2)
    numDataPts = sum(~isnan(orientation_traj(:,i_pt)));
    if numDataPts < 10
        orientation_traj(:,i_pt) = NaN;
    end
end 

for i_outcome = 1 : length(validTrialOutcomes)
    
    mean_orientation_traj(:,:,i_outcome) = nancirc_mean(orientation_traj(outcomeFlag(:,i_outcome),:));
    mean_orientation_traj(mean_orientation_traj==0) = NaN;
    
end 

end