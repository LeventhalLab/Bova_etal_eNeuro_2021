function plotPercentInvalPoints(invalPointsAllRats)

% plots the percent of frames from reach start to grasp end that were
% mislabeled by DLC for paw dorsum and digit tips on Days 1 and 10

num_rats = length(invalPointsAllRats);

for i_rat = 1 : num_rats
    
    num_trials_first = size(invalPointsAllRats(i_rat).firstSess,3); % pull out number of trials in sessions 1 and 10
    num_trials_last = size(invalPointsAllRats(i_rat).lastSess,3);
    
    for i_trial = 1 : num_trials_first   % count the number of invalid frames (ones) for each trial and calculate percent
        numInval = sum(invalPointsAllRats(i_rat).firstSess(:,:,i_trial),2,'omitnan');   
        numPts = sum(~isnan(invalPointsAllRats(i_rat).firstSess(1,:,i_trial)),2);
        percentInval(:,i_trial) = (numInval/numPts)*100;        
    end
    
    for i_trial = 1 : num_trials_last        
        numInval = sum(invalPointsAllRats(i_rat).lastSess(:,:,i_trial),2,'omitnan');
        numPts = sum(~isnan(invalPointsAllRats(i_rat).lastSess(1,:,i_trial)),2);
        percentInvalLast(:,i_trial) = (numInval/numPts)*100;        
    end
    
    firstSessPercInval(:,i_rat) = nanmean(percentInval,2);  % calculate average for session
    lastSessPercInval(:,i_rat) = nanmean(percentInvalLast,2);
    
    clear percentInval
    clear percentInvalLast
end

avgData(:,1) = nanmean(firstSessPercInval,2);   % calculate average across rats
avgData(:,2) = nanmean(lastSessPercInval,2);

numDataPoints(:,1) = sum(~isnan(firstSessPercInval(:,:)),2);    % calculate s.e.m.
numDataPoints(:,2) = sum(~isnan(lastSessPercInval(:,:)),2);
errBars(:,1) = nanstd(firstSessPercInval(:,:),0,2)./sqrt(numDataPoints(:,1));        
errBars(:,2) = nanstd(lastSessPercInval(:,:),0,2)./sqrt(numDataPoints(:,2));   

% set colors
part_colors = {[147/255 169/255 209/255] [183/255 108/255 164/255] ...
    [228/255 187/255 37/255] [136/255 176/255 75/255] [81/266 91/255 135/255]};

for i_part = 1 : 5   % plot data
    errorbar(avgData(i_part,:),errBars(i_part,:),'Color',part_colors{i_part},'LineWidth',2)
    hold on
end

% figure properties
xticks([1 2])
set(gca,'xlim',[.9 2.1],'XTickLabels',[{'day 1'} {'day 10'}])
set(gca,'ylim',[0 25])
ylabel({'% frames'; 'mislabeled'})
box off

legend('dig1','dig2','dig3','dig4','hand','Location','northwest')
        