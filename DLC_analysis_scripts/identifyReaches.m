function reachData = identifyReaches(reachData,interp_trajectory,bodyparts,slot_z_wrt_pellet,pawPref,varargin)
%
% function to identify individual reaches within a trial. A reach is
% defined as the paw breaching the slot and identifying a time when the
% second digit begins to retract into the box. Parameters can be set to
% define how far the digit must retract and how much time must elapse
% between reaches
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
%       
%   interp_trajectory - full paw/digit trajectories interpolated to deal
%       with missing points, with respect to the pellet as origin
%   bodyparts - cell array containing names of bodyparts analyzed in DLC
%   slot_z_wrt_pellet - z-coordinate of the reaching slot with respect to
%       the pellet
%   pawPref - 'left' or 'right'
%
% OUTPUTS
%   reachData - same as reachData as input, but now contains 

maxReach_Grasp_separation = 25;
minGraspSeparation = 25;
minGraspProminence = .25;
maxPreGraspProminence = 10;
% minReachProminence = 10;
minReachProminence = 7;
max_digit_paw_sep = 40;   % max distance allowed between tip of second digit and paw

for iarg = 1 : 2 : nargin - 5
    switch lower(varargin{iarg})
        case 'mingraspprominence'
            minGraspProminence = varargin{iarg + 1};
        case 'minreachprominence'
            minReachProminence = varargin{iarg + 1};
        case 'maxpregraspprominence'
            maxPreGraspProminence = varargin{iarg + 1};
        case 'mingraspseparation'
            minGraspSeparation = varargin{iarg + 1};
            
    end
end

numFrames = size(interp_trajectory,1);
[mcpIdx,pipIdx,digIdx,pawDorsumIdx] = findReachingPawParts(bodyparts,pawPref);

dig1_traj = squeeze(interp_trajectory(:,:,digIdx(1)));
dig2_traj = squeeze(interp_trajectory(:,:,digIdx(2)));
dig3_traj = squeeze(interp_trajectory(:,:,digIdx(3)));
dig4_traj = squeeze(interp_trajectory(:,:,digIdx(4)));
pd_traj = squeeze(interp_trajectory(:,:,pawDorsumIdx));

dig1_z = dig1_traj(:,3);
dig2_z = dig2_traj(:,3);
dig3_z = dig3_traj(:,3);
dig4_z = dig4_traj(:,3);
pd_z = pd_traj(:,3);

% find reaches that travel a long distance on the way out.
% currently, based on finding maximum extent of digit 2
[reachMins,~] = islocalmin(dig2_z,1,...
            'flatselection','first',...
            'minprominence',minReachProminence,...
            'prominencewindow',[150,0]);%,...
%             'minseparation',minGraspSeparation);

% [reachMins,~] = islocalmin(dig2_z,1,...
%             'flatselection','first',...
%             'minprominence',7,...
%             'prominencewindow',[150,0]);%,...
% %             'minseparation',minGraspSeparation);

% exclude reaches where the paw immediately starts going forward
% again. Again, based on digit 2
reaches_to_keep = islocalmin(dig2_z,1,...
            'minprominence',1,...
            'prominencewindow',[0,1000],...
            'minseparation',minGraspSeparation);
reachMins = reachMins & reaches_to_keep;

% exclude reaches  and grasps where the paw dorsum is too far from digit 2 tip - this
% sometimes happens if the rat reaches with the wrong paw and it is
% misidentified as the "preferred" paw
% find the digit tip farthest from the box
dig1_pd_diff = dig1_traj - pd_traj;
dig2_pd_diff = dig2_traj - pd_traj;
dig3_pd_diff = dig3_traj - pd_traj;
dig4_pd_diff = dig4_traj - pd_traj;
dig1_pd_dist = sqrt(sum(dig1_pd_diff.^2,2));
dig2_pd_dist = sqrt(sum(dig2_pd_diff.^2,2));
dig3_pd_dist = sqrt(sum(dig3_pd_diff.^2,2));
dig4_pd_dist = sqrt(sum(dig4_pd_diff.^2,2));

dig_pd_dist = min([dig1_pd_dist,dig2_pd_dist,dig3_pd_dist,dig4_pd_dist],[],2);
excludeFrames = dig_pd_dist > max_digit_paw_sep;
reachMins = reachMins & ~excludeFrames;

