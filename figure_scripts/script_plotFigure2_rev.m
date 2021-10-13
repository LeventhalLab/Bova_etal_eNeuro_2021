% script_plotFigure2_rev

% creates Figure 2 (eNeuro early learning skilled reaching)
% A - example trajectories from 1 rat for Days 1 and Day 10 of training
% B - empty space for images of reach and grasp starts/ends
% C - average trajectory variability of the hand across sessions
%       (reach and grasp components)
% D - within session changes in trajectory variability (reach component)
%       plotted against within session changes in first reach success rate
% E - average duration of reaches
% F - average max velocity of reaches

summaryLoc = '/Volumes/DLC_data/rat kinematic summaries';   % load in data structures
cd(summaryLoc)
load('learning_summaries.mat')
load('succRateWithinSess.mat')
load('slidingWindowKinematics.mat')
load('learner_summaries.mat')
load('nonLearner_summaries.mat')

pdfName = 'figure2_rev.pdf';
pdfDir = '/Volumes/DLC_data/DLC_learning_figures/revisions';
pdfName = fullfile(pdfDir,pdfName); % set file name and save directory

% set figure panel properties
figProps.m = 5;
figProps.n = 10;

figProps.colWidths = [1.65 1.65 0 0 0 0 0 0 0 0;1.25 .9 .9 0 0 0 0 0 0 0;.3 .3 .3 .3 .3 .3 .3 .3 .3 .3;.3 .3 .3 .3 .3 .3 .3 .3 .3 .3;1.4 1.4 0 0 0 0 0 0 0 0]; % m x n
figProps.rowHeights = [1 1 .6 .6 1;1 1 .6 .6 1;1 1 .6 .6 1;1 1 .6 .6 1;1 1 .6 .6 1;1 1 .6 .6 1;1 1 .6 .6 1;1 1 .6 .6 1;1 1 .6 .6 1;1 1 .6 .6 1]; % n x m

figProps.panelWidth = ones(1,figProps.n)*3;
figProps.panelHeight = ones(1,figProps.m)*3;

figProps.colSpace = [.2 0 0 0 0 0 0 0 0;.5 .2 0 0 0 0 0 0 0;.1 .1 .1 .1 .1 .1 .1 .1 .1;.1 .1 .1 .1 .1 .1 .1 .1 .1;1.9 0 0 0 0 0 0 0 0]'; % m x n-1;
figProps.rowSpace = [1 .7 .5 1.2;1 .7 .5 1.2;1 .7 .5 1.2;1 .7 .5 1.2;1 .7 .5 1.2;1 .7 .5 1.2;1 .7 .5 1.2;1 .7 .5 1.2;1 .7 .5 1.2;1 .7 .5 1.2]'; % n x m - 1;

figProps.colSpacing = figProps.colSpace .* (ones(figProps.n-1,1) * 1);
figProps.rowSpacing = figProps.rowSpace .* (ones(figProps.m-1,1) * 1.3);

figProps.width = 15.5;
figProps.height = 18.5;

figProps.topMargin = .3;
figProps.leftMargin = .5;

[h_fig,h_axes] = createFigPanels7(figProps); % create figure panels 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
axes(h_axes(1,1))   % plot individual trial and average reach trajectories from session 1 from exemplar rat
plotSessionTraj(1)
set(gca,'xlabel',[])
legend off

axes(h_axes(1,2))   % plot individual trial and average reach trajectories from session 10 from exemplar rat
plotSessionTraj(10)
set(gca,'YTickLabel',{' '})
set(gca,'ZTickLabel',{' '})
set(gca,'ylabel',[],'zlabel',[])

axes(h_axes(2,1))   % get rid of axes to add graphic of reach and grasp starts and ends in illustrator later
set(gca,'visible','off')

axes(h_axes(2,2))   % plot average trajectory variability for reach 
plotAverageVariablityReachPawSplit(learner_summary,nonLearner_summary,learning_summary)
text(.75,7,'reach','FontSize',10)
set(gca,'xlabel',[])

axes(h_axes(2,3))   % plot average trajectory variability for grasp 
plotAverageVariablityGraspPawSplit(learner_summary,nonLearner_summary,learning_summary)
text(.75,7,'grasp','FontSize',10)
line([.75 10.25],[6.5 6.5],'Color','k','HandleVisibility','off')    % add stars for significance
scatter(5,6.8,'*','k','HandleVisibility','off')
scatter(6,6.8,'*','k','HandleVisibility','off')
set(gca,'ylabel',[])
set(gca,'YTickLabel',{' '});
set(gca,'xlabel',[]);

script_findLearners     % run script that finds the learners vs. non-learners

grp = 'l';  % set current group to plot
num_bins = 30;  % set number of trial averages to include in x axis 
for session = 1 : 10
    axes(h_axes(3,session)) % plot within session changes in trajectory variability against changes in success rate
    plotWithinSessSuccRateSplit(successRateWithinSession,slidingWindowKinematics,session,learningRats,grp,num_bins)
    if session > 1
        yyaxis left
        set(gca,'ylabel',[],'YTickLabel',{' '});
        set(gca,'ycolor',[1 1 1])
    end
    if session < 10
        yyaxis right
        set(gca,'ylabel',[],'YTickLabel',{' '});
        set(gca,'ycolor',[1 1 1])
    end
    set(gca,'XTickLabel',{' '})
end 

grp = 'n';
num_bins = 30;  % set number of trial averages to include in x axis 
for session = 1 : 10
    axes(h_axes(4,session)) % plot within session changes in trajectory variability against changes in success rate
    plotWithinSessSuccRateSplit(successRateWithinSession,slidingWindowKinematics,session,learningRats,grp,num_bins)
    yyaxis left
    set(gca,'ylabel',[])
    if session > 1
        yyaxis left
        set(gca,'ylabel',[],'YTickLabel',{' '});
        set(gca,'ycolor',[1 1 1])
    end
    if session < 10
        yyaxis right
        set(gca,'ylabel',[],'YTickLabel',{' '});
        set(gca,'ycolor',[1 1 1])
    end

end 

axes(h_axes(5,1))   % plot average duration of reach
plotReachDurationSplit(learner_summary,nonLearner_summary,learning_summary)

axes(h_axes(5,2))   % plot average velocity of reach
plotReachVelocitySplit(learner_summary,nonLearner_summary,learning_summary)

% add labels, text
h_figAxis = createFigAxes(h_fig);
axes(h_figAxis);

text(.13,.98,'session 1','FontSize',10)
text(.46,.98,'session 10','FontSize',10)
text(.49,.555,'day number','FontSize',10)
text(.04,.29,'trial #:','FontSize',10)
text(.065,.27,'day:','FontSize',10)

text(.005,.99,'A','FontSize',12,'FontWeight','bold')
text(.005,.76,'B','FontSize',12,'FontWeight','bold')
text(.25,.76,'C','FontSize',12,'FontWeight','bold')
text(.005,.545,'D','FontSize',12,'FontWeight','bold')
text(.005,.24,'E','FontSize',12,'FontWeight','bold')
text(.4,.235,'F','FontSize',12,'FontWeight','bold')
 
fig=gcf; % set print properties
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 figProps.width figProps.height];
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];

print(pdfName,'-dpdf'); % save figure  