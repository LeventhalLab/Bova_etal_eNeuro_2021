% script_plotFigure5_rev

% creates Figure 5 (eNeuro early learning skilled reaching)
% A - aperture as a function of z-digit2
% B - aperture at seleced z-digit2 value (+3mm) from A 
% C - paw orientation as a function of z-digit2
% D - paw orientation at seleced z-digit2 value (+3mm) from C
% E - digit flexion as a function of z-digit2
% F - digit flexion at seleced z-digit2 value (+3mm) from E 

summaryLoc = '/Volumes/DLC_data/rat kinematic summaries';   % load data
cd(summaryLoc)
load('learner_summaries.mat')
load('nonLearner_summaries.mat')

pdfName = 'figure5_rev.pdf';
pdfDir = '/Volumes/DLC_data/DLC_learning_figures/revisions';
pdfName = fullfile(pdfDir,pdfName); % set file name and save directory

% set figure panel properties
figProps.m = 3;
figProps.n = 3;

figProps.colWidths = [1 1 1.3;1 1 1.3;1 1 1.3]; % m x n
figProps.rowHeights = [1 1 1;1 1 1;1 1 1]; % n x m

figProps.panelWidth = ones(1,figProps.n)*3.6;
figProps.panelHeight = ones(1,figProps.m)*3.6;

figProps.colSpace = [.7 1;.7 1;.7 1]'; % m x n-1;
figProps.rowSpace = [1 1;1 1;1 1]'; % n x m - 1;

figProps.colSpacing = figProps.colSpace .* (ones(figProps.n-1,1) * .75);
figProps.rowSpacing = figProps.rowSpace .* (ones(figProps.m-1,1) * .75);

figProps.width = 16;
figProps.height = 14.5;

figProps.topMargin = .3;
figProps.leftMargin = .5;

[h_fig,h_axes] = createFigPanels7(figProps); % create figure panels 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dataPt = 231;   % z-digit2 value where you want to select data from for panel B, D, F (and dashed line panel A, C, E)
for group = 1 : 2
    axes(h_axes(1,group))   % plot aperture as a function of z-digit2
    plotAperCoordinationSplit(learner_summary,nonLearner_summary,dataPt,group)
    set(gca,'xlabel',[],'XTickLabel',{' '})
    if group == 2
        set(gca,'ylabel',[],'YTickLabel',{' '})
    end
end

axes(h_axes(1,3))   % plot aperture at selected z-digit2 value for 10 sessions
plotApertureAtDistSplit(learner_summary,nonLearner_summary,dataPt)
set(gca,'ylabel',[])
set(gca,'xlabel',[],'XTickLabel',{' '})

for group = 1 : 2
    axes(h_axes(2,group))   % plot paw orientation as a function of z-digit2
    plotOrientCoordinationSplit(learner_summary,nonLearner_summary,dataPt,group)
    set(gca,'xlabel',[],'XTickLabel',{' '})
    if group == 2
        set(gca,'ylabel',[],'YTickLabel',{' '})
    end
end

axes(h_axes(2,3))   % plot paw orientation at selected z-digit2 value for 10 sessions
plotOrientAtDistSplit(learner_summary,nonLearner_summary,dataPt)
set(gca,'ylabel',[])
set(gca,'xlabel',[],'XTickLabel',{' '})
line([.75 10.25],[65 65],'Color','k')    % add significance markers
scatter(5.5,67,'*','k')
text(5.3,70,'#','FontSize',10)

for group = 1 : 2
    axes(h_axes(3,group))   % plot digit flexion as a function of z-digit2
    plotFlexCoordinationSplit(learner_summary,nonLearner_summary,dataPt,group)
    if group == 2
        set(gca,'ylabel',[],'YTickLabel',{' '})
    end
end

axes(h_axes(3,3))   % plot digit flexion at selected z-digit2 value for 10 sessions
plotFlexAtDistSplit(learner_summary,nonLearner_summary,dataPt)
set(gca,'ylabel',[])

% add labels, text
h_figAxis = createFigAxes(h_fig);
axes(h_figAxis);

text(.008,.98,'A','FontSize',12,'FontWeight','bold')
text(.56,.98,'B','FontSize',12,'FontWeight','bold')
text(.008,.7,'C','FontSize',12,'FontWeight','bold')
text(.56,.7,'D','FontSize',12,'FontWeight','bold')
text(.008,.39,'E','FontSize',12,'FontWeight','bold')
text(.56,.39,'F','FontSize',12,'FontWeight','bold')
 
fig=gcf; % set print properties
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 figProps.width figProps.height];
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];

print(pdfName,'-dpdf'); % save figure  