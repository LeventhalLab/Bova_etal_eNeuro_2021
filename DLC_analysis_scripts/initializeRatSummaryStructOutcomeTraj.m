function ratSummary = initializeRatSummaryStructOutcomeTraj(ratID,outcomeCategories,sessions_analyzed,z_interp_digits)

% creates a summary structure for following measurements for each outcome score:
% 1. aperture as function of z digit 2
% 2. orientation as function of z digit 2
% 3. digit flexion as function of z digit 2
% 4. average distance of paw trajectory from mean trajectory (reach)
% 5. average distance of paw trajectory from mean trajectory (grasp)
% 6. average distance of digit2 trajectory from mean trajectory (reach)
% 7. average distance of digit2 trajectory from mean trajectory (grasp)

ratSummary.ratID = ratID;
num_outcome_categories = length(outcomeCategories);

numSessions_to_analyze = size(sessions_analyzed,1);

ratSummary.sessions_analyzed = sessions_analyzed;

ratSummary.aperture_traj = NaN(numSessions_to_analyze,length(z_interp_digits),num_outcome_categories);
ratSummary.orientation_traj = NaN(numSessions_to_analyze,length(z_interp_digits),num_outcome_categories);
ratSummary.flex_traj = NaN(numSessions_to_analyze,length(z_interp_digits),num_outcome_categories);
ratSummary.mean_dist_from_pd_traj_reach = NaN(numSessions_to_analyze,num_outcome_categories);
ratSummary.mean_dist_from_pd_traj_grasp = NaN(numSessions_to_analyze,num_outcome_categories);
ratSummary.mean_dist_from_dig_traj_reach = NaN(numSessions_to_analyze,num_outcome_categories);
ratSummary.mean_dist_from_dig_traj_grasp = NaN(numSessions_to_analyze,num_outcome_categories);
ratSummary.paw_end
