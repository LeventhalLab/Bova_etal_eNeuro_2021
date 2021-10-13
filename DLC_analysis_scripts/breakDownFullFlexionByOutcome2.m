function mean_flex_traj = breakDownFullFlexionByOutcome2(reachData,z_interp_digits,validTrialOutcomes)

num_trials = length(reachData);

flex_traj = NaN(num_trials, length(z_interp_digits));

mean_flex_traj = NaN(1,length(z_interp_digits),length(validTrialOutcomes));

outcomeFlag = false(num_trials,length(validTrialOutcomes));

for iTrial = 1 : num_trials
    
    if isempty(reachData(iTrial).flexion)
        continue;
    end
    if ~iscell(reachData(iTrial).flexion) && isnan(reachData(iTrial).flexion)
        continue;
    end 
    if isempty(reachData(iTrial).flexion{1})
        continue;
    end
    if all(isnan(reachData(iTrial).flexion{1})) || sum(~isnan(reachData(iTrial).flexion{1})) < 2
        continue;
    end
    
    current_outcome = reachData(iTrial).trialScores;
    
    for i_validType = 1 : length(validTrialOutcomes)
        if any(ismember(current_outcome,validTrialOutcomes{i_validType}))
            outcomeFlag(iTrial,i_validType) = true;   % this could be slightly inaccurate, but most trials only have 1 outcome
        end
    end
    
%     graspFrames = traj_limits(iTrial).reach_aperture_lims(1,1) : ...
%         traj_limits(iTrial).reach_aperture_lims(1,2);
%     dig2_z = reachData(iTrial).dig2_trajectory{1}(graspFrames,3);
    dig2_z = reachData(iTrial).dig_trajectory_reach{1}(:,3,2);
    
    curFlexData = reachData(iTrial).flexion{1};
    for i_pt = 1 : length(curFlexData)
        if isnan(curFlexData(i_pt))
            dig2_z(i_pt) = NaN;
        end
    end
    
    if length(reachData(iTrial).flexion{1}) > 1
        if sum(~isnan(curFlexData)) > 5
            cur_flex = pchip(dig2_z,curFlexData,z_interp_digits);
        else
            cur_flex = NaN(size(z_interp_digits));
        end
    else
        cur_flex = NaN(size(z_interp_digits));
    end
    
    cur_flex(z_interp_digits < min(dig2_z)) = NaN;
    cur_flex(z_interp_digits > max(dig2_z)) = NaN;
    flex_traj(iTrial,:) = cur_flex;
end

for i_pt = 1 : size(flex_traj,2)
    numDataPts = sum(~isnan(flex_traj(:,i_pt)));
    if numDataPts < 10
        flex_traj(:,i_pt) = NaN;
    end
end 

for i_outcome = 1 : length(validTrialOutcomes)
    
    mean_flex_traj(:,:,i_outcome) = nanmean(flex_traj(outcomeFlag(:,i_outcome),:));
    mean_flex_traj(mean_flex_traj==0) = NaN;
    
end 

end