function exptSummary = summarizeKinematicsAcrossSessions(summary)

% collects average kinematics for each rat into one summary structure

num_rats = length(summary);
num_sessions = size(summary(1).ratSummary.num_trials,1);

exptSummary.num_trials = zeros(num_sessions, num_rats);
exptSummary.firstReachSuccess = zeros(num_sessions, num_rats);
exptSummary.anyReachSuccess = zeros(num_sessions, num_rats);
exptSummary.mean_num_reaches = zeros(num_sessions, num_rats);
exptSummary.mean_pd_v = zeros(num_sessions, num_rats);
exptSummary.mean_reach_dur = zeros(num_sessions, num_rats);

exptSummary.percent_paw_contact = zeros(num_sessions, 13, num_rats);

exptSummary.mean_end_orientations = zeros(num_sessions, num_rats);
exptSummary.mean_end_orientations_grasp = zeros(num_sessions, num_rats);
exptSummary.end_MRL = zeros(num_sessions, num_rats);
exptSummary.end_MRL_grasp = zeros(num_sessions, num_rats);
exptSummary.mean_end_aperture = zeros(num_sessions, num_rats);
exptSummary.mean_end_aperture_grasp = zeros(num_sessions, num_rats);
exptSummary.std_end_aperture = zeros(num_sessions, num_rats);
exptSummary.std_end_aperture_grasp = zeros(num_sessions, num_rats);
exptSummary.mean_end_flex = zeros(num_sessions, num_rats);
exptSummary.mean_end_flex_grasp = zeros(num_sessions, num_rats);
exptSummary.end_MRL_flex = zeros(num_sessions, num_rats);
exptSummary.end_MRL_flex_grasp = zeros(num_sessions, num_rats);

exptSummary.mean_pd_endPt_reach = zeros(num_rats,num_sessions,3);
exptSummary.mean_dig2_endPt_reach = zeros(num_rats,num_sessions,3);
exptSummary.mean_pd_start_grasp = zeros(num_rats,num_sessions,3);
exptSummary.mean_dig2_start_grasp = zeros(num_rats,num_sessions,3);
% exptSummary.mean_pd_endPt_digClose = zeros(num_rats,num_sessions,3);
% exptSummary.mean_dig2_endPt_digClose = zeros(num_rats,num_sessions,3);

num_z_points = size(summary(1).ratSummary.mean_aperture_traj,2);
exptSummary.mean_aperture_traj = NaN(num_rats,num_sessions,num_z_points);
exptSummary.std_aperture_traj = NaN(num_rats,num_sessions,num_z_points);
exptSummary.sem_aperture_traj = NaN(num_rats,num_sessions,num_z_points);
exptSummary.mean_orientation_traj = NaN(num_rats,num_sessions,num_z_points);
exptSummary.MRL_traj = NaN(num_rats,num_sessions,num_z_points);
exptSummary.mean_flexion_traj = NaN(num_rats,num_sessions,num_z_points);
exptSummary.MRL_flexion_traj = NaN(num_rats,num_sessions,num_z_points);

exptSummary.mean_dig_traj_reach_x = NaN(num_rats,num_sessions,num_z_points,4);
exptSummary.mean_dig_traj_reach_y = NaN(num_rats,num_sessions,num_z_points,4);
exptSummary.mean_dig_traj_reach_z = NaN(num_rats,num_sessions,num_z_points,4);

exptSummary.mean_pd_dist_from_traj_reach = NaN(num_rats,100,num_sessions);
exptSummary.mean_dig_dist_from_traj_reach = NaN(num_rats,100,num_sessions,4);
exptSummary.mean_pd_dist_from_traj_grasp = NaN(num_rats,100,num_sessions);
exptSummary.mean_dig_dist_from_traj_grasp = NaN(num_rats,100,num_sessions,4);

