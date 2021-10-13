function plotAverageVariablityGraspDigSplit(learner_summary,nonLearner_summary,learning_summary)

% plots average grasp trajectory variability of digit 2 across sessions
% (learners, non-learners, and all rats combined)

distData = learner_summary.mean_dig_dist_from_traj_grasp(:,:,:,2);  % pull out data for digit 2
distDataNL = nonLearner_summary.mean_dig_dist_from_traj_grasp(:,:,:,2);
allData = learning_summary.mean_dig_dist_from_traj_grasp(:,:,:,2);

numSessions = size(distData,3);

avgDistTraj = squeeze(nanmean(distData,2)); % calculate average distance from average trajectory (for each point along the trajectory)
avgDistSession = nanmean(avgDistTraj,1);    % average over entire trajectory (all points)
numDataPts = sum(~isnan(avgDistTraj),1);
errbars(1,:) = nanstd(avgDistTraj,0,1)./sqrt(numDataPts);   % calculate s.e.m.

avgDistTrajNL = squeeze(nanmean(distDataNL,2)); % calculate average distance from average trajectory (for each point along the trajectory)
avgDistSessionNL = nanmean(avgDistTrajNL,1);    % average over entire trajectory (all points)
numDataPtsNL = sum(~isnan(avgDistTrajNL),1);
errbarsNL(1,:) = nanstd(avgDistTrajNL,0,1)./sqrt(numDataPtsNL);   % calculate s.e.m.

avgAllTraj = squeeze(nanmean(allData,2));   % calculate average of all rats combined
avgAllSess = nanmean(avgAllTraj,1);

% set colors
learn_color = [0/255 102/255 0/255];
nl_color = [226/255 88/255 148/255];
avgMarkerSize = 45;

line(1:10,avgAllSess,'Color','k','lineWidth',5) % plot average of all rats
hold on
scatter(1:numSessions,avgDistSession(1:numSessions),avgMarkerSize,'MarkerEdgeColor',learn_color,'MarkerFaceColor',learn_color); % plot average learners
e = errorbar(1:10,avgDistSession,errbars(1,:),'linestyle','none','HandleVisibility','off');
e.Color = learn_color;
scatter(1:numSessions,avgDistSessionNL(1:numSessions),avgMarkerSize,'MarkerEdgeColor',nl_color,'MarkerFaceColor',nl_color); % plot average non-learners
e1 = errorbar(1:10,avgDistSessionNL,errbarsNL(1,:),'linestyle','none','HandleVisibility','off');
e1.Color = nl_color;

% figure properties
box off
set(gca,'ylim',[2 8]);
set(gca,'ytick',[2 5 8]);
ylabel({'mean dist. from'; 'avg. trajectory (mm)'})
xlabel('session number')
set(gca,'xlim',[.5 10.5]);
set(gca,'xtick',0:2:10);
set(gca,'FontSize',10);