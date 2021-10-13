% script_plotFigure6_supp2_rev

% creates Extened Data Figure 6-2 (eNeuro early learning skilled reaching)
% 

summaryLoc = '/Volumes/DLC_data/rat kinematic summaries';   % load in data
cd(summaryLoc)
load('learner_summaries.mat')
load('nonLearner_summaries.mat')
load('learning_summaries.mat')
load('succRateWithinSess.mat')
load('slidingWindowKinematics.mat')
load('experiment_summaries_by_outcome.mat')

pdfName = 'figure6_supp2_rev.pdf';
pdfDir = '/Volumes/DLC_data/DLC_learning_figures/revisions';
pdfName = fullfile(pdfDir,pdfName); % set file name and save directory

% set figure panel properties
figProps.m = 5;
figProps.n = 4;

figProps.colWidths = [.81 .81 .81 .81;.81 .81 .81 .81;.81 .81 .81 .81;.81 .81 .81 .81;.81 .81 .81 .81]; % m x n
figProps.rowHeights = [1 1 1 1 1;1 1 1 1 1;1 1 1 1 1;1 1 1 1 1]; % n x m

figProps.panelWidth = ones(1,figProps.n)*3.6;
figProps.panelHeight = ones(1,figProps.m)*3.6;

figProps.colSpace = [.55 .55 .55;.55 .55 .55;.55 .55 .55;.55 .55 .55;.55 .55 .55]'; % m x n-1;
figProps.rowSpace = [.4 .4 .4 .4;.4 .4 .4 .4;.4 .4 .4 .4;.4 .4 .4 .4]'; % n x m - 1;

figProps.colSpacing = figProps.colSpace .* (ones(figProps.n-1,1) * .75);
figProps.rowSpacing = figProps.rowSpace .* (ones(figProps.m-1,1) * .5);

figProps.width = 17.2;
figProps.height = 21;

figProps.topMargin = .6;
figProps.leftMargin = .8;

[h_fig,h_axes] = createFigPanels7(figProps); % create figure panels 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
detValL = calculateDetVarMatrixOutcome(exptOutcomeSummary); % calculate determinant of the covariance matrix for reach endpoints

group = 1;
i_out = 1;
axes(h_axes(1,1))
plotOutcomeEndPointXindiv(exptOutcomeSummary,group,i_out)
set(gca,'xlabel',[],'XTickLabel',{' '})
text(7.5,9.5,'hits','FontSize',9)

axes(h_axes(2,1))
plotOutcomeEndPointYindiv(exptOutcomeSummary,group,i_out)
set(gca,'xlabel',[],'XTickLabel',{' '})

axes(h_axes(3,1))
plotOutcomeEndPointZindiv(exptOutcomeSummary,group,i_out)
set(gca,'xlabel',[],'XTickLabel',{' '})

i_paw = 1;
axes(h_axes(4,1))
plotEndPtVarOutcomeIndiv(detValL,i_paw,group,i_out)
set(gca,'xlabel',[],'XTickLabel',{' '})

i_paw = 3;
axes(h_axes(5,1))
plotEndPtVarOutcomeIndiv(detValL,i_paw,group,i_out)
set(gca,'xlabel',[])

group = 1;
i_out = 2;
axes(h_axes(1,2))
plotOutcomeEndPointXindiv(exptOutcomeSummary,group,i_out)
set(gca,'xlabel',[],'XTickLabel',{' '},'ylabel',[],'YTickLabel',{' '})
text(6.5,9.5,'misses','FontSize',9)

axes(h_axes(2,2))
plotOutcomeEndPointYindiv(exptOutcomeSummary,group,i_out)
set(gca,'xlabel',[],'XTickLabel',{' '},'ylabel',[],'YTickLabel',{' '})

axes(h_axes(3,2))
plotOutcomeEndPointZindiv(exptOutcomeSummary,group,i_out)
set(gca,'xlabel',[],'XTickLabel',{' '},'ylabel',[],'YTickLabel',{' '})

