function plotOutcomeEndPointXsplit(exptOutcomeSummary,group)

% plots reach endpoint of digit2 (X) for successful vs. failed reaches

script_findLearners % find learners vs. non-learners
allRats = 1:14;
allRats(learningRats) = [];
nonLearningRats = allRats;

if group == 1   % set colors, pull out data
    succColor = [0/255 102/255 0/255];
    data = exptOutcomeSummary.mean_dig2_endPt_x(:,:,learningRats);
else
    succColor = [226/255 88/255 148/255]; 
    data = exptOutcomeSummary.mean_dig2_endPt_x(:,:,nonLearningRats);
end
failColor = 'k';

for i_outcome = 1:7 % calculate average endpoint for each outcome type
    for i_sess = 1:10      
        avgData(i_sess,i_outcome) = nanmean(data(i_sess,i_outcome,:));        
    end 
end 

for i_outcome = 1:7 % calculate s.e.m. endpoint for each outcome type
    for i_sess = 1:10
        numDataPoints = sum(~isnan(exptOutcomeSummary.mean_dig2_endPt_z(i_sess,i_outcome,:)));
        errBars(i_sess,i_outcome) = nanstd(exptOutcomeSummary.mean_dig2_endPt_z(i_sess,i_outcome,:),0)./sqrt(numDataPoints);        
    end 
end 

% set marker sizes
avgMarkerSize = 45;

line([.5 10.5],[0 0],'LineWidth',.75,'Color','k','HandleVisibility','off')
hold on

% plot data
scatter(1:10,avgData(1:10,2),avgMarkerSize,'MarkerEdgeColor',succColor,'MarkerFaceColor',succColor);
e = errorbar(1:10,avgData(1:10,2),errBars(1:10,2),'linestyle','none','HandleVisibility','off');
e.Color = succColor;
scatter(1:10,avgData(1:10,4),avgMarkerSize,'MarkerEdgeColor',failColor,'MarkerFaceColor',failColor);
e = errorbar(1:10,avgData(1:10,4),errBars(1:10,4),'linestyle','none','HandleVisibility','off');
e.Color = failColor;

% figure properties
minValue = -6;
maxValue = 2;
box off
set(gca,'xlim',[.5 10.5],'ylim',[minValue maxValue],'ytick',[-6 0 2]);
set(gca,'xtick',[2:2:10]);
set(gca,'FontSize',10);
ylabel({'reach endpoint (mm)'})
xlabel('session number')
legend('hit','miss')
legend box off
legend('Location','southeast')