function plotAvgDorsumEndptCoorIndivSplit(learner_summary,nonLearner_summary,i_coor,group)

% plots individual rats' average endpoint of paw dorsum in x, y, or z direction 
% (set by i_coor) 

if group == 1   % pull out endpoint data from selected coordinate direction, set plot colors
	data = learner_summary.mean_pd_endPt_reach(:,:,i_coor); 
    plot_color = {[0/255 102/255 0/255] [95/255 130/255 226/255] [216/255 85/255 116/255] [212/255 216/255 85/255]};
else
    data = nonLearner_summary.mean_pd_endPt_reach(:,:,i_coor);
    plot_color = {[0/255 102/255 0/255] [95/255 130/255 226/255] [216/255 85/255 116/255] [212/255 216/255 85/255] [1 153/255 51/255]...
        [185/255 122/255 212/255] [210/255 21/255 21/255] [33/255 13/255 134/255] [160/255 160/255 160/255] [106/255 216/255 102/255]};
end

if i_coor == 3 || i_coor == 2   % flip z and y axes
    data = data*-1;
end

num_rats = size(data,1);

% set marker sizes
indMarkerSize = 3;

line([.5 10.5],[0 0],'Color','k')   % plot a line at 0 (pellet position)
hold on
for i_rat = 1 : num_rats    % plot individual rat data
    plot(1:10,data(i_rat,:),'-o','MarkerSize',indMarkerSize,'Color',plot_color{i_rat},'MarkerEdgeColor',...
        plot_color{i_rat},'MarkerFaceColor',plot_color{i_rat});
end 

if i_coor == 1  % set y axis limits
    yMin = -14;
    yMax = 0;
    spVal = -7;
    ylabel('x','FontSize',10,'FontWeight','bold')
elseif i_coor == 2
    yMin = 0;
    yMax = 22;
    spVal = 11;
    ylabel('y','FontSize',10,'FontWeight','bold')
else
    yMin = -20;
    yMax = 2;
    spVal = -9;
    ylabel('z','FontSize',10,'FontWeight','bold')
end 

% figure properties
xlabel('session number')
set(gca,'ylim',[yMin yMax],'ytick',[yMin spVal yMax]);
set(gca,'xlim',[.5 10.5]);
set(gca,'xtick',[2 4 6 8 10]);
set(gca,'FontSize',10);
box off