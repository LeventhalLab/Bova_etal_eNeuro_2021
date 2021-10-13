function plotFlexAtDistIndivSplit(learner_summary,nonLearner_summary,dataPt,group)

% plots digit flexion at selected z-digit2 value for 10 sessions (learners
% - group 1; non-learners - group 2)

if group == 1
    data = learner_summary.mean_flexion_traj;
    plot_color = {[0/255 102/255 0/255] [95/255 130/255 226/255] [216/255 85/255 116/255] [212/255 216/255 85/255]};
else
    data = nonLearner_summary.mean_flexion_traj;
    plot_color = {[0/255 102/255 0/255] [95/255 130/255 226/255] [216/255 85/255 116/255] [212/255 216/255 85/255] [1 153/255 51/255]...
        [185/255 122/255 212/255] [210/255 21/255 21/255] [33/255 13/255 134/255] [160/255 160/255 160/255] [106/255 216/255 102/255]};
end 

numSessions = size(data,2);

selData = (data(:,:,dataPt)*180)/pi; % pull out data at specific z-digit2 value, convert to degrees

% plot settings
indMarkerSize = 4;

for i_rat = 1:size(selData,1)   % plot individual rat data
    plot(1:numSessions,selData(i_rat,:),'-o','MarkerSize',indMarkerSize,'Color',plot_color{i_rat},...
        'MarkerEdgeColor',plot_color{i_rat},'MarkerFaceColor',plot_color{i_rat});
    hold on
end 

% figure properties
ylabel('\delta (degrees)')
xlabel('day number')
set(gca,'ylim',[0 80],'ytick',[0 40 80]);
set(gca,'xlim',[.5 10.5]);
set(gca,'xtick',[2:2:10]);
set(gca,'FontSize',10);
box off