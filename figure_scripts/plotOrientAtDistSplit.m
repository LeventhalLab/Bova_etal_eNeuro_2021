function plotOrientAtDistSplit(learner_summary,nonLearner_summary,dataPt)

% plots paw orientation at selected z-digit2 value for 10 sessions
% (learners, non-learners, and all rats combined)

numSessions = size(learner_summary.mean_aperture_traj,2);
data = (learner_summary.mean_orientation_traj*180)/pi;  % pull in data & convert to degrees
dataN = (nonLearner_summary.mean_orientation_traj*180)/pi;

selData = data(:,:,dataPt); % pull out data at specific z-digit2 value, learners
selDataN = dataN(:,:,dataPt); % pull out data at specific z-digit2 value, non-learners
allData = [selData;selDataN];   % combine data for all rats
avgData = nanmean(selData,1);   % calculate average - learners
avgDataN = nanmean(selDataN,1);   % calculate average - non-learners
avgDataAll = nanmean(allData,1);    % calculate average - all rats
numDataPts = sum(~isnan(selData),1);
numDataPtsN = sum(~isnan(selDataN),1);
errbars = nanstd(selData,0,1)./sqrt(numDataPts);    % calculate s.e.m. - learners
errbarsN = nanstd(selDataN,0,1)./sqrt(numDataPtsN);    % calculate s.e.m. - non-learners

% set marker size, plot colors
avgMarkerSize = 45;
avgColor = [0/255 102/255 0/255];
avgNLColor = [226/255 88/255 148/255];

line(1:10,avgDataAll,'Color','k','lineWidth',5) % plot average all rats
hold on
scatter(1:numSessions,avgData,avgMarkerSize,'MarkerEdgeColor',avgColor,'MarkerFaceColor',avgColor); % plot average - learners
e = errorbar(1:10,avgData,errbars,'linestyle','none');
e.Color = avgColor;
scatter(1:numSessions,avgDataN,avgMarkerSize,'MarkerEdgeColor',avgNLColor,'MarkerFaceColor',avgNLColor); % plot average - non-learners
en = errorbar(1:10,avgDataN,errbarsN,'linestyle','none');
en.Color = avgNLColor;

% figure properties
ylabel('\theta (degrees)')
xlabel('session number')
set(gca,'ylim',[30 70],'ytick',[30 50 70]);
set(gca,'xlim',[.5 10.5]);
set(gca,'xtick',[2:2:10]);
set(gca,'FontSize',10);
box off