% script_plotFigure4_rev

% creates Figure 4 (eNeuro early learning skilled reaching)
% A - avg. reach and grasp trajectory variabilities of digit 2
% B - within session changes in reach trajectory variability
% C - blank space for diagram/image showing how aperture was measured
% D - avg. aperture at reach end across sessions
% E - within session changes in aperture at reach end
% F - avg. aperture variance across sessions
% G - blank space for diagram/image showing how paw orientation was
%     measured
% H - avg. paw orientation at reach end across sessions
% I - within session changes in paw orientation at reach end
% J - avg. orientation MRL across sessions
% K - blank space for diagram/images showing how digit flexion was measured
% L - avg. digit flexion at reach end across sessions
% M - within session changes in digit flexion at reach end
% N - avg. digit flexion MRL across sessions

summaryLoc = '/Volumes/DLC_data/rat kinematic summaries';   % load data
cd(summaryLoc)
load('learner_summaries.mat')
load('nonLearner_summaries.mat')
load('slidingWindowKinematics.mat')
load('learning_summaries.mat')

pdfName = 'figure4_rev2.pdf';
pdfDir = '/Volumes/DLC_data/DLC_learning_figures/revisions';
pdfName = fullfile(pdfDir,pdfName); % set file name and save directory

% set figure panel properties
figProps.m = 4;
figProps.n = 13;

figProps.colWidths = [.95 .95 .3 .3 .3 .3 .3 .3 .3 .3 .3 .3 0;.6 .88 .21 .21 .21 .21 .21 .21 .21 .21 .21 .21 .88;...
    .6 .88 .21 .21 .21 .21 .21 .21 .21 .21 .21 .21 .88;.6 .88 .21 .21 .21 .21 .21 .21 .21 .21 .21 .21 .88]; % m x n
figProps.rowHeights = [1 1 1 1;1 1 1 1;1 1 1 1;1 1 1 1;1 1 1 1;1 1 1 1;1 1 1 1;1 1 1 1;...
    1 1 1 1;1 1 1 1;1 1 1 1;1 1 1 1;1 1 1 1]; % n x m

figProps.panelWidth = ones(1,figProps.n)*3;
figProps.panelHeight = ones(1,figProps.m)*3;

figProps.colSpace = [.25 .6 .08 .08 .08 .08 .08 .08 .08 .08 .08 0;.55 .3 .08 .08 .08 .08 .08 .08 .08 .08 .08 1.2;...
   .55 .3 .08 .08 .08 .08 .08 .08 .08 .08 .08 1.2;.55 .3 .08 .08 .08 .08 .08 .08 .08 .08 .08 1.2]'; % m x n-1;
figProps.rowSpace = [1 .4 .4;1 .4 .4;1 .4 .4;1 .4 .4;1 .4 .4;1 .4 .4;...
    1 .4 .4;1 .4 .4;1 .4 .4;1 .4 .4;1 .4 .4;1 .4 .4;1 .4 .4]'; % n x m - 1;

figProps.colSpacing = figProps.colSpace .* (ones(figProps.n-1,1) * 1);
figProps.rowSpacing = figProps.rowSpace .* (ones(figProps.m-1,1) * 1.3);

figProps.width = 21;
figProps.height = 16;

figProps.topMargin = .5;
figProps.leftMargin = .5;

[h_fig,h_axes] = createFigPanels7(figProps); % create figure panels 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
axes(h_axes(1,1))   % plot average digit 2 reach trajectory variability
plotAverageVariablityReachDigSplit(learner_summary,nonLearner_summary,learning_summary)
text(6.8,8,'reach','FontSize',10)
set(gca,'xlabel',[])

axes(h_axes(1,2))   % plot average digit 2 grasp trajectory variability against first reach success rate
plotAverageVariablityGraspDigSplit(learner_summary,nonLearner_summary,learning_summary)
line([.75 10.25],[7 7],'Color','k')    % add stars for significance
scatter(4.7,7.5,'*','k')
scatter(5.5,7.5,'*','k')
scatter(6.4,7.5,'*','k')
text(5.5,8,'#','FontSize',10)
text(6.8,8,'grasp','FontSize',10)
set(gca,'ylabel',[],'YTickLabel',{' '},'xlabel',[]);

script_findLearners     % find learners vs. non-learners

num_bins = 30;  % set number of 10 trial averages to plot (x axis)
for session = 1 : 10    % plot within session changes in mean dist. from avg. traj. (digit 2, reach)
    axes(h_axes(1,session+2))
    plotWithinSessTrajVarDigitSplit(slidingWindowKinematics,session,learningRats,num_bins)
    set(gca,'ylabel',[],'YTickLabel',{' '});
    if session > 1         
        set(gca,'ycolor',[1 1 1])
    end
