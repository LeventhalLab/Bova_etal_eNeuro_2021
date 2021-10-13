function plotAvgEndOrientSplit(learner_summary,nonLearner_summary,learning_summary)

% plot average paw orientation at reach end (learners, non-learners, all
% rats combined)

orientL = (learner_summary.mean_end_orientations*180)/pi;   % pull out data and convert to degrees
orientN = (nonLearner_summary.mean_end_orientations*180)/pi;
orientA = (learning_summary.mean_end_orientations*180)/pi;

num_sess = size(orientL,1);

numDataPtsL = sum(~isnan(orientL),2);
errbarsL = nanstd(orientL,0,2)./sqrt(numDataPtsL);     % calculate s.e.m.
avgL = nanmean(orientL,2);    % average across rats learners

numDataPtsN = sum(~isnan(orientN),2);
errbarsN = nanstd(orientN,0,2)./sqrt(numDataPtsN);     % calculate s.e.m.
avgN = nanmean(orientN,2);    % average across rats non-learners

avgA = nanmean(orientA,2);  % average across all rats

% marker size, colors
avgMarkerSize = 45;
avgColor = [0/255 102/255 0/255];
avgNLColor = [226/255 88/255 148/255];

line(1:10,avgA,'Color','k','lineWidth',5)   % plot average all rats
hold on
scatter(1:num_sess,avgL,avgMarkerSize,'MarkerEdgeColor',avgColor,'MarkerFaceColor',avgColor);    % plot average data learners
e = errorbar(1:10,avgL,errbarsL,'linestyle','none');
e.Color = avgColor;
scatter(1:num_sess,avgN,avgMarkerSize,'MarkerEdgeColor',avgNLColor,'MarkerFaceColor',avgNLColor);    % plot average data non-learners
en = errorbar(1:10,avgN,errbarsN,'linestyle','none');
en.Color = avgNLColor;

% figure properties
ylabel({'\theta at reach'; 'end (degrees)'})
xlabel('session number')
set(gca,'ylim',[30 60],'ytick',[30 45 60]);
set(gca,'xlim',[.5 10.5]);
set(gca,'xtick',[2:2:10]);
set(gca,'FontSize',10);
box off
