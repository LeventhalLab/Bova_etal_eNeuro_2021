function reachIdx = find_reaches2(localMins,z,y,min_z_diff_pre_reach,min_z_diff_post_reach,...
    maxFramesPriorToAdvance,extraFramesExtracted,pts_to_extract)

poss_reach_idx = find(localMins);
poss_reach_idx = poss_reach_idx(poss_reach_idx > extraFramesExtracted);
% extra frames prior to triggerFrame should be input to this function; but
% don't allow poss_reach_idx to be returned as an actual reach if before
% the trigger frame
num_poss_reaches = length(poss_reach_idx);

reachIdx = false(length(localMins),1);
for i_possReach = 1 : num_poss_reaches

    % throw out points near the very beginning or end of the time series of
    % z-values (avoid errors, and should have allowed enough buffer when
    % calling this function that these edge points aren't relevant).
    if poss_reach_idx(i_possReach) - pts_to_extract < 1 || ...
            poss_reach_idx(i_possReach) + max(pts_to_extract,maxFramesPriorToAdvance) > length(localMins)
        continue;
    end
    
    % extract z-coordinates near the current local minimum
    z_at_min = z(poss_reach_idx(i_possReach));
    
    % if the paw part advances past its current position, or there is another
    % local minimum in the next maxFramesPriorToAdvance frames, don't count
    % this as a reach
    test_z = z(poss_reach_idx(i_possReach)+1:poss_reach_idx(i_possReach) + maxFramesPriorToAdvance);
    if any(test_z < z_at_min) %|| any(localMins(poss_reach_idx(i_possReach)+1:poss_reach_idx(i_possReach) + maxFramesPriorToAdvance))
        continue;
    end
    
    % if the paw part is moving upwards, don't count it as a reach. It
    % sometimes happens that the paw is resting on the bottom of the slot;
    % to retract, the digits move towards the pellet and up, but this is
    % clearly NOT a reach.
    y_diff = diff(y(poss_reach_idx(i_possReach)-5:poss_reach_idx(i_possReach)));

    % if the paw part is moving up quickly AND there are no points where it was
    % descending quickly, throw it out
    if any(y_diff < -0.6) && ~any(y_diff > 0.6)
        continue;
    end
    % if the paw part retracted at least min_z_diff_pre_reach, count it as
    % a reach. It must have also moved at least z_diff_for_reach forward
    % prior to the reach and then pulled back that far after the reach.
    % extract points prior to potential reach
    test_z_backward = z(poss_reach_idx(i_possReach)-pts_to_extract:poss_reach_idx(i_possReach)-1);
    test_diff_backward = test_z_backward - z_at_min;
    
    test_z_forward = z(poss_reach_idx(i_possReach)+1:poss_reach_idx(i_possReach)+pts_to_extract);
    test_diff_forward = test_z_forward - z_at_min;
    if any(test_diff_backward > min_z_diff_pre_reach) && any(test_diff_forward > min_z_diff_post_reach)
        reachIdx(poss_reach_idx(i_possReach)) = true;
    elseif any(test_diff_backward > min_z_diff_pre_reach) && any(isnan(test_diff_forward))...
            && any(test_diff_forward > .5)
        reachIdx(poss_reach_idx(i_possReach)) = true;
    end
    
end

end



