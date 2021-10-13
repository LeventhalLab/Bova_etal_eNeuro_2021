function plotAvgEndFlexSplit(learner_summary,nonLearner_summary,learning_summary)

% plot average digit flexion at reach end (learners, non-learners, all rats
% combined)

flexL = (learner_summary.mean_end_flex*180)/pi; % pull out data and convert to degrees
flexN = (nonLearner_summary.mean_end_flex*180)/pi;
flexA = (learning_summary.mean_end_flex*180)/pi;

num_sess = size(flexL,1);

numDataPtsL = sum(~isnan(flexL),2);
errbarsL = nanstd(flexL,0,2)./sqrt(numDataPtsL);     % calculate s.e.m.
avgL = nanmean(flexL,2);    % average across rats learners

numDataPtsN = sum(~isnan(flexN),2);
errbarsN = nanstd(flexN,0,2)./sqrt(numDataPtsN);     % calculate s.e.m.
avgN = nanmean(flexN,2);    % average across rats non-learners

avgA = nanmean(flexA,2);    % average across all rats

% set marker size, colors
avgMarkerSize = 45;
avgColor = [0/255 102/255 0/255];
avgNLColor = [226/255 88/255 148/255];

line(1:10,avgA,'Color','k','lineWidth',5)   % plot average all rats
hold on
scatter(1:num_sess,avgL,avgMarkerSize,'MarkerEdgeColor',avgColor,'MarkerFaceColor',avgColor);    % plot average learners
e = errorbar(1:10,avgL,errbarsL,'linestyle','none');
e.Color = avgColor;
scatter(1:num_sess,avgN,avgMarkerSize,'MarkerEdgeColor',avgNLColor,'MarkerFaceColor',avgNLColor);    % plot average non-learners
en = errorbar(1:10,avgN,errbarsN,'linestyle','none');
en.Color = avgNLColor;

% figure properties
ylabel({'\delta at reach'; 'end (degrees)'})
xlabel('day number')
set(gca,'ylim',[15 35],'ytick',[15 25 35]);
set(gca,'xlim',[.5 10.5]);
set(gca,'xtick',[2:2:10]);
set(gca,'FontSize',10);
box off
