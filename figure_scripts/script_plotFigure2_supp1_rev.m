% script_plotFigure2_supp1_rev

% makes Extended Data Figure 2-1 eNeuro early learning skilled reaching
% A - individual rat data average reach trajectory variability 
% B - individual rat data average grasp trajectory variability
% C - individual rat data average reach duration
% D - individual rat data average reach velocity

summaryLoc = '/Volumes/DLC_data/rat kinematic summaries';   % load data
cd(summaryLoc)
load('learner_summaries.mat')
load('nonLearner_summaries.mat')

pdfName = 'figure2_supp1_rev2.pdf';
pdfDir = '/Volumes/DLC_data/DLC_learning_figures/revisions';
pdfName = fullfile(pdfDir,pdfName); % set file name and save directory

% set figure panel properties
figProps.m = 4;
figProps.n = 2;

figProps.colWidths = [1 1;1 1;1 1;1 1]; % m x n
figProps.rowHeights = [1 1 1 1;1 1 1 1]; % n x m

figProps.panelWidth = ones(1,figProps.n)*3;
figProps.panelHeight = ones(1,figProps.m)*3;

figProps.colSpace = [1;1;1;1]'; % m x n-1;
figProps.rowSpace = [1 1 1;1 1 1]'; % n x m - 1;

figProps.colSpacing = figProps.colSpace .* (ones(figProps.n-1,1) * .4);
figProps.rowSpacing = figProps.rowSpace .* (ones(figProps.m-1,1) * .7);

figProps.width = 11;
figProps.height = 16;

figProps.topMargin = .3;
figProps.leftMargin = .5;

[h_fig,h_axes] = createFigPanels7(figProps); % create figure panels 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
grp = 1;    % plot individual rat data average reach trajectory varaibility - learners
axes(h_axes(1,1))   
plotAverageVariablityReachPawIndivSplit(learner_summary,nonLearner_summary,grp)
set(gca,'xlabel',[])
text(1,8.8,'reach','FontSize',10)

grp = 2;    % plot individual rat data average reach trajectory varaibility - non-learners
axes(h_axes(1,2))   
plotAverageVariablityReachPawIndivSplit(learner_summary,nonLearner_summary,grp)
set(gca,'ylabel',[],'YTickLabel',{' '},'xlabel',[])

grp = 1;    % plot individual rat data average grasp trajectory variability - learners
axes(h_axes(2,1))   
plotAverageVariablityGraspPawIndivSplit(learner_summary,nonLearner_summary,grp)
set(gca,'xlabel',[])
text(1,8.8,'grasp','FontSize',10)

grp = 2;    % plot individual rat data average grasp trajectory variability - non-learners
axes(h_axes(2,2))  
plotAverageVariablityGraspPawIndivSplit(learner_summary,nonLearner_summary,grp)
set(gca,'ylabel',[],'YTickLabel',{' '},'xlabel',[])

grp = 1;    % plot individual rat data average reach duration - learners
axes(h_axes(3,1))
plotReachDurationIndivSplit(learner_summary,nonLearner_summary,grp)
set(gca,'xlabel',[])

grp = 2;    % plot individual rat data average reach duration - non-learners
axes(h_axes(3,2))
plotReachDurationIndivSplit(learner_summary,nonLearner_summary,grp)
set(gca,'ylabel',[],'YTickLabel',{' '},'xlabel',[])

grp = 1;    % plot individual rat data average reach velocity - learners
axes(h_axes(4,1))
plotReachVelocityIndivSplit(learner_summary,nonLearner_summary,grp)
set(gca,'xlabel',[])

grp = 2;    % plot individual rat data average reach velocity - non-learners
axes(h_axes(4,2))
plotReachVelocityIndivSplit(learner_summary,nonLearner_summary,grp)
set(gca,'ylabel',[],'YTickLabel',{' '},'xlabel',[])

% add labels, text
h_figAxis = createFigAxes(h_fig);
axes(h_figAxis);

text(.29,.985,'learners','FontSize',10,'FontWeight','bold')
text(.565,.985,'non-learners','FontSize',10,'FontWeight','bold')

text(.43,.05,'day number','FontSize',10)
text(.005,.99,'A','FontSize',12,'FontWeight','bold')
text(.005,.76,'B','FontSize',12,'FontWeight','bold')
text(.005,.53,'C','FontSize',12,'FontWeight','bold')
text(.005,.30,'D','FontSize',12,'FontWeight','bold')

fig=gcf; % set print properties
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 figProps.width figProps.height];
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];

print(pdfName,'-dpdf'); % save figure  


