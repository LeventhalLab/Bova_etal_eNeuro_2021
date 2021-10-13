function plotNumTrialsIndiv(summary)

% plots the individual rat averages for the number of trials performed per
% session; plots either "learners" or "non-learners" depending on which
% summary structure is input

data = summary.num_trials;
num_rats = size(data,2);

% set marker sizes
indMarkerSize = 4;

if num_rats == 4    % set colors 
    plotColor = {[0/255 102/255 0/255] [95/255 130/255 226/255] [216/255 85/255 116/255] [212/255 216/255 85/255]};  % learners
else
	plotColor = {[0/255 102/255 0/255] [95/255 130/255 226/255] [216/255 85/255 116/255] [212/255 216/255 85/255] [1 153/255 51/255]...
        [185/255 122/255 212/255] [210/255 21/255 21/255] [33/255 13/255 134/255] [160/255 160/255 160/255] [106/255 216/255 102/255]};   % non-learners
end

for i_rat = 1 : num_rats    % plot individual rat data
    plot(1:10,data(:,i_rat),'-o','MarkerSize',indMarkerSize,'Color',plotColor{i_rat},'MarkerEdgeColor',...
        plotColor{i_rat},'MarkerFaceColor',plotColor{i_rat});
    hold on
end 

% figure properties
ylabel({'number'; 'of trials'},'FontSize',10)
xlabel('day number')
set(gca,'ylim',[0 90],'ytick',[0 45 90]);
set(gca,'xlim',[.5 10.5]);
set(gca,'xtick',[2 4 6 8 10]);
set(gca,'FontSize',10);
box off