% make sure that both digits 1 and 4 locations are known/estimated at the
% end of each grasp. They may be missing if the digits aren't all the
% way through the slot at reach termination. Essentially, make sure all
% digits are through the slot
areDigitsThroughSlot = (dig1_z < slot_z_wrt_pellet) | (dig2_z < slot_z_wrt_pellet) | (dig4_z < slot_z_wrt_pellet);

reachData.reachEnds = find(reachMins & areDigitsThroughSlot);

% find the paw dorsum maxima in between each reach termination
reachStarts = false(numFrames,1);
num_reaches = length(reachData.reachEnds);
removeReachEndFlag = false(num_reaches,1);
for i_reach = 1 : num_reaches
    % look in the interval from the previous reach (or trial start) to the
    % current reach. find where paw dorsum started moving forward
    if i_reach == 1
        startFrame = 1;
    else
        startFrame = reachData.reachEnds(i_reach-1);
    end
    lastFrame = reachData.reachEnds(i_reach);

    interval_dig2_z_max = max(dig2_z(startFrame:lastFrame));
    interval_pd_z_max = max(pd_z(startFrame:lastFrame));
    if isnan(interval_pd_z_max)   % paw dorsum wasn't found before this reach end point; can happen if rat reaches with wrong paw first
        % invalidate this reach
        removeReachEndFlag(i_reach) = true;
    end
%     reachStarts(dig2_z == interval_dig2_z_max) = true;
    reachStarts(pd_z == interval_pd_z_max) = true;

end
reachData.reachEnds = reachData.reachEnds(~removeReachEndFlag);    
reachData.reachStarts = find(reachStarts);

% find the nearest paw part to the initial pellet location to identify end
% of grasp

numPawParts = length(mcpIdx) + length(pipIdx) + length(digIdx) + length(pawDorsumIdx);
pawPartsList = cell(1,numPawParts);
curPartIdx = 0;
allPawPartsIdx = zeros(numPawParts,1);
for ii = 1 : length(mcpIdx)
    curPartIdx = curPartIdx + 1;
    pawPartsList{curPartIdx} = bodyparts{mcpIdx(ii)};
    allPawPartsIdx(curPartIdx) = mcpIdx(ii);
end
for ii = 1 : length(pipIdx)
    curPartIdx = curPartIdx + 1;
    pawPartsList{curPartIdx} = bodyparts{pipIdx(ii)};
    allPawPartsIdx(curPartIdx) = pipIdx(ii);
end
for ii = 1 : length(digIdx)
    curPartIdx = curPartIdx + 1;
    pawPartsList{curPartIdx} = bodyparts{digIdx(ii)};
    allPawPartsIdx(curPartIdx) = digIdx(ii);
end
for ii = 1 : length(pawDorsumIdx)
    curPartIdx = curPartIdx + 1;
    pawPartsList{curPartIdx} = bodyparts{pawDorsumIdx(ii)};
    allPawPartsIdx(curPartIdx) = pawDorsumIdx(ii);
end

xyz_coords = interp_trajectory(:,:,allPawPartsIdx);

% calculate euclidian distances between every paw part in every frame and the pellet
dist_fromPellet = sqrt(sum(xyz_coords.^2,2));

% find frame with paw part nearest pellet for each part on each reach
for i_reach = 1 : size(reachData.reachStarts,1)
    
    for iPart = 1 : numPawParts
        
        if ~(reachData.reachEnds(i_reach)+30 > numFrames)  
            all_min_dist(iPart,i_reach) = min(dist_fromPellet(reachData.reachEnds(i_reach):...
                reachData.reachEnds(i_reach)+30,iPart));
            if ~isnan(all_min_dist(iPart,i_reach))
                allmin_distFrame(iPart,i_reach) = find(dist_fromPellet(reachData.reachEnds(i_reach):...
                    reachData.reachEnds(i_reach)+30,iPart) == all_min_dist(iPart,i_reach));
            else    % no valid points in this range for this paw part
                allmin_distFrame(iPart,i_reach) = NaN;
            end 
        else     % not enough frames at the end of video
            all_min_dist(iPart,i_reach) = min(dist_fromPellet(reachData.reachEnds(i_reach):numFrames,iPart));
            if ~isnan(all_min_dist(iPart,i_reach))
                allmin_distFrame(iPart,i_reach) = find(dist_fromPellet(reachData.reachEnds(i_reach):...
                    numFrames,iPart) == all_min_dist(iPart,i_reach));
            else    % no valid points in this range for this paw part
                allmin_distFrame(iPart,i_reach) = NaN;
            end 
        end 

    end 
    
    min_dist(i_reach) = min(all_min_dist(:,i_reach));
    min_distPawPart(i_reach) = find(all_min_dist(:,i_reach) == min_dist(1,i_reach),2);
    min_distPawPartName{i_reach} = pawPartsList{min_distPawPart(1,i_reach)};
    min_distFrame(i_reach) = allmin_distFrame(min_distPawPart(1,i_reach),i_reach) + reachData.reachEnds(i_reach) - 1;
