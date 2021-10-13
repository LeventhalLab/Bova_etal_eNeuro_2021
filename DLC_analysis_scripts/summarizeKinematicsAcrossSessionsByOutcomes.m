function exptOutcomeSummary = summarizeKinematicsAcrossSessionsByOutcomes(summary,trajSummary,outcomeSummary)

num_outcomes = 7;
full_num_outcomes = 12;
num_sessions = size(summary(1).ratSummary.sessions_analyzed,1);
num_rats = length(summary);

exptOutcomeSummary.outcomePercent = zeros(num_sessions, num_outcomes, num_rats);
exptOutcomeSummary.fullOutcomePercent = zeros(num_sessions,full_num_outcomes,num_rats);
exptOutcomeSummary.mean_num_reaches = zeros(num_sessions, num_outcomes);
exptOutcomeSummary.mean_pd_v = zeros(num_sessions, num_outcomes);
exptOutcomeSummary.mean_end_orientations = zeros(num_sessions, num_outcomes);
exptOutcomeSummary.end_MRL = zeros(num_sessions, num_outcomes);
exptOutcomeSummary.mean_end_aperture = zeros(num_sessions, num_outcomes);
exptOutcomeSummary.std_end_aperture = zeros(num_sessions, num_outcomes);
exptOutcomeSummary.mean_end_flex = zeros(num_sessions, num_outcomes);
exptOutcomeSummary.end_MRL_flex = zeros(num_sessions, num_outcomes);

exptOutcomeSummary.mean_pd_endPt_x = zeros(num_sessions,num_outcomes,num_rats);
exptOutcomeSummary.mean_dig2_endPt_x = zeros(num_sessions,num_outcomes,num_rats);
exptOutcomeSummary.mean_pd_endPt_y = zeros(num_sessions,num_outcomes,num_rats);
exptOutcomeSummary.mean_dig2_endPt_y = zeros(num_sessions,num_outcomes,num_rats);
exptOutcomeSummary.mean_pd_endPt_z = zeros(num_sessions,num_outcomes,num_rats);
exptOutcomeSummary.mean_dig2_endPt_z = zeros(num_sessions,num_outcomes,num_rats);

exptOutcomeSummary.cov_pd_endPt = zeros(num_sessions,num_outcomes,3,3,num_rats);
exptOutcomeSummary.cov_dig1_endPt = zeros(num_sessions,num_outcomes,3,3,num_rats);
exptOutcomeSummary.cov_dig2_endPt = zeros(num_sessions,num_outcomes,3,3,num_rats);
exptOutcomeSummary.cov_dig3_endPt = zeros(num_sessions,num_outcomes,3,3,num_rats);
exptOutcomeSummary.cov_dig4_endPt = zeros(num_sessions,num_outcomes,3,3,num_rats);

num_z_points = size(summary(1).ratSummary.mean_aperture_traj,2);
exptOutcomeSummary.mean_aperture_traj = NaN(num_sessions,num_z_points,num_outcomes,num_rats);
exptOutcomeSummary.mean_orientation_traj = NaN(num_sessions,num_z_points,num_outcomes,num_rats);
exptOutcomeSummary.mean_flex_traj = NaN(num_sessions,num_z_points,num_outcomes,num_rats);

exptOutcomeSummary.mean_dist_from_pd_trajectory_reach = NaN(num_sessions,num_outcomes,num_rats);
exptOutcomeSummary.mean_dist_from_pd_trajectory_grasp = NaN(num_sessions,num_outcomes,num_rats);
exptOutcomeSummary.mean_dist_from_dig_trajectory_reach = NaN(num_sessions,num_outcomes,num_rats);
exptOutcomeSummary.mean_dist_from_dig_trajectory_grasp = NaN(num_sessions,num_outcomes,num_rats);

exptOutcomeSummary.outcomeCategories = summary(1).ratSummary.outcomeCategories;
exptOutcomeSummary.outcomeNames = summary(1).ratSummary.outcomeNames;
exptOutcomeSummary.fullOutcomeCategories = outcomeSummary(1).ratSummary.outcomeCategories;
exptOutcomeSummary.fullOutcomeNames = outcomeSummary(1).ratSummary.outcomeNames;

