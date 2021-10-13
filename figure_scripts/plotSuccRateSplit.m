function plotSuccRateSplit(learner_summary,nonLearner_summary,learning_summary)

% plots average first reach success rate each session for "learners",
% "non-learners" and all rats combined

learnData = learner_summary.firstReachSuccess*100;  % change success rate to percent
nonlearnData = nonLearner_summary.firstReachSuccess*100;
allData = learning_summary.firstReachSuccess*100;

num_learnRats = size(learnData,2);
num_nonlearnRats = size(nonlearnData,2);
num_sess = size(learnData,1);

for i_rat = 1 : num_learnRats    % if a rat performs fewer than 10 reaches in a session do not include this session in success rate average
    for i_sess = 1 : num_sess        
        if learner_summary.num_trials(i_sess,i_rat) < 10
            learnData(i_sess,i_rat) = NaN;
        end
    end
end

for i_rat = 1 : num_nonlearnRats    % if a rat performs fewer than 10 reaches in a session do not include this session in success rate average
    for i_sess = 1 : num_sess        
        if nonLearner_summary.num_trials(i_sess,i_rat) < 10
            nonlearnData(i_sess,i_rat) = NaN;
        end
    end
end

for i_rat = 1 : num_nonlearnRats + num_learnRats    % if a rat performs fewer than 10 reaches in a session do not include this session in success rate average
    for i_sess = 1 : num_sess        
        if learning_summary.num_trials(i_sess,i_rat) < 10
            allData(i_sess,i_rat) = NaN;
        end
    end
end

avgLearnSucc = nanmean(learnData,2);    % calculate averages
avgNonLearnSucc = nanmean(nonlearnData,2);
avgAll = nanmean(allData,2);

numDataPtsLearn = sum(~isnan(learnData),2);
errbarsLearn = nanstd(learnData,0,2)./sqrt(numDataPtsLearn);    % calculate s.e.m.

numDataPtsNonLearn = sum(~isnan(nonlearnData),2);
errbarsNonLearn = nanstd(nonlearnData,0,2)./sqrt(numDataPtsNonLearn);    % calculate s.e.m.

% set marker sizes
avgMarkerSize = 45;

avgLearnColor = [0/255 102/255 0/255];  % set colors
avgNonLearnColor = [226/255 88/255 148/255];

% plot all rats
line(1:10,avgAll,'Color','k','lineWidth',5)
hold on
% plot "learners" and "non-learners" separately
scatter(1:10,avgLearnSucc,avgMarkerSize,'filled','MarkerEdgeColor',avgLearnColor,'MarkerFaceColor',avgLearnColor); % plot average data learners
scatter(1:10,avgNonLearnSucc,avgMarkerSize,'MarkerEdgeColor',avgNonLearnColor,'MarkerFaceColor',avgNonLearnColor); % plot average data learners

el = errorbar(1:10,avgLearnSucc,errbarsLearn,'linestyle','none');  % add error bars
el.Color = avgLearnColor;
enl = errorbar(1:10,avgNonLearnSucc,errbarsNonLearn,'linestyle','none');  
enl.Color = avgNonLearnColor;

% figure properties
ylabel({'first reach'; 'success rate'},'FontSize',10)
xlabel('day number')
set(gca,'ylim',[0 80],'ytick',[0 40 80]);
set(gca,'xlim',[.5 10.5]);
set(gca,'xtick',[2 4 6 8 10]);
set(gca,'FontSize',10);
box off