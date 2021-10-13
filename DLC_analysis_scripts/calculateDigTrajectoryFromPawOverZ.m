function [mean_dig_traj] = calculateDigTrajectoryFromPawOverZ(reachData,z_interp_digits,coor)

num_trials = length(reachData);

% for i_trial = 1:num_trials
%     traj_limits(i_trial,1) = reachData(i_trial).reachStarts(1);
%     traj_limits(i_trial,2) = reachData(i_trial).reachEnds(1);
% end 

%traj_limits = align_trajectory_to_reach(reachData);
dig_traj = NaN(num_trials, length(z_interp_digits),4);
for iTrial = 1 : num_trials

    if isempty(reachData(iTrial).dig_trajectory_reach_fromPaw)
        continue;
    end
    if isempty(reachData(iTrial).dig_trajectory_reach_fromPaw{1})
        continue;
    end
    
%     graspFrames = traj_limits(iTrial,1) : traj_limits(iTrial,2);
%     dig2_z = reachData(iTrial).dig2_trajectory{1}(graspFrames,3);
      dig2_z = reachData(iTrial).dig_trajectory_reach{1}(:,3,2);
      
      curtrajData = squeeze(reachData(iTrial).dig_trajectory_reach_fromPaw{1}(:,coor,:));
      
%     pd_z = reachData(iTrial).pd_trajectory_reach{1}(:,3);
    if length(reachData(iTrial).dig_trajectory_reach_fromPaw{1}) > 1 && length(dig2_z) > 1
        for i_dig = 1:4
            
            if any(isnan(curtrajData(:,i_dig))) % if a lot of the dig dist traj is NaN, get unrealistic numbers - use a truncated z_dig2 and digit data for this
                foundNans = find(isnan(curtrajData(:,i_dig)));
                truncData = curtrajData(foundNans(end)+1:end,i_dig);
                if isempty(truncData) || length(truncData) < 2
                    cur_dig_traj(i_dig,:) = NaN(1,size(z_interp_digits,2));
                    continue;
                end
                trunc_z_dig2 = dig2_z(foundNans(end)+1:end);
                cur_dig_traj(i_dig,:) = pchip(trunc_z_dig2,truncData,z_interp_digits);
                
                cur_dig_traj(i_dig,z_interp_digits < min(trunc_z_dig2)) = NaN;
                cur_dig_traj(i_dig,z_interp_digits > max(trunc_z_dig2)) = NaN;
            else
                cur_dig_traj(i_dig,:) = pchip(dig2_z,reachData(iTrial).dig_trajectory_reach_fromPaw{1}(:,coor,i_dig),z_interp_digits);
                cur_dig_traj(i_dig,z_interp_digits < min(dig2_z)) = NaN;
                cur_dig_traj(i_dig,z_interp_digits > max(dig2_z)) = NaN;
            end 
        end 
    else
        cur_dig_traj(1:4,:) = NaN(4,(size(z_interp_digits,2)));
    end
    
    for i_dig = 1:4
        dig_traj(iTrial,:,i_dig) = cur_dig_traj(i_dig,:);
    end 
end
mean_dig_traj = nanmean(dig_traj);
% std_aperture_traj = nanstd(dig_traj,0,1);
% numValidPoints = sum(~isnan(dig_traj));
% 
% sem_aperture_traj = std_aperture_traj ./ sqrt(numValidPoints);

end