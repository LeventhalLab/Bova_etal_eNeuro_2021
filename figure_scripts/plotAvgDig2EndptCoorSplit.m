function plotAvgDig2EndptCoorSplit(learner_summary,nonLearner_summary,i_coor,learning_summary)

% plots average endpoint of digit 2 in x, y, or z direction (set by
% i_coor) for learners, non-learners, and all rats combined

lData = learner_summary.mean_dig2_endPt_reach(:,:,i_coor); % pull out endpoint data from selected coordinate direction
nlData = nonLearner_summary.mean_dig2_endPt_reach(:,:,i_coor);
allData = learning_summary.mean_dig2_endPt_reach(:,:,i_coor);

if i_coor == 3 || i_coor == 2   % flip z and y axes
    lData = lData*-1;
    nlData = nlData*-1;
    allData = allData*-1;
end

avgL = nanmean(lData);  % calculate average learners
numDataPtsL = sum(~isnan(lData),1);
errbarsL = nanstd(lData,0,1)./sqrt(numDataPtsL);    % calculate s.e.m.

avgNL = nanmean(nlData);  % calculate average non-learners
numDataPtsNL = sum(~isnan(nlData),1);
errbarsNL = nanstd(nlData,0,1)./sqrt(numDataPtsNL);    % calculate s.e.m.

avgAll = nanmean(allData);  % calculate average all rats

% set marker sizes
avgMarkerSize = 40;
% set plot colors
avgColor = [0/255 102/255 0/255];
avgColorNL = [226/255 88/255 148/255];

% plot data
line([.5 10.5],[0 0],'Color','k','HandleVisibility','off')   % plot a line at 0 (pellet position)
hold on
line(1:10,avgAll,'Color','k','lineWidth',5) % plot all rats average
scatter(1:10,avgL,avgMarkerSize,'filled','MarkerEdgeColor',avgColor,'MarkerFaceColor',avgColor);  % plot average learners
e = errorbar(1:10,avgL,errbarsL,'linestyle','none','HandleVisibility','off');   % add error bars
e.Color = avgColor;
scatter(1:10,avgNL,avgMarkerSize,'filled','MarkerEdgeColor',avgColorNL,'MarkerFaceColor',avgColorNL);  % plot average non-learners
e1 = errorbar(1:10,avgNL,errbarsNL,'linestyle','none','HandleVisibility','off');   % add error bars
e1.Color = avgColorNL;

if i_coor == 1  % set y axis limits
    yMin = -10;
    yMax = 2;
    spVal = 0;
elseif i_coor == 2
    yMin = 0;
    yMax = 16;
    spVal = 8;
else
    yMin = -10;
    yMax = 10;
    spVal = 0;
    legend('all rats','learners','non-learners','Location','south')
end 

% figure properties
ylabel({'reach';'endpoint (mm)'},'FontSize',10)
xlabel('session number')
set(gca,'ylim',[yMin yMax],'ytick',[yMin spVal yMax]);
set(gca,'xlim',[.5 10.5]);
set(gca,'xtick',[2 4 6 8 10]);
set(gca,'FontSize',10);
box off