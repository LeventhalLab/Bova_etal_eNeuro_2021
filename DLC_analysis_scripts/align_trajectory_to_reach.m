function traj_limits = align_trajectory_to_reach(reachData)
% find the start and end index to align orientation and aperture time
% series with paw/grasp trajectories
%
% INPUTS
%   reachData - structure array containing reach info for each trial
%
% OUTPUTS
%   traj_limits
%
% reachData.pd_trajectory starts at "reachStart" and ends at "reachEnd"
% reachData.dig2_trajectory starts at "grastStart" and ends at "graspEnd"
% reachData.firstDigitKinematicsFrame is the first frame for which paw
%   orientation and aperture are defined after the paw breaches the
%   reaching slot
% reachData.orientation/aperture end at reachData.graspEnd

numTrials = length(reachData);
traj_limits.reach_aperture_lims = [];
% traj_limits.grasp_aperture_lims = [];
for iTrial = 1 : numTrials

    num_reaches = length(reachData(iTrial).reachEnds);
    traj_limits(iTrial).reach_aperture_lims = zeros(num_reaches,2);
%     traj_limits(iTrial).grasp_aperture_lims = zeros(num_reaches,2);

    
    
    for i_reach = 1 : num_reaches
        
        if i_reach > size(reachData(iTrial).firstDigitKinematicsFrame,1)
            continue
        end
       
        if isempty(reachData(iTrial).firstDigitKinematicsFrame)
            traj_limits(iTrial).reach_aperture_lims(i_reach,:) = [NaN NaN];
        else
            traj_limits(iTrial).reach_aperture_lims(i_reach,1) = ...
                reachData(iTrial).firstDigitKinematicsFrame(i_reach) - reachData(iTrial).reachStarts(i_reach) + 1;
            traj_limits(iTrial).reach_aperture_lims(i_reach,2) = ...
                traj_limits(iTrial).reach_aperture_lims(i_reach,1) + length(reachData(iTrial).orientation{i_reach}) - 1;
        end
%         traj_limits(iTrial).grasp_aperture_lims(i_reach,1) = ...
%             reachData(iTrial).firstDigitKinematicsFrame(i_reach) - reachData(iTrial).reach_to_grasp_start(i_reach) + 1;
%         traj_limits(iTrial).grasp_aperture_lims(i_reach,2) = ...
%             traj_limits(iTrial).grasp_aperture_lims(i_reach,1) + length(reachData(iTrial).orientation{i_reach}) - 1;
    end

end

end