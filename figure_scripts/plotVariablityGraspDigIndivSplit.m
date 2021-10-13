function plotVariablityGraspDigIndivSplit(learner_summary,nonLearner_summary,group)

% plots individual rats' average digit 2 grasp trajectory variability over
% sessions (learners (group = 1) and non-learners (group = 2) plotted
% separately)

if group == 1   % pull out data, set plot color
	data = learner_summary.mean_dig_dist_from_traj_grasp(:,:,:,2);
    plot_color = {[0/255 102/255 0/255] [95/255 130/255 226/255] [216/255 85/255 116/255] [212/255 216/255 85/255]};
else
    data = nonLearner_summary.mean_dig_dist_from_traj_grasp(:,:,:,2);
    plot_color = {[0/255 102/255 0/255] [95/255 130/255 226/255] [216/255 85/255 116/255] [212/255 216/255 85/255] [1 153/255 51/255]...
        [185/255 122/255 212/255] [210/255 21/255 21/255] [33/255 13/255 134/255] [160/255 160/255 160/255] [106/255 216/255 102/255]};
end 

plotData = squeeze(nanmean(data,2));    % calculate average variability 
num_rats = size(plotData,1);

% set marker sizes
indMarkerSize = 4;

for i_rat = 1 : num_rats % plot individual rat data
    plot(1:10,plotData(i_rat,:),'-o','MarkerSize',indMarkerSize,'Color',plot_color{i_rat},'MarkerEdgeColor',...
        plot_color{i_rat},'MarkerFaceColor',plot_color{i_rat});
    hold on
end     

% figure properties
box off
set(gca,'ylim',[1 11]);
set(gca,'ytick',[1 6 11]);
ylabel({'mean dist. from'; 'avg. trajectory (mm)'})
xlabel('day number')
set(gca,'xlim',[.5 10.5]);
set(gca,'xtick',0:2:10);
set(gca,'FontSize',10);