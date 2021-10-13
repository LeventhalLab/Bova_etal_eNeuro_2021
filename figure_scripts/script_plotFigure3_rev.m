% script_plotFigure3_rev

% makes Figure 3 - eNeuro early learning paper 
% A - empty space to add images showing coordinate (x,y,z) directions
% B - average endpoints of hand and digit 2 in the x, y, z directions
% C - covariances of hand and digit endpoints over 10 sessions, exemplar rat
% D - average endpoint variability (average determinant of covariance
% matrix) - top row: raw data points; bottom row: digit positions
% subtracted from hand position
% E - average percent of frames that were mislabeled by DLC for hand and digit
% tips (sessions 1 and 10)

summaryLoc = '/Volumes/DLC_data/rat kinematic summaries';   % load data
cd(summaryLoc)
load('learning_summaries.mat')
load('succRateWithinSess.mat')
load('slidingWindowKinematics.mat')
load('R0309_kinematicsSummary.mat')
load('learner_summaries.mat')
load('nonLearner_summaries.mat')
load('invalPointsSummary.mat')

pdfName = 'figure3_rev2.pdf';
pdfDir = '/Volumes/DLC_data/DLC_learning_figures/revisions';
pdfName = fullfile(pdfDir,pdfName); % set file name and save directory

% set figure panel properties
figProps.m = 7;
figProps.n = 5;

figProps.colWidths = [1.8 1.9 1.9 0 0;1.8 1.9 1.9 0 0;1.8 1.9 1.9 0 0;...
    1.22 1.22 1.22 1.22 1.22;1.22 1.22 1.22 1.22 1.22;1.2 1.2 1.2 1.2 1.2;1.2 1.2 1.2 1.2 .55]; % m x n
figProps.rowHeights = [.9 .9 1 1 1 .9 .9;.9 .9 1 1 1 .9 .9;.9 .9 1 1 1 .9 .9;1 1 1 1 1 .9 .9;1 1 1 1 1 .9 .9]; % n x m

figProps.panelWidth = ones(1,figProps.n)*1.9;
figProps.panelHeight = ones(1,figProps.m)*2.3;

figProps.colSpace = [.95 .3 0 0;.95 .3 0 0;.95 .3 0 0;0 0 0 0;0 0 0 0;.25 .25 .25 .25;.25 .25 .25 1.3]'; % m x n-1;
figProps.rowSpace = [.2 .2 .5 0 .8 .2;.2 .2 .5 0 .8 .2;.2 .2 .5 0 .8 .2;.2 .2 .5 0 .8 .2;.2 .2 .5 0 .8 .2]'; % n x m - 1;

figProps.colSpacing = figProps.colSpace .* (ones(figProps.n-1,1) * 1);
figProps.rowSpacing = figProps.rowSpace .* (ones(figProps.m-1,1) * 1.3);

figProps.width = 17.5;
figProps.height = 20;

figProps.topMargin = .3;
figProps.leftMargin = .5;

[h_fig,h_axes] = createFigPanels7(figProps); % create figure panels 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

axes(h_axes(1,1))   % remove axes to add in figure of coordinate directions
set(gca,'visible','off')
axes(h_axes(2,1))
set(gca,'visible','off')
axes(h_axes(3,1))
set(gca,'visible','off')

i_coor = 1; % plot average endpoint of paw dorsum in x direction
axes(h_axes(1,2))   
plotAvgDorsumEndptCoorSplit(learner_summary,nonLearner_summary,i_coor,learning_summary)
set(gca,'xlabel',[],'XTickLabel',{' '})
line([.75 10.25],[1.5 1.5],'Color','k')    % add significance marker
text(5.5,2,'#','FontSize',10)

axes(h_axes(1,3))   % plot average endpoint of digit 2 in x direction
plotAvgDig2EndptCoorSplit(learner_summary,nonLearner_summary,i_coor,learning_summary)
set(gca,'ylabel',[],'xlabel',[],'YTickLabel',{' '},'XTickLabel',{' '})
line([.75 10.25],[1.5 1.5],'Color','k')    % add significance markers
text(5.2,2,'#','FontSize',10)
text(5.8,2,'#','FontSize',10)

i_coor = 2;
axes(h_axes(2,2))   % plot average endpoint of paw dorsum in y direction
plotAvgDorsumEndptCoorSplit(learner_summary,nonLearner_summary,i_coor,learning_summary)
set(gca,'xlabel',[],'XTickLabel',{' '})
line([.75 10.25],[15 15],'Color','k')    % add significance marker
scatter(5.5,16,'*','k')

