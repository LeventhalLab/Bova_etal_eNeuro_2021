% script_plotFigure6_rev

% creates Figure 6 (eNeuro early learning skilled reaching)
% A - average reach trajectory variability split by outcome (hit vs. miss)
% B - average grasp trajectory variability split by outcome (hit vs. miss)
% C - average reach endpoints (x,y,z) split by outcome (hit vs. miss)
% D - average reach endpoint variability (paw) split by outcome 
% E - average reach endpoint variability (digit2) split by outcome

summaryLoc = '/Volumes/DLC_data/rat kinematic summaries';   % load in data
cd(summaryLoc)
load('learner_summaries.mat')
load('nonLearner_summaries.mat')
load('learning_summaries.mat')
load('succRateWithinSess.mat')
load('slidingWindowKinematics.mat')
load('experiment_summaries_by_outcome.mat')

pdfName = 'figure6_rev.pdf';
pdfDir = '/Volumes/DLC_data/DLC_learning_figures/revisions';
pdfName = fullfile(pdfDir,pdfName); % set file name and save directory

% set figure panel properties
figProps.m = 4;
figProps.n = 4;

figProps.colWidths = [.81 .81 .81 .81;1.05 1.05 1.05 0;1.05 1.05 1.05 0;.81 .81 .81 .81]; % m x n
figProps.rowHeights = [1 1 1 1;1 1 1 1;1 1 1 1;1 1 1 1]; % n x m

figProps.panelWidth = ones(1,figProps.n)*3.6;
figProps.panelHeight = ones(1,figProps.m)*3.6;

figProps.colSpace = [.55 .55 .55;1 1 0;1 1 0;.3 1.25 .3]'; % m x n-1;
figProps.rowSpace = [1 .4 1;1 .4 1;1 .4 1;1 .4 1]'; % n x m - 1;

figProps.colSpacing = figProps.colSpace .* (ones(figProps.n-1,1) * .75);
figProps.rowSpacing = figProps.rowSpace .* (ones(figProps.m-1,1) * 1.3);

figProps.width = 16.8;
figProps.height = 20.5;

figProps.topMargin = .3;
figProps.leftMargin = .5;

[h_fig,h_axes] = createFigPanels7(figProps); % create figure panels 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for group = 1 : 2   % plot average reach trajectory variability (hits vs. misses)
    axes(h_axes(1,group))
    plotPDreachTrajOutcomeSplit(exptOutcomeSummary,group)
    set(gca,'xlabel',[])
    if group == 2
        set(gca,'ylabel',[],'YTickLabel',{' '})
        text(7,7,'reach','FontSize',10)
        line([.75 10.25],[6.3 6.3],'Color','k')    % add stars for significance
        scatter(4.5,6.6,'*','k')
        scatter(5.5,6.6,'*','k')
        scatter(6.5,6.6,'*','k')
    end 
end

for group = 1 : 2
    axes(h_axes(1,group+2))   % plot grasp traj. var. for successful vs. failed reaches (reach)
    plotPDgraspTrajOutcomeSplit(exptOutcomeSummary,group)
    set(gca,'xlabel',[],'ylabel',[],'YTickLabel',{' '})       
    if group == 2
        text(7,7,'grasp','FontSize',10)
        line([.75 10.25],[6.3 6.3],'Color','k')    % add stars for significance
        scatter(4.5,6.6,'*','k')
        scatter(5.5,6.6,'*','k')
        scatter(6.5,6.6,'*','k')
    else
        line([.75 10.25],[6.3 6.3],'Color','k')    % add stars for significance
        scatter(4.5,6.6,'*','k')
        scatter(5.5,6.6,'*','k')
        scatter(6.5,6.6,'*','k')
        text(5.2,7,'#','FontSize',10)
    end
end