end

if size(reachData.reachStarts,1) == 0
    reachData.graspStarts = [];
    reachData.graspEnds = [];
    reachData.closestPawPart = {};
    reachData.closestDistToPellet = [];
else
%     reachData.graspStarts = reachData.reachEnds;
    reachData.closestPawFrame = min_distFrame;
    reachData.closestPawPart = min_distPawPartName;
    reachData.closestDistToPellet = min_dist;
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OLD VERSION START
% % alex additions start here
% dig2ThroughSlot = dig2_z < slot_z_wrt_pellet;
% 
% % dig1_dig2_diff = dig1_traj - dig2_traj;
% % dig2_dig3_diff = dig2_traj - dig3_traj;
% % dig3_dig4_diff = dig3_traj - dig4_traj;
% % 
% % dig1_dig2_dist = sqrt(sum(dig1_dig2_diff.^2,2));
% % dig2_dig3_dist = sqrt(sum(dig2_dig3_diff.^2,2));
% % dig3_dig4_dist = sqrt(sum(dig3_dig4_diff.^2,2));
% % 
% % dig_dist = min([dig1_dig2_dist,dig2_dig3_dist,dig3_dig4_dist],[],2);
% 
% %dig_pd_dist = min([dig3_pd_dist,dig4_pd_dist],[],2);
% 
% for i_reach = 1:length(reachData.reachEnds)
%     startGraspFr = reachData.reachEnds(i_reach);
%     lastFrBeforeSlot = (find(dig2ThroughSlot(startGraspFr:end)==0,1,'first') + startGraspFr - 2);
%     if isempty(lastFrBeforeSlot)
%         if i_reach < length(reachData.reachEnds)
%             lastFrBeforeSlot = reachData.reachEnds(i_reach+1) - 1;
%         else
%             lastFrBeforeSlot = size(dig2ThroughSlot,1);
%         end 
%     end
%     
%     %postReach_preSlot_dists = dig1_dig2_dist(startGraspFr:lastFrBeforeSlot);
%     postReach_preSlot_dists = dig3_pd_dist(startGraspFr:lastFrBeforeSlot);
%     %postReach_preSlot_dists = dig_dist(startGraspFr:lastFrBeforeSlot);
%     
%     graspMins = islocalmin(postReach_preSlot_dists,...
%         'minprominence',minGraspProminence,...
%         'FlatSelection','first',...
%         'MinSeparation',minGraspSeparation);
%     
%     tempFrameGraspMins = find(graspMins == 1);
%     if length(tempFrameGraspMins) > 1
%         for i_poss = 1:length(tempFrameGraspMins)
%             cur_dig2_z = dig2_z(tempFrameGraspMins(i_poss) + startGraspFr);
%             if cur_dig2_z < 0 && i_poss < length(tempFrameGraspMins)
%                 continue;
%             elseif cur_dig2_z < 0 && i_poss == length(tempFrameGraspMins)
%                 curGraspMins = [];
%                 break
%             else               
%                 curGraspMins = tempFrameGraspMins(i_poss);
%                 break
%             end
%         end              
%     else
%         curGraspMins = tempFrameGraspMins;
%     end
%     
%     if isempty(curGraspMins)
%         reachData.graspEnds(i_reach) = NaN;
%     else
%         reachData.graspEnds(i_reach) = curGraspMins + startGraspFr;  
%     end 
%     
%     reachData.graspStarts(i_reach) = reachData.reachEnds(i_reach);
% end 
%     
% 
% % alex additions end here

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OLD VERSION END

