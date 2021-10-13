% script_plotFigure3_supp1_rev

% creates Extended Data Figure 3-1 (eNeuro early learning skilled reaching)
%   - average endpoints of paw dorsum and digit 2 in x, y, z directions for
%     individual rats

summaryLoc = '/Volumes/DLC_data/rat kinematic summaries';   % load data
cd(summaryLoc)
load('learner_summaries.mat')
load('nonLearner_summaries.mat')

pdfName = 'figure3_supp1_rev2.pdf';
pdfDir = '/Volumes/DLC_data/DLC_learning_figures/revisions';
pdfName = fullfile(pdfDir,pdfName); % set file name and save directory

% set figure panel properties
figProps.m = 3;
figProps.n = 4;

figProps.colWidths = [1 1 1 1;1 1 1 1;1 1 1 1]; % m x n
figProps.rowHeights = [1 1 1;1 1 1;1 1 1;1 1 1]; % n x m

figProps.panelWidth = ones(1,figProps.n)*2;
figProps.panelHeight = ones(1,figProps.m)*2;

figProps.colSpace = [1 2.5 1;1 2.5 1;1 2.5 1]'; % m x n-1;
figProps.rowSpace = [1 1;1 1;1 1;1 1]'; % n x m - 1;

figProps.colSpacing = figProps.colSpace .* (ones(figProps.n-1,1) * .3);
figProps.rowSpacing = figProps.rowSpace .* (ones(figProps.m-1,1) * .5);

figProps.width = 13;
figProps.height = 9;

figProps.topMargin = 1;
figProps.leftMargin = .5;

[h_fig,h_axes] = createFigPanels7(figProps); % create figure panels 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i_coor = 1 : 3  % plot individual rats' average paw dorsum reach endpoints (x, y, z) 
    group = 1;
    axes(h_axes(i_coor,1))   
    plotAvgDorsumEndptCoorIndivSplit(learner_summary,nonLearner_summary,i_coor,group)
    set(gca,'xlabel',[])
    if i_coor < 3
        set(gca,'XTickLabel',{' '})
    end
    
    group = 2;
    axes(h_axes(i_coor,2))    
    plotAvgDorsumEndptCoorIndivSplit(learner_summary,nonLearner_summary,i_coor,group)
    set(gca,'xlabel',[],'YTickLabel',{' '},'ylabel',[])
    if i_coor < 3
        set(gca,'XTickLabel',{' '})
    end
end

for i_coor = 1 : 3  % plot individual rats' average digit 2 reach endpoints (x, y, z) 
    group = 1;
    axes(h_axes(i_coor,3))   
    plotAvgDigEndptCoorIndivSplit(learner_summary,nonLearner_summary,i_coor,group)
    set(gca,'xlabel',[],'ylabel',[])
    if i_coor < 3
        set(gca,'XTickLabel',{' '})
    end
    
    group = 2;
    axes(h_axes(i_coor,4))   
    plotAvgDigEndptCoorIndivSplit(learner_summary,nonLearner_summary,i_coor,group)
    set(gca,'xlabel',[],'YTickLabel',{' '},'ylabel',[])
    if i_coor < 3
        set(gca,'XTickLabel',{' '})
    end
end

% add labels, text
h_figAxis = createFigAxes(h_fig);
axes(h_figAxis);

text(.285,.97,'paw','FontSize',10,'FontWeight','bold')
text(.66,.97,'digit 2','FontSize',10,'FontWeight','bold')
text(.17,.93,'learners','FontSize',10)
text(.317,.93,'non-learners','FontSize',10)
text(.565,.93,'learners','FontSize',10)
text(.71,.93,'non-learners','FontSize',10)
text(.43,.03,'day number','FontSize',10)
h = text(.03,.35,'reach endpoint (mm)','FontSize',10);
set(h,'Rotation',90)

fig=gcf; % set print properties
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 figProps.width figProps.height];
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];

print(pdfName,'-dpdf'); % save figure  


