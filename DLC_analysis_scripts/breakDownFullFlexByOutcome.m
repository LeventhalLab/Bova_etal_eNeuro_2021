function [flex_traj, mean_flex_traj, MRL_traj] = breakDownFullFlexByOutcome(reachData,z_interp_digits)

num_trials = length(reachData);
% align_trajectory_to_reach_flex(reachData)
% traj_limits = align_trajectory_to_reach(reachData);
flex_traj = NaN(num_trials, length(z_interp_digits));
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
    
%     graspFrames = traj_limits(iTrial).reach_aperture_lims(1,1) : ...
%         traj_limits(iTrial).reach_aperture_lims(1,2);
% %     dig2_z = reachData(iTrial).dig2_trajectory{1}(graspFrames,3);
    dig2_z = reachData(iTrial).dig_trajectory_reach{1}(:,3,2);    
    curFlexData = reachData(iTrial).flexion{1};
    for i_pt = 1 : length(curFlexData)
        if isnan(curFlexData(i_pt))
            dig2_z(i_pt) = NaN;
        end
    end
    
    if length(reachData(iTrial).flexion{1}) > 1
        cur_flex = pchip(dig2_z,curFlexData,z_interp_digits);
    else
        cur_flex = NaN(size(z_interp_digits));
    end
    
    cur_flex(z_interp_digits < min(dig2_z)) = NaN;
    cur_flex(z_interp_digits > max(dig2_z)) = NaN;
    flex_traj(iTrial,:) = cur_flex;
end

flex_traj = (flex_traj*pi)/180;

% get rid of data points along z when there are too few trials w/ data
% points for average (don't want average swayed by very few trials)
for i_pt = 1 : size(flex_traj,2)
    numDataPts = sum(~isnan(flex_traj(:,i_pt)));
    if numDataPts < 10
        flex_traj(:,i_pt) = NaN;
    end
end 

mean_flex_traj = nancirc_mean(flex_traj);
mean_flex_traj(mean_flex_traj==0) = NaN;
MRL_traj = nancirc_r(flex_traj);
MRL_traj(MRL_traj==0) = NaN;

end