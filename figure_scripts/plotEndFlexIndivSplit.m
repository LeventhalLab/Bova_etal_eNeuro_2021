function plotEndFlexIndivSplit(learner_summary,nonLearner_summary,group)

% plots individual rats' average digit flexion at reach end over sessions
% (learners - group 1; non-learners - group 2)

if group == 1   % pull out data & convert to degrees, set plot color
	data = ((learner_summary.mean_end_flex*180)/pi)';
    plot_color = {[0/255 102/255 0/255] [95/255 130/255 226/255] [216/255 85/255 116/255] [212/255 216/255 85/255]};
else
    data = ((nonLearner_summary.mean_end_flex*180)/pi)';
    plot_color = {[0/255 102/255 0/255] [95/255 130/255 226/255] [216/255 85/255 116/255] [212/255 216/255 85/255] [1 153/255 51/255]...
        [185/255 122/255 212/255] [210/255 21/255 21/255] [33/255 13/255 134/255] [160/255 160/255 160/255] [106/255 216/255 102/255]};
end 

num_rats = size(data,1);

% set marker sizes
indMarkerSize = 4;

for i_rat = 1 : num_rats % plot individual rat data
    plot(1:10,data(i_rat,:),'-o','MarkerSize',indMarkerSize,'Color',plot_color{i_rat},'MarkerEdgeColor',...
        plot_color{i_rat},'MarkerFaceColor',plot_color{i_rat});
    hold on
end     

% figure properties
box off
set(gca,'ylim',[0 45],'ytick',[0 25 45]);
ylabel({'\delta at reach'; 'end (mm)'})
xlabel('day number')
set(gca,'xlim',[.5 10.5]);
set(gca,'xtick',0:2:10);
set(gca,'FontSize',10);