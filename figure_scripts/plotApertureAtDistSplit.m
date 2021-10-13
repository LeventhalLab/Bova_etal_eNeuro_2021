function plotApertureAtDistSplit(learner_summary,nonLearner_summary,dataPt)

% plots aperture at selected zdigit2 value for 10 sessions (learners,
% non-learners, and all rats combined)

numSessions = size(learner_summary.mean_aperture_traj,2);
data = learner_summary.mean_aperture_traj;
dataN = nonLearner_summary.mean_aperture_traj;

selData = data(:,:,dataPt); % pull out data at specific zdigit2 value - learners
selDataN = dataN(:,:,dataPt); % pull out data at specific zdigit2 value - non-learners
allData = [selData;selDataN]; % combine data from both groups 
avgData = nanmean(selData,1);   % calculate average - learners
avgDataN = nanmean(selDataN,1);   % calculate average - non-learners
avgDataAll = nanmean(allData,1);    % calculate average - all rats

numDataPts = sum(~isnan(selData),1);
numDataPtsN = sum(~isnan(selDataN),1);
errbars = nanstd(selData,0,1)./sqrt(numDataPts);    % calculate s.e.m. - learners
errbarsN = nanstd(selDataN,0,1)./sqrt(numDataPtsN);    % calculate s.e.m. - non-learners

% set marker size, colors
avgMarkerSize = 45;
avgColor = [0/255 102/255 0/255];
avgNLColor = [226/255 88/255 148/255];

line(1:10,avgDataAll,'Color','k','lineWidth',5) % plot average all rats
hold on
scatter(1:numSessions,avgData,avgMarkerSize,'MarkerEdgeColor',avgColor,'MarkerFaceColor',avgColor); % plot average learners
e = errorbar(1:10,avgData,errbars,'linestyle','none','HandleVisibility','off');
e.Color = avgColor;
scatter(1:numSessions,avgDataN,avgMarkerSize,'MarkerEdgeColor',avgNLColor,'MarkerFaceColor',avgNLColor); % plot average non-learners
en = errorbar(1:10,avgDataN,errbarsN,'linestyle','none');
en.Color = avgNLColor;

% figure properties
ylabel('aperture (mm)')
xlabel('session number')
set(gca,'ylim',[7 13],'ytick',[7 10 13]);
set(gca,'xlim',[.5 10.5]);
set(gca,'xtick',[2:2:10]);
set(gca,'FontSize',10);
box off

legend('all rats','learners','non-learners')
legend box off
legend('Location','northwest')