function reachData = calculateKinematics(reachData,interp_trajectory,bodyparts,slot_z_wrt_pellet,pawPref,frameRate)
%
% determine reach kinematics for each reach within a trial
%
% INPUTS
%   reachData - structure to hold data for individual reaches within trials
%       with the following fields:
%       .reachEnds - vector containing frames at which each
%            reach terminates (based on digit 2)
%       .graspEnds - vector containing frames at which each
%            grasp terminates. Grasps occur at the end of each reach, but
%            could also be identified if the rat makes another grasp
%            without retracting its paw
%       .reachStarts - vector containing frames at which each reach
%            starts (based on paw dorsum)
%       .graspStarts - when digit 2 started moving forward before a given
%           graspEnd frame
%       .pdEndPoints - n x 3 array (calculated in sessionKinematicsSummary)
%           containing the endpoints of the paw dorsum in 3D for each reach
%       .slotBreachFrame - vector containing frame at which the paw
%            breached the slot for each reach
%       .firstDigitKinematicsFrame - vector containing first frame at which
%           digit kinematics could be identified for each reach
%       .pd_trajectory - cell array containing n x 3 arrays where each
%           array contains (x,y,z) coordinates for each reach within a
%           trial
%       .pd_pathlength - total paw dorsum path length for each reach (sum 
%           of distances between each point along trajectory)
%       .segmented_pd_trajectory - paw dorsum trajectory segmented into a
%           consistent number of segments (default 100)
%       .pd_v - cell array of vectors containing tangential velocity of paw
%           dorsum for each reach
%       .max_pd_v - maximum paw dorsum velocity for each reach
%       .dig_trajectory - cell array of n x 3 x 4 arrays where each array
%           contains (x,y,z) trajectories for each digit (n is the number
%           of points along the trajectory)
%       .dig_pathlength - array of pathlengths for each digit in each reach
%       .segmented_dig_trajectory - array containing individual digit
%           trajectories segmented into consistent numbers of points
%       .dig2_v - cell array of digit 2 tangential velocities for each
%           reach
%       .max_dig2_v - maximum digit 2 velocity
%       .dig_endPoints - end points for each digit in each reach
%       .orientation - cell array of vectors containing paw orientation at
%           each point along the digit trajectory
%       .aperture - cell array of vectors containing digit apertures at
%           each point along the digit trajectory
%       .trialScores - scores read in from trial scores data sheets, but
%           also automatically estimated (e.g., could have no pellet and
%           reach with the wrong paw)
%       .ratIDnum - integer with rat ID number
%       .sessionDate - date session was recorded as a datetime variable
%       .trialNumbers - 2-element vector; first element is the actual trial
%           number in the video name; second element is the total number in
%           the sesson; could be different if labview restarted mid-session
%       .slot_z_wrt_pellet - z-coordinate of the reaching slot with respect to
%           the pellet
%   interp_trajectory - full paw/digit trajectories interpolated to deal
%       with missing points, with respect to the pellet as origin
%   bodyparts - cell array containing names of bodyparts analyzed in DLC
%   slot_z_wrt_pellet - z-coordinate of the reaching slot with respect to
%       the pellet
%   pawPref - 'left' or 'right'
%   frameRate - frame rate of original video
%
% OUTPUTS
%   reachData - same structure array as above; will have one element for
%       each trial
%

[~,~,digIdx,pawDorsumIdx] = findReachingPawParts(bodyparts,pawPref);
pd_trajectory = squeeze(interp_trajectory(:,:,pawDorsumIdx));
dig_trajectory = squeeze(interp_trajectory(:,:,digIdx));

num_reaches = length(reachData.reachEnds);

reachData.pdEndPoints_reach = zeros(num_reaches,3);
reachData.pdEndPoints_graspStart = zeros(num_reaches,3);
reachData.slotBreachFrame = zeros(num_reaches,1);
reachData.firstDigitKinematicsFrame = zeros(num_reaches,1);
reachData.last_frame_before_pellet = zeros(num_reaches,1);
reachData.distToPellet_lastFrameBefore = zeros(num_reaches,1);
reachData.max_pd_v = zeros(num_reaches,1);
reachData.max_dig2_v = zeros(num_reaches,1);
%reachData.segmented_pd_trajectory = {};

