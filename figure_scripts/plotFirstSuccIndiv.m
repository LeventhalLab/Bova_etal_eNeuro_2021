function plotFirstSuccIndiv(summary)

% plots individual rat averages for first reach success rate 

data = summary.firstReachSuccess*100;   % convert to percent
num_trials = summary.num_trials;
num_rats = size(data,2);
num_sess = size(data,1);

for i_rat = 1 : num_rats    % if a rat performs fewer than 10 reaches in a session do not include this session in success rate average
    for i_sess = 1 : num_sess        
        if num_trials(i_sess,i_rat) < 10
            data(i_sess,i_rat) = NaN;
        end
    end
end

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
ylabel({'first reach'; 'success rate'},'FontSize',10)
xlabel('day number')
set(gca,'ylim',[0 100],'ytick',[0 50 100]);
set(gca,'xlim',[.5 10.5]);
set(gca,'xtick',[2 4 6 8 10]);
set(gca,'FontSize',10);
box off