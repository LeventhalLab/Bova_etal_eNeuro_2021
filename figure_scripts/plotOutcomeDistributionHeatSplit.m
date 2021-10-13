function plotOutcomeDistributionHeatSplit(exptOutcomeSummary,group)

% plots a heat map of the average percent per session of each trial outcome
% (e.g., knocked pellet off of pedestal, pellet remained on pedestal, etc.)

script_findLearners     % find the rats classified as "learners" and rats classified as "non-learners"
nonLearningRats = 1:14;
nonLearningRats(learningRats) = [];

num_sess = size(exptOutcomeSummary.fullOutcomePercent,1);

learner_data = exptOutcomeSummary.fullOutcomePercent(:,:,learningRats); % pull out data based on group
nonlearner_data = exptOutcomeSummary.fullOutcomePercent(:,:,nonLearningRats);

if group == 1
    avgData = squeeze(nanmean(learner_data,3));    % calculate average for each outcome
    highColor = [0/255 102/255 0/255];  % set the max color for color bar 
else
    avgData = squeeze(nanmean(nonlearner_data,3));
    highColor = [226/255 88/255 148/255]; 
end
avgData = avgData*100;  % convert to percent
avgData(:,10) = []; % remove the 'laser error' outcome (not applicable for this data b/c laser not used)

% properties for colorbar
lowColor = [255/255 255/255 255/255];   % sets the min color for color bar (white)
length = 200;   % sets the gradation of the color bar color
colors_p = [linspace(lowColor(1),highColor(1),length)', linspace(lowColor(2),highColor(2),length)',...
    linspace(lowColor(3),highColor(3),length)'];

outcomes = {'no pellet','first success','multiple success','drop in box','pellet knocked off','tongue','trigger error',...
    'pellet remained','contralateral paw','tongue and paw','paw through slot'}; % names of outcome categories

heatmap(1:num_sess,outcomes,avgData','CellLabelColor','none')   % plot data
caxis([0, 60])  % set axis limits for color bar
colormap(gca,colors_p)  % set color map 