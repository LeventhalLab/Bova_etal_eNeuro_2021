function plotReachDurationSplit(learner_summary,nonLearner_summary,learning_summary)

% plots the average duration of reaches across session for learners,
% non-learners, and all rats

data = learner_summary.mean_reach_dur;  % learners data
data_nl = nonLearner_summary.mean_reach_dur;    % non-learners data
data_all = learning_summary.mean_reach_dur; % all rat data

avgData = nanmean(data,2);  % calculate average learners
numDataPts = sum(~isnan(data),2);
errbars = nanstd(data,0,2)./sqrt(numDataPts);   % calculate s.e.m.

avgDataNL = nanmean(data_nl,2);  % calculate average non-learners
numDataPtsNL = sum(~isnan(data_nl),2);
errbarsNL = nanstd(data_nl,0,2)./sqrt(numDataPtsNL);   

avgDataAll = nanmean(data_all,2);  % calculate average all rats

% set plot colors
avgColor = [0/255 102/255 0/255];
avgColorNL = [226/255 88/255 148/255];
% set marker sizes
avgMarkerSize = 45;

line(1:10,avgDataAll,'Color','k','lineWidth',5) % plot all rats average
hold on     % plot learners average
scatter(1:10,avgData,avgMarkerSize,'MarkerEdgeColor',avgColor,'MarkerFaceColor',avgColor);  % plot average data
e = errorbar(1:10,avgData,errbars,'linestyle','none');
e.Color = avgColor;
% plot non-learners average
scatter(1:10,avgDataNL,avgMarkerSize,'MarkerEdgeColor',avgColorNL,'MarkerFaceColor',avgColorNL);  % plot average data
en = errorbar(1:10,avgDataNL,errbarsNL,'linestyle','none');
en.Color = avgColorNL;

% figure properties
ylabel('reach duration (ms)','FontSize',10)
xlabel('day number')
set(gca,'ylim',[30 90],'ytick',[30 60 90]);
set(gca,'xlim',[.5 10.5]);
set(gca,'xtick',[2 4 6 8 10]);
set(gca,'FontSize',10);
box off