reachData.pd_trajectory_reach = {};
reachData.pd_trajectory_grasp = {};
reachData.pd_pathlength_reach = NaN(num_reaches,1);
reachData.pd_pathlength_grasp = NaN(num_reaches,1);
reachData.pd_v = {};
reachData.max_pd_v = [];
reachData.dig_trajectory_reach = {};
reachData.dig_trajectory_grasp = {};
reachData.dig_pathlength_reach = NaN(num_reaches,4);
reachData.dig_pathlength_grasp = NaN(num_reaches,4);
%reachData.segmented_dig_trajectory = {};
reachData.dig2_v = {};
reachData.max_dig2_v = [];
reachData.dig_endPoints_reach = [];
reachData.dig_endPoints_grasp = [];
reachData.orientation = {};
reachData.aperture = {};
reachData.trialScores = [];
reachData.trialNumbers = [];
reachData.slot_z_wrt_pellet = [];

for i_reach = 1 : num_reaches
    if size(reachData.reachStarts,1) < i_reach
        continue;
    end 
    reach_startFrame = reachData.reachStarts(i_reach);
    grasp_startFrame = reachData.graspStarts(i_reach);
    reach_endFrame = reachData.reachEnds(i_reach);
    if reachData.graspEnds(i_reach) < 1282
        grasp_endFrame = reachData.graspEnds(i_reach)+10;
    elseif isnan(reachData.graspEnds(i_reach))
        grasp_endFrame = NaN;
    else
        grasp_endFrame = 1291;
    end 
    
    % paw dorsum trajectory
    %reachData.pd_trajectory{i_reach} = pd_trajectory(reach_startFrame:reach_endFrame,:);
    reachData.pd_trajectory_reach{i_reach} = pd_trajectory(reach_startFrame:reach_endFrame,:);
    reachData.pd_pathlength_reach(i_reach) = trajectory_pathlength(reachData.pd_trajectory_reach{i_reach});
    if ~isnan(grasp_endFrame)   
        reachData.pd_trajectory_grasp{i_reach} = pd_trajectory(grasp_startFrame:grasp_endFrame,:);
        reachData.pd_pathlength_grasp(i_reach) = trajectory_pathlength(reachData.pd_trajectory_grasp{i_reach});
    else    % grasp likely ended after video done recording (don't use this data)
        reachData.pd_trajectory_grasp{i_reach} = {};
    end 
        
    % velocity profile
    pd_v = diff(reachData.pd_trajectory_reach{i_reach},1,1) * frameRate;
    pd_v = sqrt(sum(pd_v.^2,2));
    reachData.pd_v{i_reach} = pd_v;
    
    if ~isempty(pd_v)
        reachData.max_pd_v(i_reach) = max(pd_v);
    end
    
    % dig trajectories
    reachData.dig_trajectory_reach{i_reach} = dig_trajectory(reach_startFrame:reach_endFrame,:,:);
    
    if ~isnan(grasp_endFrame)
        reachData.dig_trajectory_grasp{i_reach} = dig_trajectory(grasp_startFrame:grasp_endFrame,:,:);
    else
        reachData.dig_trajectory_grasp{i_reach} = [];
    end    
    for i_dig = 1 : 4
        cur_reach = reachData.dig_trajectory_reach{i_reach};
        reachData.dig_pathlength_reach(i_reach,i_dig) = trajectory_pathlength(squeeze(cur_reach(:,:,i_dig)));
        cur_grasp = reachData.dig_trajectory_grasp{i_reach};
        if ~isnan(cur_grasp)
            reachData.dig_pathlength_grasp(i_reach,i_dig) = trajectory_pathlength(squeeze(cur_grasp(:,:,i_dig)));
            reachData.dig_trajectory_grasp_fromPaw{i_reach}(:,:,i_dig) = reachData.pd_trajectory_grasp{i_reach} -...
                reachData.dig_trajectory_grasp{i_reach}(:,:,i_dig);
        else
            reachData.dig_pathlength_grasp(i_reach,i_dig) = NaN;
            reachData.dig_trajectory_grasp_fromPaw{i_reach}(:,:,i_dig) = {};
        end
               
        reachData.dig_trajectory_reach_fromPaw{i_reach}(:,:,i_dig) = reachData.pd_trajectory_reach{i_reach} -...
            reachData.dig_trajectory_reach{i_reach}(:,:,i_dig);      
    end
    
    % find the last frame before the paw breaches the frame for this grasp
    % (looking at the second digit)
    last_frame_behind_slot = find(squeeze(reachData.dig_trajectory_reach{i_reach}(:,3,2)) > slot_z_wrt_pellet,1,'last');
    if isempty(last_frame_behind_slot)
        % digit 2 must have started on the outside of the box during this
        % reach/grasp
        last_frame_behind_slot = 0;
    end
    reachData.slotBreachFrame(i_reach) = reach_startFrame + last_frame_behind_slot;
    
    % find the last frame before the second digit passes the pellet;
    % find the dist between position of second digit in this last frame and
    % the pellet
    last_frame_before_pellet = find(squeeze(reachData.dig_trajectory_reach{i_reach}(:,3,2)) > 0,1,'last');
    if isempty(last_frame_before_pellet)
        reachData.last_frame_before_pellet(i_reach) = NaN;
        reachData.distToPellet_lastFrameBefore(i_reach) = NaN;
    else
        reachData.last_frame_before_pellet(i_reach) = reach_startFrame + last_frame_before_pellet;
        reachData.distToPellet_lastFrameBefore(i_reach) = squeeze(reachData.dig_trajectory_reach{i_reach}(last_frame_before_pellet,3,2));
    end 
    
    % dig2 velocity
    dig2_traj = squeeze(reachData.dig_trajectory_reach{i_reach}(:,:,2));
    dig2_v = diff(dig2_traj,1,1) * frameRate;
    dig2_v = sqrt(sum(dig2_v.^2,2));
    reachData.dig2_v{i_reach} = dig2_v;
    if ~isempty(dig2_v)
        reachData.max_dig2_v(i_reach) = max(dig2_v);
    end
    
    % reach endpoints, grasp start points
    reachData.pdEndPoints_reach(i_reach,:) = pd_trajectory(reach_endFrame,:);
    if ~isnan(grasp_endFrame)
        reachData.pdEndPoints_graspStart(i_reach,:) = pd_trajectory(grasp_startFrame,:);
    else
        reachData.pdEndPoints_graspStart(i_reach,:) = NaN;
    end 
    for i_dig = 1 : 4
        cur_dig_traj_reach = squeeze(reachData.dig_trajectory_reach{i_reach}(:,:,i_dig));
        if isempty(cur_dig_traj_reach)
            reachData.dig_endPoints_reach(i_reach,i_dig,:) = NaN;
        else
            reachData.dig_endPoints_reach(i_reach,i_dig,:) = cur_dig_traj_reach(end,:);  
        end 
            
        if ~isnan(reachData.dig_trajectory_grasp{i_reach})
            cur_dig_traj_grasp = squeeze(reachData.dig_trajectory_grasp{i_reach}(:,:,i_dig));
            reachData.dig_endPoints_grasp(i_reach,i_dig,:) = cur_dig_traj_grasp(1,:);
        else
            reachData.dig_endPoints_grasp(i_reach,i_dig,:) = [NaN NaN NaN];
        end 
    end   
    
    % paw orientation
    [reachData.orientation{i_reach},firstValidFrame] = ...
        determinePawOrientation(interp_trajectory(reachData.slotBreachFrame(i_reach):reach_endFrame,:,:),bodyparts,pawPref);
    if isempty(firstValidFrame)    % no defined paw orientation for this reach
        if length(reachData.firstDigitKinematicsFrame) < i_reach
            reachData.firstDigitKinematicsFrame(i_reach) = 0;
            reachData.firstDigitKinematicsFrame(i_reach) = [];
        else
            reachData.firstDigitKinematicsFrame(i_reach) = [];
        end 
    else
        reachData.firstDigitKinematicsFrame(i_reach) = firstValidFrame + reachData.slotBreachFrame(i_reach) - 1;
    end
    
    clear firstValidFrame

    if ~isnan(grasp_endFrame)
        [reachData.orientation_grasp{i_reach},firstValidFrame] = ...
        determinePawOrientation(interp_trajectory(grasp_startFrame:grasp_endFrame,:,:),bodyparts,pawPref);
    end 
    
    % aperture
    [reachData.aperture{i_reach},~] = ...
        determinePawAperture(interp_trajectory(reachData.slotBreachFrame(i_reach):reach_endFrame,:,:),bodyparts,pawPref);
   
    if ~isnan(grasp_endFrame)
        [reachData.aperture_grasp{i_reach},~] = ...
        determinePawAperture(interp_trajectory(grasp_startFrame:grasp_endFrame,:,:),bodyparts,pawPref);
    end 
    
end