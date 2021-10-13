function plotAvgEndAperSplit(learner_summary,nonLearner_summary,learning_summary)

% plots average aperture at reach end for 10 sessions (learners,
% non-learners, all rats combined)

aperL = learner_summary.mean_end_aperture;  % pull out data
aperN = nonLearner_summary.mean_end_aperture;
aperA = learning_summary.mean_end_aperture;

num_sess = size(aperL,1);

numDataPtsL = sum(~isnan(aperL),2);
errbarsL = nanstd(aperL,0,2)./sqrt(numDataPtsL);     % calculate s.e.m.
avgL = nanmean(aperL,2);    % average learners

numDataPtsN = sum(~isnan(aperN),2);
errbarsN = nanstd(aperN,0,2)./sqrt(numDataPtsN);     % calculate s.e.m.
avgN = nanmean(aperN,2);    % average non-learners

avgA = nanmean(aperA,2);    % average all rats

% marker sizes, colors
avgMarkerSize = 45;
avgColor = [0/255 102/255 0/255];
avgNLColor = [226/255 88/255 148/255];

line(1:10,avgA,'Color','k','lineWidth',5)   % plot average all rats
hold on
scatter(1:num_sess,avgL,avgMarkerSize,'MarkerEdgeColor',avgColor,'MarkerFaceColor',avgColor);    % plot average data - learners
e = errorbar(1:10,avgL,errbarsL,'linestyle','none');
e.Color = avgColor;
scatter(1:num_sess,avgN,avgMarkerSize,'MarkerEdgeColor',avgNLColor,'MarkerFaceColor',avgNLColor);    % plot average data - non-learners
en = errorbar(1:10,avgN,errbarsN,'linestyle','none');
en.Color = avgNLColor;

% figure properties
ylabel({'aperture at'; 'reach end (mm)'})
xlabel('session number')
set(gca,'ylim',[11 17],'ytick',[11 14 17]);
set(gca,'xlim',[.5 10.5]);
set(gca,'xtick',[2:2:10]);
set(gca,'FontSize',10);
box off
