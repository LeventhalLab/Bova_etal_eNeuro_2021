% script_plotFigure4_supp1_rev

% creates Extended Data Figure 4-1
% A - individual rats' digit 2 reach and grasp trajectory variability 
% B - individual rats' average aperture at reach end
% C - individual rats' average aperture variance at reach end
% D - individual rats' average paw orientation at reach end
% E - individual rats' average paw orientation variance at reach end
% F - individual rats' average digit flexion at reach end
% G - individual rats' average digit flexion variance at reach end

summaryLoc = '/Volumes/DLC_data/rat kinematic summaries';   % load data
cd(summaryLoc)
load('learner_summaries.mat')
load('nonLearner_summaries.mat')

pdfName = 'figure4_supp1_rev2.pdf';
pdfDir = '/Volumes/DLC_data/DLC_learning_figures/revisions';
pdfName = fullfile(pdfDir,pdfName); % set file name and save directory

% set figure panel properties
figProps.m = 4;
figProps.n = 4;

figProps.colWidths = [1 1 1 1;1 1 1 1;1 1 1 1;1 1 1 1]; % m x n
figProps.rowHeights = [1 1 1 1;1 1 1 1;1 1 1 1;1 1 1 1]; % n x m

figProps.panelWidth = ones(1,figProps.n)*2.5;
figProps.panelHeight = ones(1,figProps.m)*2.5;

figProps.colSpace = [1 3 1;1 3 1;1 3 1;1 3 1]'; % m x n-1;
figProps.rowSpace = [1 1 1;1 1 1;1 1 1;1 1 1]'; % n x m - 1;

figProps.colSpacing = figProps.colSpace .* (ones(figProps.n-1,1) * .3);
figProps.rowSpacing = figProps.rowSpace .* (ones(figProps.m-1,1) * .5);

figProps.width = 15;
figProps.height = 13.5;

figProps.topMargin = .6;
figProps.leftMargin = .5;

[h_fig,h_axes] = createFigPanels7(figProps); % create figure panels 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for group = 1 : 2   % plot individual rats' average digit 2 reach trajectory variability
    axes(h_axes(1,group))
    plotVariablityReachDigIndivSplit(learner_summary,nonLearner_summary,group)
    if group == 2
        set(gca,'ylabel',[],'YTickLabel',{' '})
    end
    set(gca,'xlabel',[],'XTickLabel',{' '})
end

for group = 1 : 2   % plot individual rats' average digit 2 grasp trajectory variability
    axes(h_axes(1,group+2))
    plotVariablityGraspDigIndivSplit(learner_summary,nonLearner_summary,group)
    if group == 2
        set(gca,'YTickLabel',{' '})
    end
    set(gca,'ylabel',[])
    set(gca,'xlabel',[],'XTickLabel',{' '})
end

for group = 1 : 2   % plot individual rats' average digit aperture at reach end
    axes(h_axes(2,group))
    plotEndAperIndivSplit(learner_summary,nonLearner_summary,group)
    if group == 2
        set(gca,'ylabel',[],'YTickLabel',{' '})
    end
    set(gca,'xlabel',[],'XTickLabel',{' '})
end

for group = 1 : 2   % plot individual rats' average digit aperture variance at reach end
    axes(h_axes(2,group+2))
    plotEndAperStdIndivSplit(learner_summary,nonLearner_summary,group)
    if group == 2
        set(gca,'ylabel',[],'YTickLabel',{' '})
    end
    set(gca,'xlabel',[],'XTickLabel',{' '})
end

for group = 1 : 2   % plot individual rats' average paw orientation at reach end
    axes(h_axes(3,group))
    plotEndOrientIndivSplit(learner_summary,nonLearner_summary,group)
    if group == 2
        set(gca,'ylabel',[],'YTickLabel',{' '})
    end
    set(gca,'xlabel',[],'XTickLabel',{' '})
end

for group = 1 : 2   % plot individual rats' average paw orientation variance at reach end
    axes(h_axes(3,group+2))
    plotEndOrientMRLIndivSplit(learner_summary,nonLearner_summary,group)
    if group == 2
        set(gca,'ylabel',[],'YTickLabel',{' '})
    end
    set(gca,'xlabel',[],'XTickLabel',{' '})
end

for group = 1 : 2   % plot individual rats' average digit flexion at reach end
    axes(h_axes(4,group))
    plotEndFlexIndivSplit(learner_summary,nonLearner_summary,group)
    if group == 2
        set(gca,'ylabel',[],'YTickLabel',{' '})
    end
end
    
for group = 1 : 2   % plot individual rats' average digit flexion variance at reach end
    axes(h_axes(4,group+2))
    plotEndFlexMRLIndivSplit(learner_summary,nonLearner_summary,group)
    if group == 2
        set(gca,'ylabel',[],'YTickLabel',{' '})
    end
end

% add labels, text
h_figAxis = createFigAxes(h_fig);
axes(h_figAxis);

text(.4,.94,'reach','FontSize',10)
text(.81,.94,'grasp','FontSize',10)

text(.17,.97,'learners','FontSize',10)
text(.32,.97,'non-learners','FontSize',10)
text(.575,.97,'learners','FontSize',10)
text(.732,.97,'non-learners','FontSize',10)

fig=gcf; % set print properties
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 figProps.width figProps.height];
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];

print(pdfName,'-dpdf'); % save figure  
