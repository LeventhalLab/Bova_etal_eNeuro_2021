function plotOrientCoordinationSplit(learner_summary,nonLearner_summary,dataPt,group)

% plots paw orientation as a function of z-digit2 position (learners - group 1;
% non-learners - group 2)

if group == 1   % pull out data, set colors for lines, set min number of rats required to plot average for each z-digit2 value
    data = (learner_summary.mean_orientation_traj*180)/pi;
    sessCol = {[173/255 239/255 201/255] [173/255 239/255 201/255] [116/255 226/255 163/255] [116/255 226/255 163/255]...
    [62/255 215/255 128/255] [62/255 215/255 128/255] [26/255 182/255 94/255] [26/255 182/255 94/255]...
    [11/255 129/255 62/255] [11/255 129/255 62/255]};  
    min_num = 3;
else
    data = (nonLearner_summary.mean_orientation_traj*180)/pi;
    sessCol = {[255/255 153/255 204/255] [255/255 153/255 204/255] [255/255 102/255 178/255] [255/255 102/255 178/255]...
    [255/255 51/255 153/255] [255/255 51/255 153/255] [255/255 0/255 172/255] [255/255 0/255 172/255]...
    [204/255 0/255 102/255] [204/255 0/255 102/255]}; 
    min_num = 4;
end

numSessions = size(data,2);

% calculate averages
for i = 1:size(data,3)
    numDataPts = sum(~isnan(data(:,:,i)),1);
    avgData(:,i) = nanmean(data(:,:,i));      
    for i_sess = 1:numSessions
        if numDataPts(1,i_sess) < min_num % does not plot if less than min num rats' trajectories reach this z coordinate (to avoid sudden jumps in average)
            avgData(i_sess,i) = NaN;
        end 
    end  
end

for i_sess = 1:numSessions  % plot data
    plot(avgData(i_sess,:),'Color',sessCol{i_sess},'LineWidth',1.5);
    hold on
end

% figure properties
minValue = 30;
maxValue = 70;

line([201 201],[minValue maxValue],'Color','k') % add line at pellet
line([dataPt dataPt],[minValue maxValue],'Color','k','LineStyle','--')

box off
ylabel('\theta (degrees)')
xlabel('z_{digit2} (mm)')
set(gca,'ylim',[minValue maxValue]);
set(gca,'xlim',[50 350]);
set(gca,'ytick',[30 50 70]);
set(gca,'xtick',[50 201 231 350]);
set(gca,'xticklabels',[-15 0 3 15]);
set(gca,'FontSize',10);