axes(h_axes(2,3))   % plot average endpoint of digit 2 in y direction
plotAvgDig2EndptCoorSplit(learner_summary,nonLearner_summary,i_coor,learning_summary)
set(gca,'ylabel',[],'xlabel',[],'YTickLabel',{' '},'XTickLabel',{' '})

i_coor = 3; % plot average endpoint of paw dorsum in z direction
axes(h_axes(3,2))   
plotAvgDorsumEndptCoorSplit(learner_summary,nonLearner_summary,i_coor,learning_summary)
set(gca,'xlabel',[])

axes(h_axes(3,3))   % plot average endpoint of digit 2 in z direction 
plotAvgDig2EndptCoorSplit(learner_summary,nonLearner_summary,i_coor,learning_summary)
set(gca,'ylabel',[],'xlabel',[],'YTickLabel',{' '})

for i_sess = 1 : 5  % plot covariance ellipses of paw and digit endpoints for sessions 1-10 from exemplar rat
    axes(h_axes(4,i_sess))
    plotCovEllipses(ratSummary,thisRatInfo,i_sess)
    set(gca,'ylabel',[],'YTickLabel',{' '})
    if i_sess > 1
        set(gca,'zlabel',[],'ZTickLabel',{' '})
    end
    if i_sess < 5
        set(gca,'xlabel',[],'XTickLabel',{' '})
    end
end
for i_sess = 6 : 10
    axes(h_axes(5,i_sess-5))
    plotCovEllipses(ratSummary,thisRatInfo,i_sess)
    if i_sess > 6
        set(gca,'zlabel',[],'ylabel',[],'ZTickLabel',{' '})
    end
    if i_sess < 10
        set(gca,'xlabel',[],'XTickLabel',{' '})
    end
end

detVal = calculateDetVarMatrix; % calculate average determinant of covariance matrix for all parts, all rats
axes(h_axes(6,5))
plotVarEndPoint_split(detVal,5) % plot average determinant of covariance matrix for paw dorsum endpoint
set(gca,'ylabel',[],'YTickLabel',{' '},'xlabel',[],'XTickLabel',{' '})
line([.75 10.25],[9000 9000],'Color','k')    % add stars for significance
scatter(5.5,10000,'*','k')
set(gca,'ylim',[1E1 1E5],'ytick',[1E1 1E3 1E5])

axes(h_axes(6,1))
plotVarEndPoint_split(detVal,1) % plot average determinant of covariance matrix for digit 1
set(gca,'xlabel',[],'XTickLabel',{' '})
set(gca,'ylim',[1E1 1E5],'ytick',[1E1 1E3 1E5])

axes(h_axes(6,2))
plotVarEndPoint_split(detVal,2) % plot average determinant of covariance matrix for digit 2
set(gca,'ylabel',[],'YTickLabel',{' '},'xlabel',[],'XTickLabel',{' '})
line([.75 10.25],[9000 9000],'Color','k')    % add stars for significance
scatter(5.5,10000,'*','k')
set(gca,'ylim',[1E1 1E5],'ytick',[1E1 1E3 1E5])

axes(h_axes(6,3))
plotVarEndPoint_split(detVal,3) % plot average determinant of covariance matrix for digit 3
set(gca,'ylabel',[],'YTickLabel',{' '},'xlabel',[],'XTickLabel',{' '})
set(gca,'ylim',[1E1 1E5],'ytick',[1E1 1E3 1E5])

axes(h_axes(6,4))
plotVarEndPoint_split(detVal,4) % plot average determinant of covariance matrix for digit 4
set(gca,'ylabel',[],'YTickLabel',{' '},'xlabel',[],'XTickLabel',{' '})
set(gca,'ylim',[1E1 1E5],'ytick',[1E1 1E3 1E5])

detVal = calculateDetVarMatrixfromPaw;  % calculates average determinant of covariance matrix for digit positions subtracted from paw dorsum position
axes(h_axes(7,1))
plotVarEndPoint_split(detVal,1) % plot average determinant of covariance matrix for digit 1
set(gca,'xlabel',[],'ylabel',[],'ylim',[0 100],'ytick',[0 50 100])
set(gca,'ylim',[0.1 1E3],'ytick',[0.1 1E1 1E3])

