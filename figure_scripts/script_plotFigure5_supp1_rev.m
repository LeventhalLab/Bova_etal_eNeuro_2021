% script_plotFigure5_supp1_rev

% creates Extended Data Figure 5-1 (eNeuro early learning skilled reaching)
% A - individual rats' average aperture at z-digit2 value from Fig. 5
% B - individual rats' average paw orientation at z-digit2 value from Fig. 5
% C - individual rats' average digit flexion at z-digit2 value from Fig. 5 

summaryLoc = '/Volumes/DLC_data/rat kinematic summaries';   % load data
cd(summaryLoc)
load('learner_summaries.mat')
load('nonLearner_summaries.mat')

pdfName = 'figure5_supp1_rev2.pdf';
pdfDir = '/Volumes/DLC_data/DLC_learning_figures/revisions';
pdfName = fullfile(pdfDir,pdfName); % set file name and save directory

% set figure panel properties
figProps.m = 3;
figProps.n = 2;

figProps.colWidths = [1 1;1 1;1 1]; % m x n
figProps.rowHeights = [1 1 1;1 1 1]; % n x m

figProps.panelWidth = ones(1,figProps.n)*2.5;
figProps.panelHeight = ones(1,figProps.m)*2.5;

figProps.colSpace = [1;1;1]'; % m x n-1;
figProps.rowSpace = [1 1;1 1]'; % n x m - 1;

figProps.colSpacing = figProps.colSpace .* (ones(figProps.n-1,1) * .3);
figProps.rowSpacing = figProps.rowSpace .* (ones(figProps.m-1,1) * .5);

figProps.width = 8;
figProps.height = 10.5;

figProps.topMargin = .6;
figProps.leftMargin = .5;

[h_fig,h_axes] = createFigPanels7(figProps); % create figure panels 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dataPt = 231; % z-digit2 value where you want to select data 
for group = 1 : 2   % A
    axes(h_axes(1,group))
    plotApertureAtDistIndivSplit(learner_summary,nonLearner_summary,dataPt,group)
    if group == 2
        set(gca,'ylabel',[],'YTickLabel',{' '})
    end
    set(gca,'xlabel',[],'XTickLabel',{' '})
end

for group = 1 : 2   % B
    axes(h_axes(2,group))
    plotOrientAtDistIndivSplit(learner_summary,nonLearner_summary,dataPt,group)
    if group == 2
        set(gca,'ylabel',[],'YTickLabel',{' '})
    end
    set(gca,'xlabel',[],'XTickLabel',{' '})
end

for group = 1 : 2   % C
    axes(h_axes(3,group))
    plotFlexAtDistIndivSplit(learner_summary,nonLearner_summary,dataPt,group)
    if group == 2
        set(gca,'ylabel',[],'YTickLabel',{' '})
    end
end

% add labels, text
h_figAxis = createFigAxes(h_fig);
axes(h_figAxis);

text(.25,.965,'learners','FontSize',10)
text(.55,.965,'non-learners','FontSize',10)

text(.008,.97,'A','FontSize',12,'FontWeight','bold')
text(.008,.68,'B','FontSize',12,'FontWeight','bold')
text(.008,.38,'C','FontSize',12,'FontWeight','bold')

fig=gcf; % set print properties
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 figProps.width figProps.height];
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];

print(pdfName,'-dpdf'); % save figure  
