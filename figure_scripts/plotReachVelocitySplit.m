function plotReachVelocitySplit(learner_summary,nonLearner_summary,learning_summary)

% plots average reach velocity across sessions for learners, non-learners,
% and all rats

data = learner_summary.mean_pd_v;   % learners data
dataNL = nonLearner_summary.mean_pd_v;  % non-learners data
dataAll = learning_summary.mean_pd_v;   % all rat data

avgData = nanmean(data,2);  % calculate average learners
numDataPts = sum(~isnan(data),2);
errbars = nanstd(data,0,2)./sqrt(numDataPts);   % calculate s.e.m.

avgDataNL = nanmean(dataNL,2);  % calculate average non-learners
numDataPtsNL = sum(~isnan(dataNL),2);
errbarsNL = nanstd(dataNL,0,2)./sqrt(numDataPtsNL);   

avgDataAll = nanmean(dataAll,2);    % calculate average all rats

% set plot colors
avgColor = [0/255 102/255 0/255];
avgNLColor = [226/255 88/255 148/255];
% set marker sizes
avgMarkerSize = 45;

line(1:10,avgDataAll,'Color','k','lineWidth',5) % plot all rat average
hold on     % plot learners average
scatter(1:10,avgData,avgMarkerSize,'MarkerEdgeColor',avgColor,'MarkerFaceColor',avgColor);  % plot average
e = errorbar(1:10,avgData,errbars,'linestyle','none');  % add error bars
e.Color = avgColor;
% plot non-learners average
scatter(1:10,avgDataNL,avgMarkerSize,'MarkerEdgeColor',avgNLColor,'MarkerFaceColor',avgNLColor);  % plot average
en = errorbar(1:10,avgDataNL,errbarsNL,'linestyle','none');  % add error bars
en.Color = avgNLColor;

% figure properties
ylabel({'max reach'; 'velocity (mm/s)'},'FontSize',10)
xlabel('day number')
set(gca,'ylim',[500 1000],'ytick',[500 750 1000]);
set(gca,'xlim',[.5 10.5]);
set(gca,'xtick',[2 4 6 8 10]);
set(gca,'FontSize',10);
box off