for group = 1 : 2
    axes(h_axes(group+1,1))   % plot reach end point (dig2) x - successful vs. failed reaches
	plotOutcomeEndPointXsplit(exptOutcomeSummary,group)
    if group == 1
        set(gca,'XTickLabel',{' '})
        line([.75 10.25],[1.6 1.6],'Color','k','HandleVisibility','off')    % add stars for significance
        scatter(5.5,2,'*','k','HandleVisibility','off')
    end
    set(gca,'xlabel',[])
            
    axes(h_axes(group+1,2))   % plot reach end point (dig2) y - successful vs. failed reaches
    plotOutcomeEndPointYsplit(exptOutcomeSummary,group)
    set(gca,'ylabel',[])
    if group == 1
        set(gca,'xlabel',[],'XTickLabel',{' '})
    end
    legend off
    
    axes(h_axes(group+1,3))   % plot reach end point (dig2) z - successful vs. failed reaches
    plotOutcomeEndPointZsplit(exptOutcomeSummary,group)
    set(gca,'ylabel',[])
    if group == 1
        set(gca,'XTickLabel',{' '})
    end
    set(gca,'xlabel',[])
    legend off
    line([.75 10.25],[9.4 9.4],'Color','k','HandleVisibility','off')    % add stars for significance
    scatter(4.75,10,'*','k','HandleVisibility','off')
    scatter(5.5,10,'*','k','HandleVisibility','off')
    scatter(6.25,10,'*','k','HandleVisibility','off')
end

detValL = calculateDetVarMatrixOutcome(exptOutcomeSummary); % calculate determinant of the covariance matrix for reach endpoints

for group = 1 : 2
    axes(h_axes(4,group))   % plot det. of cov. matrix for hand endpoints
    plotEndPtVarOutcomeSplit(detValL,1,group)
    if group == 2
        set(gca,'ylabel',[],'YTickLabel',{' '})       
    end
    set(gca,'xlabel',[])
    line([.75 10.25],[3700 3700],'Color','k','HandleVisibility','off')    % add stars for significance
    scatter(4.8,3900,'*','k','HandleVisibility','off')
    scatter(5.7,3900,'*','k','HandleVisibility','off')
    
    axes(h_axes(4,group+2)) % plot det. of cov. matrix for digit2 endpoints 
    plotEndPtVarOutcomeSplit(detValL,3,group)
    if group == 2
        set(gca,'ylabel',[],'YTickLabel',{' '})
    end
    set(gca,'xlabel',[])
    line([.75 10.25],[8500 8500],'Color','k','HandleVisibility','off')    % add stars for significance
    scatter(5.5,8900,'*','k','HandleVisibility','off')
end

% add labels, text
h_figAxis = createFigAxes(h_fig);
axes(h_figAxis);

text(.42,.775,'day number','FontSize',10)
text(.42,.1,'day number','FontSize',10)

el1 = annotation('ellipse',[.12 .98 .015 .013]);
el1.Color = [0/255 102/255 0/255];
el1.FaceColor = [0/255 102/255 0/255];
text(.14,.987,'learners','FontSize',10)

el2 = annotation('ellipse',[.22 .98 .015 .013]);
el2.Color = [226/255 88/255 148/255];
el2.FaceColor = [226/255 88/255 148/255];
text(.24,.987,'non-learners','FontSize',10)

text(.22,.76,'x','FontSize',11,'FontWeight','bold')
text(.5,.76,'y','FontSize',11,'FontWeight','bold')
text(.76,.76,'z','FontSize',11,'FontWeight','bold')

text(.275,.315,'paw','FontSize',11,'FontWeight','bold')
text(.68,.315,'digit 2','FontSize',11,'FontWeight','bold')

text(.005,.99,'A','FontSize',12,'FontWeight','bold')
text(.48,.99,'B','FontSize',12,'FontWeight','bold')
text(.005,.76,'C','FontSize',12,'FontWeight','bold')
text(.005,.31,'D','FontSize',12,'FontWeight','bold')
text(.45,.31,'E','FontSize',12,'FontWeight','bold')
 
fig=gcf; % set print properties
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 figProps.width figProps.height];
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];

print(pdfName,'-dpdf'); % save figure  