function [mean_reach_dur] = breakDownReachDurationByOutcome(reachData,validTrialOutcomes)

num_trials = length(reachData);

reach_dur = NaN(num_trials,1);
mean_reach_dur = NaN(1,length(validTrialOutcomes));
outcomeFlag = false(num_trials,length(validTrialOutcomes));

for iTrial = 1 : num_trials

    current_outcome = reachData(iTrial).trialScores;
    
    for i_validType = 1 : length(validTrialOutcomes)
        if any(ismember(current_outcome,validTrialOutcomes{i_validType}))
            outcomeFlag(iTrial,i_validType) = true;   % this could be slightly inaccurate, but most trials only have 1 outcome
        end
    end
    
    if isempty(reachData(iTrial).slotBreachFrame)
        continue;
    elseif isempty(reachData(iTrial).slotBreachFrame(1))
        continue;
    end
    
    if reachData(iTrial).dig_endPoints_reach(1,2,3) > 1   % excludes trials where the rat did not reach within 1 mm of the pellet
        reach_dur(iTrial) = NaN;
    else
        temp_dur = (reachData(iTrial).last_frame_before_pellet(1) - ...
            reachData(iTrial).slotBreachFrame(1))/300;
        reach_dur(iTrial) = temp_dur*1000;   % convert to ms
    end 
    
end

for i_outcome = 1 : length(validTrialOutcomes)
    mean_reach_dur(i_outcome) = nanmean(reach_dur(outcomeFlag(:,i_outcome)));
end