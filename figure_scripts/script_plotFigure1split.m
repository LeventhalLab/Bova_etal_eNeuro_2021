%% script_plotFigure1split

% creates Figure 1 - eNeuro skilled reaching learning paper
% A - blank space for automaetd SR task graphic
% B - average number of trials per session
% C - average first reach success rate per session

% summaryLoc = '/Volumes/DLC_data/rat kinematic summaries';   % set directory where data structures are stored
% cd(summaryLoc)
load('learner_summaries.mat')   % load in data structures
load('nonLearner_summaries.mat')
load('learning_summaries.mat')

pdfName = 'figure1split.pdf';
pdfDir = '/Volumes/DLC_data/DLC_learning_figures/revisions';
pdfName = fullfile(pdfDir,pdfName); % set file name and save directory

% set figure panel properties
figProps.m = 2;
figProps.n = 2;

figProps.colWidths = [2.3 0;1 1]; % m x n
figProps.rowHeights = [1 1;1 1]; % n x m

figProps.panelWidth = ones(1,figProps.n)*3.5;
figProps.panelHeight = ones(1,figProps.m)*3.5;

figProps.colSpace = [0;1]'; % m x n-1;
figProps.rowSpace = [1;1]'; % n x m - 1;

figProps.colSpacing = figProps.colSpace .* (ones(figProps.n-1,1) * 2);
figProps.rowSpacing = figProps.rowSpace .* (ones(figProps.m-1,1) * 1.3);

figProps.width = 14;
figProps.height = 10;

figProps.topMargin = .3;
figProps.leftMargin = 1.5;

[h_fig,h_axes] = createFigPanels7(figProps); % create figure panels 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

axes(h_axes(1,1))   % panel A: remove axes to insert diagram of SR task in illustrator
set(gca,'visible','off')

axes(h_axes(2,1))   % panel B: plot average number of trials per session 
plotNumTrialsSplit(learner_summary,nonLearner_summary,learning_summary)
line([.75 10.25],[57 57],'Color','k','HandleVisibility','off')    % add stars for significance
scatter(4.7,60,'*','k','HandleVisibility','off')
scatter(5.5,60,'*','k','HandleVisibility','off')
scatter(6.3,60,'*','k','HandleVisibility','off')

axes(h_axes(2,2))   % panel C: plot average first reach success rate 
plotSuccRateSplit(learner_summary,nonLearner_summary,learning_summary)
line([.75 10.25],[75 75],'Color','k','HandleVisibility','off')    % add stars for significance
text(4.7,80,'#','HandleVisibility','off')
text(5.5,80,'#','HandleVisibility','off')
text(6.3,80,'#','HandleVisibility','off')

% add labels, text
h_figAxis = createFigAxes(h_fig);
axes(h_figAxis);

text(.03,.98,'A','FontSize',12,'FontWeight','bold')
text(.03,.51,'B','FontSize',12,'FontWeight','bold')
text(.41,.51,'C','FontSize',12,'FontWeight','bold')
 
fig=gcf; % set print properties
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 figProps.width figProps.height];
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];

print(pdfName,'-dpdf'); % save figure  