function plotWithinSessOrientSplit(slidingWindowKinematics,session,num_bins)

% plots within session changes in aperture at reach end (learners and
% non-learners)

script_findLearners     % find learners vs. non-learners
numRats = size(slidingWindowKinematics,2);
num_ratsL = size(learningRats,2);
num_ratsN = numRats - num_ratsL;
nl_rats = 1 : 14;
nl_rats(learningRats) = [];

ratCt = 1;  % pull out data for learners, convert to degrees
for i_rat = learningRats
    orientData_l(:,ratCt) = (slidingWindowKinematics(i_rat).orientation_reach_end(:,session,:)*180)/pi;
    ratCt = ratCt+1;
end 

ratCt = 1;  % pull out data for non-learners, convert to degrees
for i_rat = nl_rats
    orientData_n(:,ratCt) = (slidingWindowKinematics(i_rat).orientation_reach_end(:,session,:)*180)/pi;
    ratCt = ratCt+1;
end 

data_l = NaN(num_bins,num_ratsL);   
data_n = NaN(num_bins,num_ratsN);

for i_rat = 1 : num_ratsL    % pull out data into new structure for plotting
    for i_trial = 1:num_bins    
        data_l(i_trial,i_rat) = orientData_l(i_trial,i_rat);
        
        if isnan(data_l(i_trial,i_rat)) % if rat drops out (i.e. no more trials) carry last score forward
            lastDataPt = ~isnan(orientData_l(:,i_rat)); 
            rowNum = find(lastDataPt == 1,1,'last'); % find last data point
            if isempty(rowNum)
                continue
            else
            data_l(i_trial,i_rat) = orientData_l(rowNum,i_rat); % set current trial to last data point
            end
        end        
    end
end

for i_rat = 1 : num_ratsN    % pull out data into new structure for plotting
    for i_trial = 1:num_bins    
        data_n(i_trial,i_rat) = orientData_n(i_trial,i_rat);
        
        if isnan(data_n(i_trial,i_rat)) % if rat drops out (i.e. no more trials) carry last score forward
            lastDataPt = ~isnan(orientData_n(:,i_rat)); 
            rowNum = find(lastDataPt == 1,1,'last'); % find last data point
            if isempty(rowNum)
                continue
            else
            data_n(i_trial,i_rat) = orientData_n(rowNum,i_rat); % set current trial to last data point
            end
        end        
    end
end

numDataPts_l = sum(~isnan(data_l),2);
avgData_l = nanmean(data_l,2); % calculate average
errbars_l = nanstd(data_l,0,2)./sqrt(numDataPts_l); % calculate s.e.m.

numDataPts_n = sum(~isnan(data_n),2);
avgData_n = nanmean(data_n,2); % calculate average
errbars_n = nanstd(data_n,0,2)./sqrt(numDataPts_n); % calculate s.e.m.

% color
l_color = [0/255 102/255 0/255];
n_color = [226/255 88/255 148/255];

% plot data
l = shadedErrorBar(1:num_bins,avgData_l,errbars_l,{'color',l_color,'linewidth',1.5,'linestyle','-'});
hold on
n = shadedErrorBar(1:num_bins,avgData_n,errbars_n,{'color',n_color,'linewidth',1.5,'linestyle','-'});

% figure properties
ylabel({'\theta at'; 'reach end (mm)'},'FontSize',10)
xlabel(session)
set(gca,'xlim',[.5 num_bins+.5]);
set(gca,'ylim',[30 60]);
set(gca,'ytick',[30 45 60],'xtick',[15 30]);
set(gca,'FontSize',10);
box off