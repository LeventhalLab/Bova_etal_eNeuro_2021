function [mean_flex, MRL_flex, mean_flex_grasp, MRL_flex_grasp] =...
    breakDownFlexionByOutcome(reachData,validTrialOutcomes)

num_trials = length(reachData);
end_flex = NaN(num_trials,1);
end_flex_grasp = NaN(num_trials,1);
mean_flex = NaN(1,length(validTrialOutcomes));
mean_flex_grasp = NaN(1,length(validTrialOutcomes));
MRL_flex = NaN(1,length(validTrialOutcomes));
MRL_flex_grasp = NaN(1,length(validTrialOutcomes));
outcomeFlag = false(num_trials,length(validTrialOutcomes));

for iTrial = 1 : num_trials

    current_outcome = reachData(iTrial).trialScores;
    
    for i_validType = 1 : length(validTrialOutcomes)
        if any(ismember(current_outcome,validTrialOutcomes{i_validType}))
            outcomeFlag(iTrial,i_validType) = true;   % this could be slightly inaccurate, but most trials only have 1 outcome
        end
    end
    
    if isempty(reachData(iTrial).flexion)
        continue;
    end
    
    if ~iscell(reachData(iTrial).flexion) && isnan(reachData(iTrial).flexion)
        continue;
    end
    
    if isempty(reachData(iTrial).flexion{1}) || isempty(reachData(iTrial).flexion_grasp{1})
        continue;
    end
    end_flex(iTrial) = reachData(iTrial).flexion{1}(end);
    end_flex_grasp(iTrial) = reachData(iTrial).flexion_grasp{1}(end);
end

end_flex = (end_flex*pi)/180;
end_flex_grasp = (end_flex_grasp*pi)/180;

for i_outcome = 1 : length(validTrialOutcomes)
    mean_flex(i_outcome) = nancirc_mean(end_flex(outcomeFlag(:,i_outcome)));
    mean_flex_grasp(i_outcome) = nancirc_mean(end_flex_grasp(outcomeFlag(:,i_outcome)));
    MRL_flex(i_outcome) = nancirc_r(end_flex(outcomeFlag(:,i_outcome)));
    MRL_flex_grasp(i_outcome) = nancirc_r(end_flex_grasp(outcomeFlag(:,i_outcome)));
end