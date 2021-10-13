function plotAvgEndAperVarSplit(learner_summary,nonLearner_summary,learning_summary)

% plots average std error of aperture at reach end (learners, non-learners,
% and all rats combined)

varDataL = learner_summary.std_end_aperture;    % pull out data
varDataN = nonLearner_summary.std_end_aperture;
varDataA = learning_summary.std_end_aperture;

num_sess = size(varDataL,1);
num_trialsL = learner_summary.num_trials;
num_trialsN = nonLearner_summary.num_trials;
num_trialsA = learning_summary.num_trials;
num_ratsL = size(varDataL,2);
num_ratsN = size(varDataN,2);
num_ratsA = size(varDataA,2);

numDataPtsL = sum(~isnan(varDataL),2);
errbarsL = nanstd(varDataL,0,2)./sqrt(numDataPtsL);    % calculate s.e.m. learners
numDataPtsN = sum(~isnan(varDataN),2);
errbarsN = nanstd(varDataN,0,2)./sqrt(numDataPtsN);    % calculate s.e.m. non-learners

for i_rat = 1 : num_ratsL    % remove sessions with less than 10 trials, learners
    for i_sess = 1 : num_sess
        if num_trialsL(i_sess,i_rat) < 10
            varDataL(i_sess,i_rat) = NaN;
        end
    end
end

for i_rat = 1 : num_ratsN    % remove sessions with less than 10 trials, non-learners
    for i_sess = 1 : num_sess
        if num_trialsN(i_sess,i_rat) < 10
            varDataN(i_sess,i_rat) = NaN;
        end
    end
end

for i_rat = 1 : num_ratsA    % remove sessions with less than 10 trials, all rats
    for i_sess = 1 : num_sess
        if num_trialsA(i_sess,i_rat) < 10
            varDataA(i_sess,i_rat) = NaN;
        end
    end
end

avgVarL = nanmean(varDataL,2);    % calculate average across rats, learners
avgVarN = nanmean(varDataN,2);    % calculate average across rats, non-learners
avgVarA = nanmean(varDataA,2);    % calculate average across all rats

% set marker sizes, colors
avgMarkerSize = 45;
avgColor = [0/255 102/255 0/255];
avgNLColor = [226/255 88/255 148/255];

line(1:10,avgVarA,'Color','k','lineWidth',5)    % plot average all rats
hold on
scatter(1:num_sess,avgVarL,avgMarkerSize,'MarkerEdgeColor',avgColor,'MarkerFaceColor',avgColor);    % plot average data learners
e = errorbar(1:10,avgVarL,errbarsL,'linestyle','none');
e.Color = avgColor;
scatter(1:num_sess,avgVarN,avgMarkerSize,'MarkerEdgeColor',avgNLColor,'MarkerFaceColor',avgNLColor);    % plot average data non-learners
en = errorbar(1:10,avgVarN,errbarsN,'linestyle','none');
en.Color = avgNLColor;

% additional figure properties
ylabel('aperture variance')
xlabel('session number')
set(gca,'ylim',[0 3],'ytick',[0 1.5 3]);
set(gca,'xlim',[.5 10.5]);
set(gca,'xtick',[2:2:10]);
set(gca,'FontSize',10);
box off