for i_rat = 1 : num_rats
    
    exptSummary.pawPref(i_rat) = summary(i_rat).thisRatInfo.pawPref;
    
    exptSummary.num_trials(:,i_rat) = summary(i_rat).ratSummary.num_trials(:,1);
    exptSummary.firstReachSuccess(:,i_rat) = summary(i_rat).ratSummary.outcomePercent(:,2);
    exptSummary.anyReachSuccess(:,i_rat) = summary(i_rat).ratSummary.outcomePercent(:,3) + exptSummary.firstReachSuccess(:,i_rat);
    exptSummary.mean_num_reaches(:,i_rat) = summary(i_rat).ratSummary.mean_num_reaches(:,1);
    exptSummary.mean_pd_v(:,i_rat) = summary(i_rat).ratSummary.mean_pd_v(:,1);
    exptSummary.mean_reach_dur(:,i_rat) = summary(i_rat).ratSummary.mean_reach_dur(:,1);
    
    exptSummary.percent_paw_contact(:,:,i_rat) = summary(i_rat).ratSummary.first_part_contact;
    
    exptSummary.end_MRL(:,i_rat) = summary(i_rat).ratSummary.end_MRL(:,1);
    exptSummary.end_MRL_grasp(:,i_rat) = summary(i_rat).ratSummary.end_MRL_grasp(:,1);
    exptSummary.mean_end_aperture(:,i_rat) = summary(i_rat).ratSummary.mean_end_aperture(:,1);
    exptSummary.std_end_aperture(:,i_rat) = summary(i_rat).ratSummary.std_end_aperture(:,1);
    exptSummary.mean_end_aperture_grasp(:,i_rat) = summary(i_rat).ratSummary.mean_end_aperture_grasp(:,1);
    exptSummary.std_end_aperture_grasp(:,i_rat) = summary(i_rat).ratSummary.std_end_aperture_grasp(:,1);
    exptSummary.mean_end_flex(:,i_rat) = summary(i_rat).ratSummary.mean_end_flex(:,1);
    exptSummary.end_MRL_flex(:,i_rat) = summary(i_rat).ratSummary.MRL_end_flex(:,1);
    exptSummary.mean_end_flex_grasp(:,i_rat) = summary(i_rat).ratSummary.mean_end_flex_grasp(:,1);
    exptSummary.end_MRL_flex_grasp(:,i_rat) = summary(i_rat).ratSummary.MRL_end_flex_grasp(:,1);
