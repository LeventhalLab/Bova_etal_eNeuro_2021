function [mean_aperture, std_aperture, mean_aperture_grasp, std_aperture_grasp] =...
    breakDownApertureByOutcome(reachData,validTrialOutcomes)

num_trials = length(reachData);
end_aperture = NaN(num_trials,1);
end_aperture_grasp = NaN(num_trials,1);
mean_aperture = NaN(1,length(validTrialOutcomes));
mean_aperture_grasp = NaN(1,length(validTrialOutcomes));
std_aperture = NaN(1,length(validTrialOutcomes));
std_aperture_grasp = NaN(1,length(validTrialOutcomes));
outcomeFlag = false(num_trials,length(validTrialOutcomes));

for iTrial = 1 : num_trials

    current_outcome = reachData(iTrial).trialScores;
    
    for i_validType = 1 : length(validTrialOutcomes)
        if any(ismember(current_outcome,validTrialOutcomes{i_validType}))
            outcomeFlag(iTrial,i_validType) = true;   % this could be slightly inaccurate, but most trials only have 1 outcome
        end
    end
    
    if isempty(reachData(iTrial).aperture)
        continue;
    end
    
    if isempty(reachData(iTrial).aperture{1}) || isempty(reachData(iTrial).aperture_grasp)
        continue;
    end
    end_aperture(iTrial) = reachData(iTrial).aperture{1}(end);
    if isempty(reachData(iTrial).aperture_grasp{1})
        end_aperture_grasp(iTrial) = NaN;
    else
        end_aperture_grasp(iTrial) = reachData(iTrial).aperture_grasp{1}(end);
    end
end

for i_outcome = 1 : length(validTrialOutcomes)
    mean_aperture(i_outcome) = nanmean(end_aperture(outcomeFlag(:,i_outcome)));
    mean_aperture_grasp(i_outcome) = nanmean(end_aperture_grasp(outcomeFlag(:,i_outcome)));
    std_aperture(i_outcome) = nanstd(end_aperture(outcomeFlag(:,i_outcome)));
    std_aperture_grasp(i_outcome) = nanstd(end_aperture_grasp(outcomeFlag(:,i_outcome)));
end