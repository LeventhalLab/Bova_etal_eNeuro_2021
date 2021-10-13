% script_plotFigure1_supp1_rev

% creates Extended Data Figure 1-1 (eNeuro early learning skilled reaching)
% A - individual rat data for number of trials/session
% B - individual rat data for first reach success rate 
% C - average number of reaches/trial (+ individual rat data)
% D - outcome percents for all possible trial outcomes (e.g., drop in box,
% pellet remains on pedestal, etc.)
% each panel has both "learners" and "non-learners" data

summaryLoc = '/Volumes/DLC_data/rat kinematic summaries';   % load in data structures
cd(summaryLoc)
load('learning_summaries.mat')
load('experiment_summaries_by_outcome.mat')
load('learner_summaries.mat')
load('nonLearner_summaries.mat')

pdfName = 'figure1_supp1_rev2.pdf';
pdfDir = '/Volumes/DLC_data/DLC_learning_figures/revisions';
pdfName = fullfile(pdfDir,pdfName); % set file name and save directory

% set figure panel properties
figProps.m = 4;
figProps.n = 2;

figProps.colWidths = [.65 .65;.65 .65;.65 .65;.55 .55]; % m x n
figProps.rowHeights = [1 1 1 1.35;1 1 1 1.35]; % n x m

figProps.panelWidth = ones(1,figProps.n)*4;
figProps.panelHeight = ones(1,figProps.m)*2;

figProps.colSpace = [.5;.5;.5;.75]'; % m x n-1;
figProps.rowSpace = [.9 .9 1.35;.9 .9 1.35]'; % n x m - 1;

figProps.colSpacing = figProps.colSpace .* (ones(figProps.n-1,1) * 1);
figProps.rowSpacing = figProps.rowSpace .* (ones(figProps.m-1,1) * .7);

figProps.width = 12.5;
figProps.height = 12;

figProps.topMargin = .3;
figProps.leftMargin = 1.5;

[h_fig,h_axes] = createFigPanels7(figProps); % create figure panels 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
axes(h_axes(1,1))   % plot the individual number of trials each day, learners
plotNumTrialsIndiv(learner_summary)
set(gca,'xlabel',[],'XTickLabel',{' '})

axes(h_axes(1,2))   % plot the individual number of trials each day, non-learners
plotNumTrialsIndiv(nonLearner_summary)
set(gca,'ylabel',[],'YTickLabel',{' '},'xlabel',[],'XTickLabel',{' '})

axes(h_axes(2,1))   % plot the individual first reach success rate each day, learners
plotFirstSuccIndiv(learner_summary)
set(gca,'xlabel',[],'XTickLabel',{' '})

axes(h_axes(2,2))   % plot the individual first reach success rate each day, non-learners
plotFirstSuccIndiv(nonLearner_summary)
set(gca,'ylabel',[],'YTickLabel',{' '},'xlabel',[],'XTickLabel',{' '})

axes(h_axes(3,1))   % plot average + individual number of reaches per trials (learners)
plotNumReachIndiv(learner_summary)
set(gca,'xlabel',[])
line([.75 10.25],[3.6 3.6],'Color','k','HandleVisibility','off')    % add stars for significance
scatter(4.7,4,'*','k','HandleVisibility','off')
scatter(5.5,4,'*','k','HandleVisibility','off')
scatter(6.3,4,'*','k','HandleVisibility','off')

axes(h_axes(3,2))   % plot average + individual number of reaches per trials (non-learners)
plotNumReachIndiv(nonLearner_summary)
set(gca,'ylabel',[],'YTickLabel',{' '},'xlabel',[])
line([.75 10.25],[3.6 3.6],'Color','k','HandleVisibility','off')    % add stars for significance
scatter(4.7,4,'*','k','HandleVisibility','off')
scatter(5.5,4,'*','k','HandleVisibility','off')
scatter(6.3,4,'*','k','HandleVisibility','off')

group = 1;
axes(h_axes(4,1))   % plot heat map of all outcome percents, learners
plotOutcomeDistributionHeatSplit(exptOutcomeSummary,group)
axs = struct(gca); 
cb = axs.Colorbar;
cb.Ticks = [];  
colorbar('off')

group = 2;
axes(h_axes(4,2))   % plot heat map of all outcome percents, non-learners
plotOutcomeDistributionHeatSplit(exptOutcomeSummary,group)
Ax = gca;
Ax.YDisplayLabels = nan(size(Ax.YDisplayData));   

% add labels, text
h_figAxis = createFigAxes(h_fig);
axes(h_figAxis);

text(.32,.98,'learners','FontSize',10,'FontWeight','bold')
text(.53,.98,'non-learners','FontSize',10,'FontWeight','bold')

text(.42,.315,'day number','FontSize',10)
text(.42,.03,'day number','FontSize',10)

text(.1,.98,'A','FontSize',12,'FontWeight','bold')
text(.1,.77,'B','FontSize',12,'FontWeight','bold')
text(.1,.56,'C','FontSize',12,'FontWeight','bold')
text(.1,.31,'D','FontSize',12,'FontWeight','bold')
 
fig=gcf; % set print properties
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 figProps.width figProps.height];
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];

print(pdfName,'-dpdf'); % save figure  