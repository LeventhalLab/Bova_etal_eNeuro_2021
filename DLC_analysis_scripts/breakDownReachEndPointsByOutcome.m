function [mean_pd_endPt_reach,mean_pd_endPt_grasp,cov_pd_endPts_reach,cov_pd_endPts_grasp,...
    mean_dig_endPts_reach,mean_dig_endPts_grasp,cov_dig_endPts_reach,cov_dig_endPts_grasp,...
    mean_dig_endPts_reach_fromPaw,mean_dig_endPts_grasp_fromPaw,cov_dig_endPts_reach_fromPaw,cov_dig_endPts_grasp_fromPaw] = ...
    breakDownReachEndPointsByOutcome(reachData,sessionSummary,validTrialOutcomes)

num_trials = length(reachData);
num_possOutcomes = length(validTrialOutcomes);

pd_endPts_reach = NaN(num_trials,3);
dig_endPts_reach = NaN(num_trials,4,3);
dig_endPts_reach_fromPaw = NaN(num_trials,4,3);

mean_pd_endPt_reach = zeros(num_possOutcomes,3);
mean_dig_endPts_reach = zeros(num_possOutcomes,4,3);
mean_dig_endPts_reach_fromPaw = zeros(num_possOutcomes,4,3);

cov_pd_endPts_reach = NaN(num_possOutcomes,3,3);
cov_dig_endPts_reach = NaN(num_possOutcomes,4,3,3);
cov_dig_endPts_reach_fromPaw = NaN(num_possOutcomes,4,3,3);

pd_endPts_grasp = NaN(num_trials,3);
dig_endPts_grasp = NaN(num_trials,4,3);
dig_endPts_grasp_fromPaw = NaN(num_trials,4,3);

mean_pd_endPt_grasp = zeros(num_possOutcomes,3);
mean_dig_endPts_grasp = zeros(num_possOutcomes,4,3);
mean_dig_endPts_grasp_fromPaw = zeros(num_possOutcomes,4,3);

cov_pd_endPts_grasp = NaN(num_possOutcomes,3,3);
cov_dig_endPts_grasp = NaN(num_possOutcomes,4,3,3);
cov_dig_endPts_grasp_fromPaw = NaN(num_possOutcomes,4,3,3);

outcomeFlag = false(num_trials,length(validTrialOutcomes));
for iTrial = 1 : num_trials

    current_outcome = reachData(iTrial).trialScores;
    
    for i_validType = 1 : length(validTrialOutcomes)
        if any(ismember(current_outcome,validTrialOutcomes{i_validType}))
            outcomeFlag(iTrial,i_validType) = true;   % this could be slightly inaccurate, but most trials only have 1 outcome
        end
    end
    
    if ~isempty(reachData(iTrial).reachEnds)
        pd_endPts_reach(iTrial,:) = reachData(iTrial).pdEndPoints_reach(1,:);
        dig_endPts_reach(iTrial,:,:) = reachData(iTrial).dig_endPoints_reach(1,:,:);
        dig_endPts_reach_fromPaw(iTrial,:,:) =  permute(sessionSummary.dig_endPts_reach_fromPaw(iTrial,:,:),[1 3 2]);
    end
    if ~isnan(reachData(iTrial).graspEnds)
        if ~isempty(reachData(iTrial).pdEndPoints_graspStart)
            pd_endPts_grasp(iTrial,:) = reachData(iTrial).pdEndPoints_graspStart(1,:);
            dig_endPts_grasp(iTrial,:,:) = reachData(iTrial).dig_endPoints_grasp(1,:,:);
            dig_endPts_grasp_fromPaw(iTrial,:,:) = permute(sessionSummary.dig_endPts_grasp_fromPaw(iTrial,:,:),[1 3 2]);
        end 
    end 
    
end

for i_outcome = 1 : length(validTrialOutcomes)
    mean_pd_endPt_reach(i_outcome,:) = nanmean(pd_endPts_reach(outcomeFlag(:,i_outcome),:));
    cov_pd_endPts_reach(i_outcome,:,:) = nancov(pd_endPts_reach(outcomeFlag(:,i_outcome),:));
    mean_pd_endPt_grasp(i_outcome,:) = nanmean(pd_endPts_grasp(outcomeFlag(:,i_outcome),:));
    cov_pd_endPts_grasp(i_outcome,:,:) = nancov(pd_endPts_grasp(outcomeFlag(:,i_outcome),:));
    
    for i_dig = 1 : 4
        cur_dig_endPts_reach = squeeze(dig_endPts_reach(outcomeFlag(:,i_outcome),i_dig,:));
        mean_dig_endPts_reach(i_outcome,i_dig,:) = nanmean(cur_dig_endPts_reach,1);
        cov_dig_endPts_reach(i_outcome,i_dig,:,:) = nancov(cur_dig_endPts_reach);
        
        cur_dig_endPts_reach_fromPaw = squeeze(dig_endPts_reach_fromPaw(outcomeFlag(:,i_outcome),i_dig,:));
        mean_dig_endPts_reach_fromPaw(i_outcome,i_dig,:) = nanmean(cur_dig_endPts_reach_fromPaw,1);
        cov_dig_endPts_reach_fromPaw(i_outcome,i_dig,:,:) = nancov(cur_dig_endPts_reach_fromPaw);
        
        cur_dig_endPts_grasp = squeeze(dig_endPts_grasp(outcomeFlag(:,i_outcome),i_dig,:));
        mean_dig_endPts_grasp(i_outcome,i_dig,:) = nanmean(cur_dig_endPts_grasp,1);
        cov_dig_endPts_grasp(i_outcome,i_dig,:,:) = nancov(cur_dig_endPts_grasp);
        
        cur_dig_endPts_grasp_fromPaw = squeeze(dig_endPts_grasp_fromPaw(outcomeFlag(:,i_outcome),i_dig,:));
        mean_dig_endPts_grasp_fromPaw(i_outcome,i_dig,:) = nanmean(cur_dig_endPts_grasp_fromPaw,1);
        cov_dig_endPts_grasp_fromPaw(i_outcome,i_dig,:,:) = nancov(cur_dig_endPts_grasp_fromPaw);
    end
end