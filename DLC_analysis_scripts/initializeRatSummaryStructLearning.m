function ratSummary = initializeRatSummaryStructLearning(ratID,outcomeCategories,outcomeNames,sessions_analyzed,z_interp_digits)

% calculate the following kinematic parameters:
% number of trials
% percent outcome
% number of reaches per trial
% max velocity, by reach type
% average reach duration, by reach type
% first paw part to contact pellet, by reach type
% average endpoints for reach and grasp components
% average trajectory for a session, by reach time
% deviation from that trajectory for a session
% distance between trajectories
% closest distance paw to pellet
% minimum z, by type
% number of reaches, by type
% aperture of reach orientation at reach and grasp end
% orientation of reach orientation at reach and grasp end
% MRL of reach orientation at reach and grasp end

ratSummary.ratID = ratID;
num_outcome_categories = length(outcomeCategories);

numSessions_to_analyze = size(sessions_analyzed,1);

ratSummary.sessions_analyzed = sessions_analyzed;

ratSummary.num_trials = NaN(numSessions_to_analyze,num_outcome_categories);
ratSummary.outcomePercent = NaN(numSessions_to_analyze,num_outcome_categories);
ratSummary.mean_num_reaches = NaN(numSessions_to_analyze,num_outcome_categories);
ratSummary.std_num_reaches = NaN(numSessions_to_analyze,num_outcome_categories);

ratSummary.mean_pd_v = NaN(numSessions_to_analyze,num_outcome_categories);
ratSummary.std_pd_v = NaN(numSessions_to_analyze,num_outcome_categories);

ratSummary.mean_reach_dur = NaN(numSessions_to_analyze,num_outcome_categories);

ratSummary.first_part_contact = NaN(numSessions_to_analyze,13);

ratSummary.mean_pd_endPt_reach = NaN(numSessions_to_analyze,num_outcome_categories,3);
ratSummary.mean_dig_endPts_reach = NaN(numSessions_to_analyze,num_outcome_categories,4,3);
ratSummary.mean_dig_endPts_reach_fromPaw = NaN(numSessions_to_analyze,num_outcome_categories,4,3);
ratSummary.mean_pd_endPt_grasp = NaN(numSessions_to_analyze,num_outcome_categories,3);
ratSummary.mean_dig_endPts_grasp = NaN(numSessions_to_analyze,num_outcome_categories,4,3);
ratSummary.mean_dig_endPts_grasp_fromPaw = NaN(numSessions_to_analyze,num_outcome_categories,4,3);

ratSummary.cov_pd_endPts_reach = NaN(numSessions_to_analyze,num_outcome_categories,3,3);
ratSummary.cov_dig_endPts_reach = NaN(numSessions_to_analyze,num_outcome_categories,4,3,3);
ratSummary.cov_dig_endPts_reach_fromPaw = NaN(numSessions_to_analyze,num_outcome_categories,4,3,3);
ratSummary.cov_pd_endPts_grasp = NaN(numSessions_to_analyze,num_outcome_categories,3,3);
ratSummary.cov_dig_endPts_grasp = NaN(numSessions_to_analyze,num_outcome_categories,4,3,3);
ratSummary.cov_dig_endPts_grasp_fromPaw = NaN(numSessions_to_analyze,num_outcome_categories,4,3,3);

ratSummary.mean_pd_v = NaN(numSessions_to_analyze,num_outcome_categories);
ratSummary.std_pd_v = NaN(numSessions_to_analyze,num_outcome_categories);

ratSummary.mean_end_orientations = NaN(numSessions_to_analyze,num_outcome_categories);
ratSummary.end_MRL = NaN(numSessions_to_analyze,num_outcome_categories);
ratSummary.mean_end_orientations_grasp = NaN(numSessions_to_analyze,num_outcome_categories);
ratSummary.end_MRL_grasp = NaN(numSessions_to_analyze,num_outcome_categories);

ratSummary.mean_end_aperture = NaN(numSessions_to_analyze,num_outcome_categories);
ratSummary.std_end_aperture = NaN(numSessions_to_analyze,num_outcome_categories);
ratSummary.mean_end_aperture_grasp = NaN(numSessions_to_analyze,num_outcome_categories);
ratSummary.std_end_aperture_grasp = NaN(numSessions_to_analyze,num_outcome_categories);

ratSummary.mean_end_flex = NaN(numSessions_to_analyze,num_outcome_categories);
ratSummary.MRL_end_flex = NaN(numSessions_to_analyze,num_outcome_categories);
ratSummary.mean_end_flex_grasp = NaN(numSessions_to_analyze,num_outcome_categories);
ratSummary.MRL_end_flex_grasp = NaN(numSessions_to_analyze,num_outcome_categories);

ratSummary.aperture_traj = [];
ratSummary.orientation_traj = [];
ratSummary.flexion_traj = [];

ratSummary.mean_aperture_traj = NaN(numSessions_to_analyze,length(z_interp_digits));
ratSummary.mean_orientation_traj = NaN(numSessions_to_analyze,length(z_interp_digits));
ratSummary.mean_flexion_traj = NaN(numSessions_to_analyze,length(z_interp_digits));

ratSummary.std_aperture_traj = NaN(numSessions_to_analyze,length(z_interp_digits));
ratSummary.sem_aperture_traj = NaN(numSessions_to_analyze,length(z_interp_digits));

ratSummary.MRL_traj = NaN(numSessions_to_analyze,length(z_interp_digits));

ratSummary.z_interp_digits = z_interp_digits;

ratSummary.sessionDates = NaT(numSessions_to_analyze,1);
ratSummary.sessionTypes = cell(numSessions_to_analyze,1);

ratSummary.outcomeCategories = outcomeCategories;
ratSummary.outcomeNames = outcomeNames;

% ratSummary.mean_digit_trajectory_from_paw_X = NaN(numSessions_to_analyze,length(z_interp_digits),4);
% ratSummary.mean_digit_trajectory_from_paw_Y = NaN(numSessions_to_analyze,length(z_interp_digits),4);
% ratSummary.mean_digit_trajectory_from_paw_Z = NaN(numSessions_to_analyze,length(z_interp_digits),4);

ratSummary.mean_pd_trajectory_reach = [];
ratSummary.mean_dig_trajectories_reach = [];
ratSummary.mean_dig_trajectories_reach_fromPaw = [];
ratSummary.mean_dist_from_pd_trajectory_reach = [];
ratSummary.mean_dist_from_dig_trajectories_reach = [];
ratSummary.mean_dist_from_dig_trajectories_reach_fromPaw = [];

ratSummary.mean_pd_trajectory_grasp = [];
ratSummary.mean_dig_trajectories_grasp = [];
ratSummary.mean_dig_trajectories_grasp_fromPaw = [];
ratSummary.mean_dist_from_pd_trajectory_grasp = [];
ratSummary.mean_dist_from_dig_trajectories_grasp = [];
ratSummary.mean_dist_from_dig_trajectories_grasp_fromPaw = [];