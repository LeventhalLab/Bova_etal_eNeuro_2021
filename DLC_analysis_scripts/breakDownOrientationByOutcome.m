function [mean_orientations,MRL,mean_orientations_grasp,MRL_grasp] =...
    breakDownOrientationByOutcome(reachData,validTrialOutcomes,pawPref)

num_trials = length(reachData);
end_orientation = NaN(num_trials,1);
end_orientation_grasp = NaN(num_trials,1);
mean_orientations = NaN(1,length(validTrialOutcomes));
mean_orientations_grasp = NaN(1,length(validTrialOutcomes));
MRL = NaN(1,length(validTrialOutcomes));
MRL_grasp = NaN(1,length(validTrialOutcomes));
outcomeFlag = false(num_trials,length(validTrialOutcomes));

for iTrial = 1 : num_trials

    current_outcome = reachData(iTrial).trialScores;
    
    for i_validType = 1 : length(validTrialOutcomes)
        if any(ismember(current_outcome,validTrialOutcomes{i_validType}))
            outcomeFlag(iTrial,i_validType) = true;   % this could be slightly inaccurate, but most trials only have 1 outcome
        end
    end
    
    if isempty(reachData(iTrial).orientation)
        continue;
    end
    
    if isempty(reachData(iTrial).orientation{1}) || isempty(reachData(iTrial).orientation_grasp)
        continue;
    end
    if pawPref(1) == 'l'
        xx = pi - reachData(iTrial).orientation{1}(end);
        if isempty(reachData(iTrial).orientation_grasp{1})
            xx_grasp = NaN;
        else
            xx_grasp = pi - reachData(iTrial).orientation_grasp{1}(end);
        end
    else
        xx = reachData(iTrial).orientation{1}(end);
        if isempty(reachData(iTrial).orientation_grasp{1})
            xx_grasp = NaN;
        else
            xx_grasp = reachData(iTrial).orientation_grasp{1}(end);
        end
    end 
    if xx > 1.6 || xx < 0 
        end_orientation(iTrial) = NaN;
    else
        end_orientation(iTrial) = reachData(iTrial).orientation{1}(end);
    end 
    if xx_grasp > 1.6 || xx < 0
        end_orientation_grasp(iTrial) = NaN;
    else
        if isempty(reachData(iTrial).orientation_grasp{1}) 
            end_orientation_grasp(iTrial) = NaN;
        else
            end_orientation_grasp(iTrial) = reachData(iTrial).orientation_grasp{1}(end);
        end
        
    end 
    
end

for i_outcome = 1 : length(validTrialOutcomes)

    if any(outcomeFlag(:,i_outcome))   % is there at least one trial of this type?
        mean_orientations(i_outcome) = nancirc_mean(end_orientation(outcomeFlag(:,i_outcome)));
        mean_orientations_grasp(i_outcome) = nancirc_mean(end_orientation_grasp(outcomeFlag(:,i_outcome)));
        MRL(i_outcome) = nancirc_r(end_orientation(outcomeFlag(:,i_outcome)));
        MRL_grasp(i_outcome) = nancirc_r(end_orientation_grasp(outcomeFlag(:,i_outcome)));
    end
    
end