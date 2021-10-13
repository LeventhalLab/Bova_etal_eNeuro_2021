function plotNumReachIndiv(summary)

% plots the average number of reaches performed each trial (rats can make
% multiple reaches for the pellet in a single trial), plots group average
% plus individual rat data

data = summary.mean_num_reaches;
num_rats = size(data,2);

avgData = nanmean(data,2);  % calculate group average
numDataPts = sum(~isnan(data),2);
errbars = nanstd(data,0,2)./sqrt(numDataPts);    % calculate s.e.m.

% set marker sizes
avgMarkerSize = 45;
indMarkerSize = 4;
avgColor = [160/255 160/255 160/255];

if num_rats == 4    % set average plot colors
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

% plot average data
plot(1:10,avgData,'Color','k','LineWidth',1.5)
%scatter(1:10,avgData,avgMarkerSize,'filled','MarkerEdgeColor',avgColor,'MarkerFaceColor',avgColor); 
% e = errorbar(1:10,avgData,errbars,'linestyle','none','linewidth',1.5);  % add error bars
% e.Color = 'k';

% figure properties
ylabel({'number of'; 'reach attempts'},'FontSize',10)
xlabel('day number')
set(gca,'ylim',[0 4],'ytick',[0 2 4]);
set(gca,'xlim',[.5 10.5]);
set(gca,'xtick',[2 4 6 8 10]);
set(gca,'FontSize',10);
box off