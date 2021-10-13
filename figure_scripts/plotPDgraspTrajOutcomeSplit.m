function plotPDgraspTrajOutcomeSplit(exptOutcomeSummary,group)

% plots grasp traj. var. for successful vs. failed reaches (reach)

script_findLearners % get learners vs. non-learners
allRats = 1:14;
allRats(learningRats) = [];
nonLearningRats = allRats;

if group == 1   % set colors, pull out data
    succColor = [0/255 102/255 0/255];
    data = exptOutcomeSummary.mean_dist_from_pd_trajectory_grasp(:,:,learningRats);
else
    succColor = [226/255 88/255 148/255]; 
    data = exptOutcomeSummary.mean_dist_from_pd_trajectory_grasp(:,:,nonLearningRats);
end
failColor = 'k';

avgData = NaN(10,7);
for i_outcome = 1:7 % average data for each outcome type
    for i_sess = 1:10      
        avgData(i_sess,i_outcome) = nanmean(data(i_sess,i_outcome,:));        
    end 
end 

errBars = NaN(10,7);
for i_outcome = 1:7 % calculate s.e.m. for each outcome type
    for i_sess = 1:10
        numDataPoints = sum(~isnan(data(i_sess,i_outcome,:)));
        errBars(i_sess,i_outcome) = nanstd(data(i_sess,i_outcome,:),0)./sqrt(numDataPoints);        
    end 
end 

% set marker sizes
avgMarkerSize = 45;

% plot data
scatter(1:10,avgData(1:10,2),avgMarkerSize,'MarkerEdgeColor',succColor,'MarkerFaceColor',succColor);
hold on
e = errorbar(1:10,avgData(1:10,2),errBars(1:10,2),'linestyle','none','HandleVisibility','off');
e.Color = succColor;
scatter(1:10,avgData(1:10,4),avgMarkerSize,'MarkerEdgeColor',failColor,'MarkerFaceColor',failColor);
e1 = errorbar(1:10,avgData(1:10,4),errBars(1:10,4),'linestyle','none','HandleVisibility','off');
e1.Color = failColor;

%figure properties
box off
set(gca,'xlim',[.5 10.5],'ylim',[1 7],'ytick',[1 4 7]);
set(gca,'xtick',[2:2:10]);
set(gca,'FontSize',10);
ylabel({'trajectory variability'})
xlabel('session number')

end