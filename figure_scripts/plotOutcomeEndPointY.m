function plotOutcomeEndPointY(exptOutcomeSummary)

% plots reach endpoint (Y) for successful vs. failed reaches

outcomeColors = {[88/255 199/255 61/255],[107/255 141/255 83/255],'k',[175/255 31/255 36/255],[.99 .41 .39], [.63 .63 .63]};

data = exptOutcomeSummary.mean_dig2_endPt_y*-1;

for i_outcome = 1:7     % calculate average for each outcome type
    for i_sess = 1:10      
        avgData(i_sess,i_outcome) = nanmean(data(i_sess,i_outcome,:));        
    end 
end 
    
for i_outcome = 1:7     % calculate s.e.m. for each outcome type
    for i_sess = 1:10
        numDataPoints = sum(~isnan(exptOutcomeSummary.mean_dig2_endPt_z(i_sess,i_outcome,:)));
        errBars(i_sess,i_outcome) = nanstd(exptOutcomeSummary.mean_dig2_endPt_z(i_sess,i_outcome,:),0)./sqrt(numDataPoints);        
    end 
end 

% set marker sizes
avgMarkerSize = 45;

for i = [2 4]      % plot successful and failed reaches 
    scatter(1:10,avgData(1:10,i),avgMarkerSize,'MarkerEdgeColor',outcomeColors{i-1},'MarkerFaceColor',outcomeColors{i-1});
    hold on
    e = errorbar(1:10,avgData(1:10,i),errBars(1:10,i),'linestyle','none','HandleVisibility','off');
    e.Color = outcomeColors{i-1};
end

%figure properties
minValue = 0;
maxValue = 10;
box off
set(gca,'xlim',[.5 10.5],'ylim',[minValue maxValue],'ytick',[0 5 10]);
set(gca,'xtick',[2:2:10]);
set(gca,'FontSize',10);
ylabel({'final y'; 'w.r.t pellet (mm)'})
xlabel('session number')
legend('hit','miss')
legend box off