end 

axes(h_axes(2,1))   % clear axes for image showing aperture measurement
set(gca,'visible','off')

axes(h_axes(2,2))   % plot average aperture at reach end for 10 sessions
plotAvgEndAperSplit(learner_summary,nonLearner_summary,learning_summary)
set(gca,'xlabel',[],'XTickLabel',{' '});

for session = 1 : 10    % plot within session changes in aperture at reach end 
    axes(h_axes(2,session+2))
    plotWithinSessAperSplit2(slidingWindowKinematics,session,num_bins)
    set(gca,'ylabel',[]);
    set(gca,'xlabel',[],'xtick',[30],'YTickLabel',{' '},'XTickLabel',{' '});
    if session > 1    
        set(gca,'ycolor',[1 1 1])
    end
end 

axes(h_axes(2,13))  % plot average variability of aperture at reach end for 10 sessions
plotAvgEndAperVarSplit(learner_summary,nonLearner_summary,learning_summary)
set(gca,'xlabel',[],'XTickLabel',{' '});

axes(h_axes(3,1))   % clear axes for image showing paw orientation measurement
set(gca,'visible','off')

axes(h_axes(3,2))   % plot average paw orientation at reach end for 10 sessions
plotAvgEndOrientSplit(learner_summary,nonLearner_summary,learning_summary)
line([.75 10.25],[58 58],'Color','k')    % add stars for significance
scatter(5,60,'*','k')
scatter(6,60,'*','k')
set(gca,'xlabel',[],'XTickLabel',{' '});

for session = 1 : 10    % plot within session changes in paw orientation at reach end 
    axes(h_axes(3,session+2))
    plotWithinSessOrientSplit(slidingWindowKinematics,session,num_bins)
    set(gca,'ylabel',[],'YTickLabel',{' '});
    set(gca,'xlabel',[],'xtick',[30],'XTickLabel',{' '});
    if session > 1    
        set(gca,'ycolor',[1 1 1])
    end
end 

axes(h_axes(3,13))  % plot average variability (MRL) of paw orientation at reach end for 10 sessions
plotAvgEndOrientVarSplit(learner_summary,nonLearner_summary,learning_summary)
set(gca,'xlabel',[],'XTickLabel',{' '});

axes(h_axes(4,1))   % clear axes for image showing digit flexion measurement
set(gca,'visible','off')

axes(h_axes(4,2))   % plot average digit flexion degree at reach end for 10 sessions
plotAvgEndFlexSplit(learner_summary,nonLearner_summary,learning_summary)

for session = 1 : 10    % plot within session changes in digit flexion degree at reach end 
    axes(h_axes(4,session+2))
    plotWithinSessFlexSplit(slidingWindowKinematics,session,num_bins)
    set(gca,'ylabel',[],'YTickLabel',{' '});
    if session > 1    
        set(gca,'ycolor',[1 1 1])
    end
end 

axes(h_axes(4,13))  % plot average variability (MRL) of digit flexion degree at reach end for 10 sessions
plotAvgEndFlexVarSplit(learner_summary,nonLearner_summary,learning_summary)

% add labels, text
h_figAxis = createFigAxes(h_fig);
axes(h_figAxis);

text(.81,.968,'reach','FontSize',10)
text(.175,.765,'day number','FontSize',10)

text(.005,.99,'A','FontSize',12,'FontWeight','bold')
text(.37,.99,'B','FontSize',12,'FontWeight','bold')
text(.005,.72,'C','FontSize',12,'FontWeight','bold')
text(.12,.72,'D','FontSize',12,'FontWeight','bold')
text(.32,.72,'E','FontSize',12,'FontWeight','bold')
text(.675,.72,'F','FontSize',12,'FontWeight','bold')
text(.005,.49,'G','FontSize',12,'FontWeight','bold')
text(.12,.49,'H','FontSize',12,'FontWeight','bold')
text(.325,.49,'I','FontSize',12,'FontWeight','bold')
text(.675,.49,'J','FontSize',12,'FontWeight','bold')
text(.005,.27,'K','FontSize',12,'FontWeight','bold')
text(.12,.27,'L','FontSize',12,'FontWeight','bold')
text(.315,.27,'M','FontSize',12,'FontWeight','bold')
text(.675,.27,'N','FontSize',12,'FontWeight','bold')

fig=gcf; % set print properties
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 figProps.width figProps.height];
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];

print(pdfName,'-dpdf'); % save figure