axes(h_axes(7,2))
plotVarEndPoint_split(detVal,2) % plot average determinant of covariance matrix for digit 2
set(gca,'xlabel',[],'ylabel',[],'YTickLabel',{' '},'ylim',[0 100],'ytick',[0 50 100])
line([.75 10.25],[90 90],'Color','k')    % add stars for significance
scatter(5.5,100,'*','k')
set(gca,'ylim',[0.1 1E3],'ytick',[0.1 1E1 1E3])

axes(h_axes(7,3))
plotVarEndPoint_split(detVal,3) % plot average determinant of covariance matrix for digit 3
set(gca,'xlabel',[],'ylabel',[],'YTickLabel',{' '},'ylim',[0 100],'ytick',[0 50 100])
set(gca,'ylim',[0.1 1E3],'ytick',[0.1 1E1 1E3])

axes(h_axes(7,4))
plotVarEndPoint_split(detVal,4) % plot average determinant of covariance matrix for digit 3
set(gca,'xlabel',[],'ylabel',[],'YTickLabel',{' '},'ylim',[0 100],'ytick',[0 50 100])
set(gca,'ylim',[0.1 1E3],'ytick',[0.1 1E1 1E3])

axes(h_axes(7,5))   % plot the percent of frames that were mislabeled by DLC for paw, digit tips on D1 and D10
plotPercentInvalPoints(invalPointsAllRats)
legend off


% add labels, text
h_figAxis = createFigAxes(h_fig);
axes(h_figAxis);

text(.47,.98,'paw','FontSize',10,'FontWeight','bold')
text(.68,.98,'digit 2','FontSize',10,'FontWeight','bold')

el1 = annotation('ellipse',[.03 .6 .015 .013]);
el1.Color = [81/266 91/255 135/255];
el1.FaceColor = [81/266 91/255 135/255];
el2 = annotation('ellipse',[.1 .6 .015 .013]);
el2.Color = [147/255 169/255 209/255];
el2.FaceColor = [147/255 169/255 209/255];
el3 = annotation('ellipse',[.19 .6 .015 .013]);
el3.Color = [183/255 108/255 164/255];
el3.FaceColor = [183/255 108/255 164/255];
el4 = annotation('ellipse',[.03 .57 .015 .013]);
el4.Color = [228/255 187/255 37/255];
el4.FaceColor = [228/255 187/255 37/255];
el5 = annotation('ellipse',[.12 .57 .015 .013]);
el5.Color = [136/255 176/255 75/255];
el5.FaceColor = [136/255 176/255 75/255];
text(.05,.61,'paw','FontSize',10)
text(.12,.61,'digit 1','FontSize',10)
text(.21,.61,'digit 2','FontSize',10)
text(.05,.58,'digit 3','FontSize',10)
text(.14,.58,'digit 4','FontSize',10)

text(.55,.58,'day number','FontSize',10)

text(.15,.55,'S1','FontSize',10)
text(.275,.55,'S2','FontSize',10)
text(.41,.55,'S3','FontSize',10)
text(.54,.55,'S4','FontSize',10)
text(.67,.55,'S5','FontSize',10)
text(.15,.43,'S6','FontSize',10)
text(.275,.43,'S7','FontSize',10)
text(.41,.43,'S8','FontSize',10)
text(.54,.43,'S9','FontSize',10)
text(.67,.43,'S10','FontSize',10)

text(.175,.305,'digit 1','FontSize',10,'FontWeight','bold')
text(.31,.305,'digit 2','FontSize',10,'FontWeight','bold')
text(.46,.305,'digit 3','FontSize',10,'FontWeight','bold')
text(.6,.305,'digit 4','FontSize',10,'FontWeight','bold')
text(.75,.305,'paw','FontSize',10,'FontWeight','bold')

text(.005,.98,'A','FontSize',12,'FontWeight','bold')
text(.29,.98,'B','FontSize',12,'FontWeight','bold')
text(.005,.6,'C','FontSize',12,'FontWeight','bold')
text(.005,.32,'D','FontSize',12,'FontWeight','bold')
text(.005,.18,'E','FontSize',12,'FontWeight','bold')
text(.7,.18,'F','FontSize',12,'FontWeight','bold')

fig=gcf; % set print properties
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 figProps.width figProps.height];
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];

print(pdfName,'-painters','-dpdf'); % save figure 
