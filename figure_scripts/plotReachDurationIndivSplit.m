function plotReachDurationIndivSplit(learner_summary,nonLearner_summary,grp)

% plots individual rats' average reach duration over sessions

if grp == 1 % get data, set plot colors based on group (grp)
    data = learner_summary.mean_reach_dur;
    plot_color = {[0/255 102/255 0/255] [95/255 130/255 226/255] [216/255 85/255 116/255] [212/255 216/255 85/255]};
else
    data = nonLearner_summary.mean_reach_dur;
    plot_color = {[0/255 102/255 0/255] [95/255 130/255 226/255] [216/255 85/255 116/255] [212/255 216/255 85/255] [1 153/255 51/255]...
        [185/255 122/255 212/255] [210/255 21/255 21/255] [33/255 13/255 134/255] [160/255 160/255 160/255] [106/255 216/255 102/255]};
end

num_rats = size(data,2);

% set marker sizes
indMarkerSize = 4;

for i_rat = 1 : num_rats    % plot each rat's data
    plot(1:10,data(:,i_rat),'-o','MarkerSize',indMarkerSize,'Color',plot_color{i_rat},'MarkerEdgeColor',...
        plot_color{i_rat},'MarkerFaceColor',plot_color{i_rat});
    hold on
end

% figure properties
box off
set(gca,'ylim',[0 140]);
set(gca,'ytick',[0 70 140]);
ylabel('reach duration (ms)')
xlabel('day number')
set(gca,'xlim',[.5 10.5]);
set(gca,'xtick',0:2:10);
set(gca,'FontSize',10);