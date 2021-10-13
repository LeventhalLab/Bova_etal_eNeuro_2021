% script_plotFigure6_supp1_rev

% creates Extened Data Figure 6-1 (eNeuro early learning skilled reaching)
% 

summaryLoc = '/Volumes/DLC_data/rat kinematic summaries';   % load in data
cd(summaryLoc)
load('learner_summaries.mat')
load('nonLearner_summaries.mat')
load('learning_summaries.mat')
load('succRateWithinSess.mat')
load('slidingWindowKinematics.mat')
load('experiment_summaries_by_outcome.mat')

pdfName = 'figure6_supp1_rev.pdf';
pdfDir = '/Volumes/DLC_data/DLC_learning_figures/revisions';
pdfName = fullfile(pdfDir,pdfName); % set file name and save directory

% set figure panel properties
figProps.m = 2;
figProps.n = 4;

figProps.colWidths = [.81 .81 .81 .81;.81 .81 .81 .81]; % m x n
figProps.rowHeights = [1 1;1 1;1 1;1 1]; % n x m

figProps.panelWidth = ones(1,figProps.n)*3.6;
figProps.panelHeight = ones(1,figProps.m)*3.6;

figProps.colSpace = [.55 .55 .55;.55 .55 .55]'; % m x n-1;
figProps.rowSpace = [.4 .4;.4 .4;.4 .4;.4 .4]'; % n x m - 1;

figProps.colSpacing = figProps.colSpace .* (ones(figProps.n-1,1) * .75);
figProps.rowSpacing = figProps.rowSpace .* (ones(figProps.m-1,1) * .5);

figProps.width = 16.8;
figProps.height = 9.3;

figProps.topMargin = .6;
figProps.leftMargin = .5;

[h_fig,h_axes] = createFigPanels7(figProps); % create figure panels 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
group = 1;
i_out = 1;
axes(h_axes(1,1))
plotPDreachTrajOutcomeIndiv(exptOutcomeSummary,group,i_out)
set(gca,'xlabel',[],'XTickLabel',{' '})
text(7.5,9.5,'hits','FontSize',9)

axes(h_axes(2,1))
plotPDgraspTrajOutcomeIndiv(exptOutcomeSummary,group,i_out)
set(gca,'xlabel',[])

i_out = 2;
axes(h_axes(1,2))
plotPDreachTrajOutcomeIndiv(exptOutcomeSummary,group,i_out)
set(gca,'xlabel',[],'ylabel',[],'YTickLabel',{' '},'XTickLabel',{' '})
text(6.5,9.5,'misses','FontSize',9)

axes(h_axes(2,2))
plotPDgraspTrajOutcomeIndiv(exptOutcomeSummary,group,i_out)
set(gca,'xlabel',[],'ylabel',[],'YTickLabel',{' '})

group = 2;
i_out = 1;
axes(h_axes(1,3))
plotPDreachTrajOutcomeIndiv(exptOutcomeSummary,group,i_out)
set(gca,'xlabel',[],'ylabel',[],'YTickLabel',{' '},'XTickLabel',{' '})
text(7.5,9.5,'hits','FontSize',9)

axes(h_axes(2,3))
plotPDgraspTrajOutcomeIndiv(exptOutcomeSummary,group,i_out)
set(gca,'xlabel',[],'ylabel',[],'YTickLabel',{' '})

i_out = 2;
axes(h_axes(1,4))
plotPDreachTrajOutcomeIndiv(exptOutcomeSummary,group,i_out)
set(gca,'xlabel',[],'ylabel',[],'YTickLabel',{' '},'XTickLabel',{' '})
text(6.5,9.5,'misses','FontSize',9)

axes(h_axes(2,4))
plotPDgraspTrajOutcomeIndiv(exptOutcomeSummary,group,i_out)
set(gca,'xlabel',[],'ylabel',[],'YTickLabel',{' '})

% add labels, text
h_figAxis = createFigAxes(h_fig);
axes(h_figAxis);

text(.45,.05,'day number','FontSize',10)
text(.27,.97,'learners','FontSize',10,'FontWeight','bold')
text(.65,.97,'non-learners','FontSize',10,'FontWeight','bold')

text(.005,.98,'A','FontSize',12,'FontWeight','bold')
text(.005,.53,'B','FontSize',12,'FontWeight','bold')

fig=gcf; % set print properties
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 figProps.width figProps.height];
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];

print(pdfName,'-dpdf'); % save figure  