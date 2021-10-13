function plotWithinSessSuccRateSplit(successRateWithinSession,slidingWindowKinematics,session,learningRats,grp,num_bins)

% plots within session changes in trajectory variability against changes in success rate

numRats = size(successRateWithinSession,2);

if grp == 'l'
    curRats = learningRats;
    numRats = size(curRats,2);
    trajColor = 'k';
    succColor = [0/255 102/255 0/255];
else
    ratL = 1:numRats;
    ratL(learningRats) = [];
    curRats = ratL;
    numRats = size(curRats,2);
    trajColor = 'k';
    succColor = [226/255 88/255 148/255];
end

ratCt = 1;
for i_rat = curRats     % pull out success rate data and variability data for each rat
    succData(:,ratCt) = successRateWithinSession(i_rat).data(:,session,:);
    varData(:,ratCt) = slidingWindowKinematics(i_rat).pdTrajVar(:,session,:);
    ratCt = ratCt+1;
end 

curData = NaN(num_bins,numRats);    % success rate data
trajData = NaN(num_bins,numRats);   % trajectory variability data

for i_rat = 1 : numRats   % put data into format easy to plot
    for i_trial = 1:num_bins
        curData(i_trial,i_rat) = succData(i_trial,i_rat);
        trajData(i_trial,i_rat) = varData(i_trial,i_rat);
        if isnan(curData(i_trial,i_rat)) % if rat drops out (i.e. no more trials) carry last score forward
            lastDataPt = ~isnan(succData(:,i_rat)); 
            rowNum = find(lastDataPt == 1,1,'last'); % find last data point
            if isempty(rowNum)
                continue
            else
            curData(i_trial,i_rat) = succData(rowNum,i_rat); % set current trial to last data point
            trajData(i_trial,i_rat) = varData(rowNum,i_rat);
            end
        end      
    end
end

numDataPts = sum(~isnan(curData),2);
avgData = nanmean(curData,2); % calculate average success rate
errbars(:,1) = nanstd(curData,0,2)./sqrt(numDataPts); % calculate s.e.m.

numDataPts = sum(~isnan(trajData),2);
avgTrajData = nanmean(trajData,2); % calculate average traj. var.
errbars(:,2) = nanstd(trajData,0,2)./sqrt(numDataPts); % calculate s.e.m.

[rho,pval] = corr(avgData,avgTrajData); % calculate r for correlation between success rate and traj. variability

% plot data
yyaxis left     % plot within session changes in trajectory variability
t = shadedErrorBar(1:num_bins,avgTrajData,errbars(:,2),{'color',trajColor,'linewidth',1.5,'linestyle','-'});
set(gca,'ylim',[0 7]);
set(gca,'ytick',[0 3.5 7]);
ylabel({'mean dist. from'; 'avg. trajectory (mm)'})
hold on

yyaxis right    % plot within session changes in success rate
p = shadedErrorBar(1:num_bins,avgData,errbars(:,1),{'color',succColor,'linewidth',1.5,'linestyle','-'});
set(gca,'ylim',[0 1]);
set(gca,'ytick',[0 1]);
ylabel({'first reach'; 'success rate'})

% find sessions with significant negative correlation between success rate
% and trajectory variability; add significance stars
if rho < 0 && pval < .05 && pval >= .01
    scatter(15,1,'*','k')
elseif rho < 0 && pval < .01 && pval >= .001
    scatter(10,1,'*','k')
    scatter(20,1,'*','k')
elseif rho < 0 && pval < .001
    scatter(7,1,'*','k')
    scatter(15,1,'*','k')
    scatter(23,1,'*','k')
end

% figure properties
ax = gca;
ax.YAxis(1).Color = trajColor;
ax.YAxis(2).Color = succColor;
xlabel(session,'FontSize',10)
set(gca,'xlim',[.5 num_bins+.5]);
set(gca,'xtick',[15 30],'FontSize',10);
set(gca,'FontSize',10);
box off