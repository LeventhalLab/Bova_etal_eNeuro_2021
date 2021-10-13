function plotOutcomeEndPointYindiv(exptOutcomeSummary,group,i_out)

script_findLearners % get learners vs. non-learners
allRats = 1:14;
allRats(learningRats) = [];
nonLearningRats = allRats;

if group == 1   % set colors, pull out data
    succColor = {[0/255 102/255 0/255] [95/255 130/255 226/255] [216/255 85/255 116/255] [212/255 216/255 85/255]};
    data = exptOutcomeSummary.mean_dig2_endPt_y(:,:,learningRats);
else
    succColor = {[0/255 102/255 0/255] [95/255 130/255 226/255] [216/255 85/255 116/255] [212/255 216/255 85/255] [1 153/255 51/255]...
        [185/255 122/255 212/255] [210/255 21/255 21/255] [33/255 13/255 134/255] [160/255 160/255 160/255] [106/255 216/255 102/255]}; 
    data = exptOutcomeSummary.mean_dig2_endPt_y(:,:,nonLearningRats);
end

data = data*-1;
num_rats = size(data,3);

% set marker sizes
markerSize = 3;

line([.5 10.5],[0 0],'LineWidth',1,'Color','k')
hold on
% plot data
if i_out == 1   % hits
    for i_rat = 1 : num_rats
        plot(1:10,data(:,2,i_rat),'-o','MarkerSize',markerSize,'Color',succColor{i_rat},'MarkerEdgeColor',...
            succColor{i_rat},'MarkerFaceColor',succColor{i_rat});   
    end    
else    % misses
    for i_rat = 1 : num_rats 
        plot(1:10,data(:,4,i_rat),'-o','MarkerSize',markerSize,'Color',succColor{i_rat},'MarkerEdgeColor',...
            succColor{i_rat},'MarkerFaceColor',succColor{i_rat});   
    end    
end

% figure properties
box off
set(gca,'xlim',[.5 10.5],'ylim',[-5 20],'ytick',[-5 0 10 20]);
set(gca,'xtick',[2:2:10]);
set(gca,'FontSize',10);
ylabel({'reach endpoint'; 'y (mm)'})
xlabel('session number')

end