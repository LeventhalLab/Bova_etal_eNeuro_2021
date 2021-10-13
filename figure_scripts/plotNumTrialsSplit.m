function plotNumTrialsSplit(learner_summary,nonLearner_summary,learning_summary)

% plots the average number of trials per session for "learners",
% "non-learners", and all rats combined 

learnData = learner_summary.num_trials;
nonlearnData = nonLearner_summary.num_trials;

avgLearn = nanmean(learnData,2);    % calculate averages
avgNonLearn = nanmean(nonlearnData,2);
avgAll = nanmean(learning_summary.num_trials,2);

numDataPtsLearn = sum(~isnan(learnData),2);
errbarsLearn = nanstd(learnData,0,2)./sqrt(numDataPtsLearn);    % calculate s.e.m.

numDataPtsNonLearn = sum(~isnan(nonlearnData),2);
errbarsNonLearn = nanstd(nonlearnData,0,2)./sqrt(numDataPtsNonLearn);    % calculate s.e.m.

% set marker sizes
avgMarkerSize = 45;

avgLearnColor = [0/255 102/255 0/255];
avgNonLearnColor = [226/255 88/255 148/255];

% plot average of all rats
line(1:10,avgAll,'Color','k','lineWidth',5)
hold on
% plot "learners" and "non-learners" separately
scatter(1:10,avgLearn,avgMarkerSize,'filled','MarkerEdgeColor',avgLearnColor,'MarkerFaceColor',avgLearnColor); % plot average data learners
scatter(1:10,avgNonLearn,avgMarkerSize,'MarkerEdgeColor',avgNonLearnColor,'MarkerFaceColor',avgNonLearnColor); % plot average data learners

el = errorbar(1:10,avgLearn,errbarsLearn,'linestyle','none','HandleVisibility','off');  % add error bars
el.Color = avgLearnColor;
enl = errorbar(1:10,avgNonLearn,errbarsNonLearn,'linestyle','none','HandleVisibility','off'); 
enl.Color = avgNonLearnColor;

% figure properties
ylabel('number of trials','FontSize',10)
xlabel('day number')
set(gca,'ylim',[0 60],'ytick',[0 30 60]);
set(gca,'xlim',[.5 10.5]);
set(gca,'xtick',[2 4 6 8 10]);
set(gca,'FontSize',10);
box off

legend({'all rats','learners (n=4)','non-learners (n=10)'},'Location','southeast')
legend('boxoff')