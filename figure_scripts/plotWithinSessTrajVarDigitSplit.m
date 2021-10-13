function plotWithinSessTrajVarDigitSplit(slidingWindowKinematics,session,learningRats,num_bins)

% plots within session changes in trajectory variability (digit 2) 
% learners, non-learners

numRatsTotal = size(slidingWindowKinematics,2); % get number rats for each group
numRats_l = size(learningRats,2);
nl_rats = 1:numRatsTotal;
nl_rats(learningRats) = [];
numRats_n = size(nl_rats,2);

ratCt = 1;  % pull out data - learners
for i_rat = learningRats
    varData_l(:,ratCt) = slidingWindowKinematics(i_rat).digTrajVar(:,session,:);
    ratCt = ratCt+1;
end 

ratCt = 1;  % pull out data - non-learners
for i_rat = nl_rats
    varData_n(:,ratCt) = slidingWindowKinematics(i_rat).digTrajVar(:,session,:);
    ratCt = ratCt+1;
end 

trajData_l = NaN(num_bins,numRats_l);   % trajectory variability data
trajData_n = NaN(num_bins,numRats_n);

for i_rat = 1 : numRats_l   % put data into format easy to plot
    for i_trial = 1:num_bins
        trajData_l(i_trial,i_rat) = varData_l(i_trial,i_rat);
        if isnan(trajData_l(i_trial,i_rat)) % if rat drops out (i.e. no more trials) carry last score forward
            lastDataPt = ~isnan(varData_l(:,i_rat)); 
            rowNum = find(lastDataPt == 1,1,'last'); % find last data point
            if isempty(rowNum)
                continue
            else
            trajData_l(i_trial,i_rat) = varData_l(rowNum,i_rat);
            end
        end      
    end
end

for i_rat = 1 : numRats_n   % put data into format easy to plot
    for i_trial = 1:num_bins
        trajData_n(i_trial,i_rat) = varData_n(i_trial,i_rat);
        if isnan(trajData_n(i_trial,i_rat)) % if rat drops out (i.e. no more trials) carry last score forward
            lastDataPt = ~isnan(varData_n(:,i_rat)); 
            rowNum = find(lastDataPt == 1,1,'last'); % find last data point
            if isempty(rowNum)
                continue
            else
            trajData_n(i_trial,i_rat) = varData_n(rowNum,i_rat);
            end
        end      
    end
end

numDataPts_l = sum(~isnan(trajData_l),2);
avgData_l = nanmean(trajData_l,2); % calculate average learners
errbars(:,1) = nanstd(trajData_l,0,2)./sqrt(numDataPts_l); % calculate s.e.m.

numDataPts_n = sum(~isnan(trajData_n),2);
avgData_n = nanmean(trajData_n,2); % calculate average non-learners
errbars(:,2) = nanstd(trajData_n,0,2)./sqrt(numDataPts_n); % calculate s.e.m.

% color
l_color = [0/255 102/255 0/255];
n_color = [226/255 88/255 148/255];

% plot data
l = shadedErrorBar(1:num_bins,avgData_l,errbars(:,1),{'color',l_color,'linewidth',1.5,'linestyle','-'});
hold on
n = shadedErrorBar(1:num_bins,avgData_n,errbars(:,2),{'color',n_color,'linewidth',1.5,'linestyle','-'});

% figure properties
set(gca,'ylim',[2 8]);
set(gca,'ytick',[2 5 8]);
ylabel({'mean dist. from'; 'avg. trajectory (mm)'})
xlabel(session,'FontSize',10)
set(gca,'xlim',[.5 num_bins+.5]);
set(gca,'xtick',[15 30],'FontSize',10);
set(gca,'FontSize',10);
box off