i_paw = 1;
axes(h_axes(4,2))
plotEndPtVarOutcomeIndiv(detValL,i_paw,group,i_out)
set(gca,'xlabel',[],'XTickLabel',{' '},'ylabel',[],'YTickLabel',{' '})

i_paw = 3;
axes(h_axes(5,2))
plotEndPtVarOutcomeIndiv(detValL,i_paw,group,i_out)
set(gca,'xlabel',[],'ylabel',[],'YTickLabel',{' '})

group = 2;
i_out = 1;
axes(h_axes(1,3))
plotOutcomeEndPointXindiv(exptOutcomeSummary,group,i_out)
set(gca,'xlabel',[],'XTickLabel',{' '},'ylabel',[],'YTickLabel',{' '})
text(7.5,9.5,'hits','FontSize',9)

axes(h_axes(2,3))
plotOutcomeEndPointYindiv(exptOutcomeSummary,group,i_out)
set(gca,'xlabel',[],'XTickLabel',{' '},'ylabel',[],'YTickLabel',{' '})

axes(h_axes(3,3))
plotOutcomeEndPointZindiv(exptOutcomeSummary,group,i_out)
set(gca,'xlabel',[],'XTickLabel',{' '},'ylabel',[],'YTickLabel',{' '})

i_paw = 1;
axes(h_axes(4,3))
plotEndPtVarOutcomeIndiv(detValL,i_paw,group,i_out)
set(gca,'xlabel',[],'XTickLabel',{' '},'ylabel',[],'YTickLabel',{' '})

i_paw = 3;
axes(h_axes(5,3))
plotEndPtVarOutcomeIndiv(detValL,i_paw,group,i_out)
set(gca,'xlabel',[],'ylabel',[],'YTickLabel',{' '})

group = 2;
i_out = 2;
axes(h_axes(1,4))
plotOutcomeEndPointXindiv(exptOutcomeSummary,group,i_out)
set(gca,'xlabel',[],'XTickLabel',{' '},'ylabel',[],'YTickLabel',{' '})
text(6.5,9.5,'misses','FontSize',9)

axes(h_axes(2,4))
plotOutcomeEndPointYindiv(exptOutcomeSummary,group,i_out)
set(gca,'xlabel',[],'XTickLabel',{' '},'ylabel',[],'YTickLabel',{' '})

axes(h_axes(3,4))
plotOutcomeEndPointZindiv(exptOutcomeSummary,group,i_out)
set(gca,'xlabel',[],'XTickLabel',{' '},'ylabel',[],'YTickLabel',{' '})

i_paw = 1;
axes(h_axes(4,4))
plotEndPtVarOutcomeIndiv(detValL,i_paw,group,i_out)
set(gca,'xlabel',[],'XTickLabel',{' '},'ylabel',[],'YTickLabel',{' '})

i_paw = 3;
axes(h_axes(5,4))
plotEndPtVarOutcomeIndiv(detValL,i_paw,group,i_out)
set(gca,'ylabel',[],'YTickLabel',{' '})

% add labels, text
h_figAxis = createFigAxes(h_fig);
axes(h_figAxis);

text(.28,.985,'learners','FontSize',10,'FontWeight','bold')
text(.65,.985,'non-learners','FontSize',10,'FontWeight','bold')

text(.008,.985,'A','FontSize',12,'FontWeight','bold')
text(.008,.79,'B','FontSize',12,'FontWeight','bold')
text(.008,.61,'C','FontSize',12,'FontWeight','bold')
text(.008,.43,'D','FontSize',12,'FontWeight','bold')
text(.008,.25,'E','FontSize',12,'FontWeight','bold')

fig=gcf; % set print properties
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 figProps.width figProps.height];
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];

print(pdfName,'-dpdf'); % save figure  