for i_rat = 1 : num_rats
    
    exptOutcomeSummary.pawPref(i_rat) = summary(i_rat).thisRatInfo.pawPref;
    
    exptOutcomeSummary.outcomePercent(:,:,i_rat) = summary(i_rat).ratSummary.outcomePercent(:,:);
    exptOutcomeSummary.fullOutcomePercent(:,:,i_rat) = outcomeSummary(i_rat).ratSummary.outcomePercent(:,:);
    exptOutcomeSummary.mean_num_reaches(:,:,i_rat) = summary(i_rat).ratSummary.mean_num_reaches(:,:);
    exptOutcomeSummary.mean_pd_v(:,:,i_rat) = summary(i_rat).ratSummary.mean_pd_v(:,:);
    exptOutcomeSummary.end_MRL(:,:,i_rat) = summary(i_rat).ratSummary.end_MRL(:,:);
    exptOutcomeSummary.mean_end_aperture(:,:,i_rat) = summary(i_rat).ratSummary.mean_end_aperture(:,:);
    exptOutcomeSummary.std_end_aperture(:,:,i_rat) = summary(i_rat).ratSummary.std_end_aperture(:,:);
    exptOutcomeSummary.mean_end_flex(:,:,i_rat) = summary(i_rat).ratSummary.mean_end_flex(:,:);
    exptOutcomeSummary.end_MRL_flex(:,:,i_rat) = summary(i_rat).ratSummary.MRL_end_flex(:,:);
    
    exptOutcomeSummary.mean_pd_endPt_x(:,:,i_rat) = summary(i_rat).ratSummary.mean_pd_endPt_reach(:,:,1);
    exptOutcomeSummary.mean_dig2_endPt_x(:,:,i_rat) = summary(i_rat).ratSummary.mean_dig_endPts_reach(:,:,2,1);
    
    exptOutcomeSummary.mean_pd_endPt_y(:,:,i_rat) = summary(i_rat).ratSummary.mean_pd_endPt_reach(:,:,2);
    exptOutcomeSummary.mean_dig2_endPt_y(:,:,i_rat) = summary(i_rat).ratSummary.mean_dig_endPts_reach(:,:,2,2);
    
    exptOutcomeSummary.mean_pd_endPt_z(:,:,i_rat) = summary(i_rat).ratSummary.mean_pd_endPt_reach(:,:,3);
    exptOutcomeSummary.mean_dig2_endPt_z(:,:,i_rat) = summary(i_rat).ratSummary.mean_dig_endPts_reach(:,:,2,3);
    
    exptOutcomeSummary.cov_pd_endPt(:,:,:,:,i_rat) = squeeze(summary(i_rat).ratSummary.cov_pd_endPts_reach(:,:,:,:));
    exptOutcomeSummary.cov_dig1_endPt(:,:,:,:,i_rat) = squeeze(summary(i_rat).ratSummary.cov_dig_endPts_reach(:,:,1,:,:));
    exptOutcomeSummary.cov_dig2_endPt(:,:,:,:,i_rat) = squeeze(summary(i_rat).ratSummary.cov_dig_endPts_reach(:,:,2,:,:));
    exptOutcomeSummary.cov_dig3_endPt(:,:,:,:,i_rat) = squeeze(summary(i_rat).ratSummary.cov_dig_endPts_reach(:,:,3,:,:));
    exptOutcomeSummary.cov_dig4_endPt(:,:,:,:,i_rat) = squeeze(summary(i_rat).ratSummary.cov_dig_endPts_reach(:,:,4,:,:));
    
    if exptOutcomeSummary.pawPref(i_rat) == 'left'
        exptOutcomeSummary.mean_end_orientations(:,:,i_rat) = pi - summary(i_rat).ratSummary.mean_end_orientations(:,:);
    else 
        exptOutcomeSummary.mean_end_orientations(:,:,i_rat) = summary(i_rat).ratSummary.mean_end_orientations(:,:);
    end

    
    % mean apertures and orientations as a function of z
    exptOutcomeSummary.mean_aperture_traj(:,:,:,i_rat) = trajSummary(i_rat).ratSummary.aperture_traj(:,:,:);
    
    if exptOutcomeSummary.pawPref(i_rat) == 'left'
        exptOutcomeSummary.mean_orientation_traj(:,:,:,i_rat) = pi - trajSummary(i_rat).ratSummary.orientation_traj(:,:,:);
    else
        exptOutcomeSummary.mean_orientation_traj(:,:,:,i_rat) = trajSummary(i_rat).ratSummary.orientation_traj(:,:,:);
    end 
    
    exptOutcomeSummary.mean_flex_traj(:,:,:,i_rat) = trajSummary(i_rat).ratSummary.flex_traj(:,:,:);
    
    % mean distance from average trajectories 
    exptOutcomeSummary.mean_dist_from_pd_trajectory_reach(:,:,i_rat) = trajSummary(i_rat).ratSummary.mean_dist_from_pd_traj_reach;
    exptOutcomeSummary.mean_dist_from_pd_trajectory_grasp(:,:,i_rat) = trajSummary(i_rat).ratSummary.mean_dist_from_pd_traj_grasp;
    exptOutcomeSummary.mean_dist_from_dig_trajectory_reach(:,:,i_rat) = trajSummary(i_rat).ratSummary.mean_dist_from_dig_traj_reach;
    exptOutcomeSummary.mean_dist_from_dig_trajectory_grasp(:,:,i_rat) = trajSummary(i_rat).ratSummary.mean_dist_from_dig_traj_grasp;
        
    
end

end
    