%     
%     temp_pd_coords_digcl = squeeze(summary(i_rat).ratSummary.mean_pd_endPt_digitClose(:,1,:));
%     temp_dig2_coords_digcl = squeeze(summary(i_rat).ratSummary.mean_dig_endPts_digitClose(:,1,2,:));
%     if exptSummary.pawPref(i_rat) == 'left'
%         temp_pd_coords_digcl(:,1) = -temp_pd_coords_digcl(:,1);
%         temp_dig2_coords_digcl(:,1) = -temp_dig2_coords_digcl(:,1);
%     end
%     exptSummary.mean_pd_endPt_digClose(i_rat,:,:) = temp_pd_coords_digcl;
%     exptSummary.mean_dig2_endPt_digClose(i_rat,:,:) = temp_dig2_coords_digcl;
    
    temp_pd_coords = squeeze(summary(i_rat).ratSummary.mean_pd_endPt_reach(:,1,:));
    temp_dig2_coords = squeeze(summary(i_rat).ratSummary.mean_dig_endPts_reach(:,1,2,:));
    if exptSummary.pawPref(i_rat) == 'left'
        temp_pd_coords(:,1) = -temp_pd_coords(:,1);
        temp_dig2_coords(:,1) = -temp_dig2_coords(:,1);
    end
    exptSummary.mean_pd_endPt_reach(i_rat,:,:) = temp_pd_coords;
    exptSummary.mean_dig2_endPt_reach(i_rat,:,:) = temp_dig2_coords;
    
    temp_pd_coords_grasp = squeeze(summary(i_rat).ratSummary.mean_pd_endPt_grasp(:,1,:));
    temp_dig2_coords_grasp = squeeze(summary(i_rat).ratSummary.mean_dig_endPts_grasp(:,1,2,:));
    if exptSummary.pawPref(i_rat) == 'left'
        temp_pd_coords_grasp(:,1) = -temp_pd_coords_grasp(:,1);
        temp_dig2_coords_grasp(:,1) = -temp_dig2_coords_grasp(:,1);
    end
    exptSummary.mean_pd_endPt_grasp(i_rat,:,:) = temp_pd_coords_grasp;
    exptSummary.mean_dig2_endPt_grasp(i_rat,:,:) = temp_dig2_coords_grasp;
    
    %exptSummary.pawPref(i_rat) = summary(i_rat).thisRatInfo.pawPref;
    
    % mean apertures and orientations and digit flexion as a function of z
    exptSummary.mean_aperture_traj(i_rat,:,:) = summary(i_rat).ratSummary.mean_aperture_traj;
    exptSummary.std_aperture_traj(i_rat,:,:) = summary(i_rat).ratSummary.std_aperture_traj;
    exptSummary.sem_aperture_traj(i_rat,:,:) = summary(i_rat).ratSummary.sem_aperture_traj;
    exptSummary.mean_flexion_traj(i_rat,:,:) = summary(i_rat).ratSummary.mean_flexion_traj;
    exptSummary.MRL_flexion_traj(i_rat,:,:) = summary(i_rat).ratSummary.MRL_flexion_traj;
    
    if exptSummary.pawPref(i_rat) == 'left'
        exptSummary.mean_orientation_traj(i_rat,:,:) = pi - summary(i_rat).ratSummary.mean_orientation_traj;
        exptSummary.mean_end_orientations(:,i_rat) = pi - summary(i_rat).ratSummary.mean_end_orientations(:,1);
        exptSummary.mean_end_orientations_grasp(:,i_rat) = pi - summary(i_rat).ratSummary.mean_end_orientations_grasp(:,1);
    else
        exptSummary.mean_orientation_traj(i_rat,:,:) = summary(i_rat).ratSummary.mean_orientation_traj;
        exptSummary.mean_end_orientations(:,i_rat) = summary(i_rat).ratSummary.mean_end_orientations(:,1);
        exptSummary.mean_end_orientations_grasp(:,i_rat) = summary(i_rat).ratSummary.mean_end_orientations_grasp(:,1);
    end
    exptSummary.MRL_traj(i_rat,:,:) = summary(i_rat).ratSummary.MRL_traj;
    
    exptSummary.z_interp_digits = summary(i_rat).ratSummary.z_interp_digits;
    
    exptSummary.mean_dig_traj_reach_x(i_rat,:,:,:) = summary(i_rat).ratSummary.mean_digit_trajectory_from_paw_X;
    exptSummary.mean_dig_traj_reach_y(i_rat,:,:,:) = summary(i_rat).ratSummary.mean_digit_trajectory_from_paw_Y;
    exptSummary.mean_dig_traj_reach_z(i_rat,:,:,:) = summary(i_rat).ratSummary.mean_digit_trajectory_from_paw_Z;
    
    % mean distance from trajectories
    for iSession = 1:size(summary(i_rat).ratSummary.mean_dist_from_pd_trajectory_reach,1)
        exptSummary.mean_pd_dist_from_traj_reach(i_rat,1:100,iSession) =...
            summary(i_rat).ratSummary.mean_dist_from_pd_trajectory_reach(iSession,1:100);
        exptSummary.mean_pd_dist_from_traj_grasp(i_rat,1:100,iSession) =...
            summary(i_rat).ratSummary.mean_dist_from_pd_trajectory_grasp(iSession,1:100);
        
        for i_dig = 1:4
            exptSummary.mean_dig_dist_from_traj_reach(i_rat,1:100,iSession,i_dig) =...
                summary(i_rat).ratSummary.mean_dist_from_dig_trajectories_reach(iSession,1:100,i_dig);
            exptSummary.mean_dig_dist_from_traj_grasp(i_rat,1:100,iSession,i_dig) =...
                summary(i_rat).ratSummary.mean_dist_from_dig_trajectories_grasp(iSession,1:100,i_dig);
        end 
    end 
    
end

end