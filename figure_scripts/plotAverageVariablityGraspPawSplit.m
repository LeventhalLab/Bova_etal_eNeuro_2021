function plotAverageVariablityGraspPawSplit(learner_summary,nonLearner_summary,learning_summary)

% plots the average trajectory variability of the paw dorsum (avg. distance
% from avg. session trajectory) during grasp for each session for learners,
% non-learners, and all rats combined

distData = learner_summary.mean_pd_dist_from_traj_grasp;   % learners data 
distDataNL = nonLearner_summary.mean_pd_dist_from_traj_grasp;   % non-learners data
distDataAll = learning_summary.mean_pd_dist_from_traj_grasp;    % all data

numSessions = size(distData,3);

avgDistTraj = squeeze(nanmean(distData,2)); % calculate average distance from average trajectory (for each point along the trajectory)
avgDistSession = nanmean(avgDistTraj,1);    % average over entire trajectory (all points)
numDataPts = sum(~isnan(avgDistTraj),1);
errbars(1,:) = nanstd(avgDistTraj,0,1)./sqrt(numDataPts);   % calculate s.e.m.

avgDistTrajNL = squeeze(nanmean(distDataNL,2));     % same for non-learners
avgDistSessionNL = nanmean(avgDistTrajNL,1);    
numDataPtsNL = sum(~isnan(avgDistTrajNL),1);
errbarsNL(1,:) = nanstd(avgDistTrajNL,0,1)./sqrt(numDataPtsNL);  

avgDistTrajAll = squeeze(nanmean(distDataAll,2));   % average of all rats
avgDistSessionAll = nanmean(avgDistTrajAll,1);   

% set colors
learn_color = [0/255 102/255 0/255];
nl_color = [226/255 88/255 148/255];
avgMarkerSize = 45;

line(1:10,avgDistSessionAll,'Color','k','lineWidth',5)  % plot all rat average
hold on     % plot learners average
scatter(1:numSessions,avgDistSession(1:numSessions),avgMarkerSize,'filled','MarkerEdgeColor',learn_color,'MarkerFaceColor',learn_color);
el = errorbar(1:10,avgDistSession(1:numSessions),errbars,'linestyle','none','HandleVisibility','off');  % add error bars
el.Color = learn_color;
% plot non-learners average
scatter(1:numSessions,avgDistSessionNL(1:numSessions),avgMarkerSize,'filled','MarkerEdgeColor',nl_color,'MarkerFaceColor',nl_color);
el = errorbar(1:10,avgDistSessionNL(1:numSessions),errbarsNL,'linestyle','none','HandleVisibility','off');  % add error bars
el.Color = nl_color;

% figure properties
box off
set(gca,'ylim',[2 7]);
set(gca,'ytick',[2 4.5 7]);
ylabel({'mean dist. from'; 'avg. trajectory (mm)'})
xlabel('session number')
set(gca,'xlim',[.5 10.5]);
set(gca,'xtick',0:2:10);
set(gca,'FontSize',10);

legend('all rats','learners','non-learners','Location','southwest')