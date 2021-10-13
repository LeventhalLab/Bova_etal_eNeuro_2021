% script_plotFigure3_supp2_rev

% creates Extended Data Figure 3-2 (eNeuro early learning skilled reaching)
% plots individual rats average determinant of the covariance matrix for
% reach endpoints (paw dorsum and digits)
% - left columns for digits is calculated using raw digit positions
% - right column for digits in calculated using digit positions subtracted
%   from paw dorsum position

summaryLoc = '/Volumes/DLC_data/rat kinematic summaries';   % load data
cd(summaryLoc)
load('learner_summaries.mat')
load('nonLearner_summaries.mat')

pdfName = 'figure3_supp2_rev2.pdf';
pdfDir = '/Volumes/DLC_data/DLC_learning_figures/revisions';
pdfName = fullfile(pdfDir,pdfName); % set file name and save directory

% set figure panel properties
figProps.m = 5;
figProps.n = 4;

figProps.colWidths = [1 1.15 1.15 1;1 1 1 1;1 1 1 1;1 1 1 1;1 1 1 1]; % m x n
figProps.rowHeights = [1 1 1 1 1;1 1 1 1 1;1 1 1 1 1;1 1 1 1 1]; % n x m

figProps.panelWidth = ones(1,figProps.n)*2;
figProps.panelHeight = ones(1,figProps.m)*2;

figProps.colSpace = [1 1 1;1 2.5 1;1 2.5 1;1 2.5 1;1 2.5 1]'; % m x n-1;
figProps.rowSpace = [1.2 1 1 1;1.2 1 1 1;1.2 1 1 1;1.2 1 1 1]'; % n x m - 1;

figProps.colSpacing = figProps.colSpace .* (ones(figProps.n-1,1) * .3);
figProps.rowSpacing = figProps.rowSpace .* (ones(figProps.m-1,1) * .5);

figProps.width = 13;
figProps.height = 14;

figProps.topMargin = .6;
figProps.leftMargin = .5;

[h_fig,h_axes] = createFigPanels7(figProps); % create figure panels 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
axes(h_axes(1,1))   % clear axes
set(gca,'visible','off')
axes(h_axes(1,4))
set(gca,'visible','off')

detVal = calculateDetVarMatrix; % calculate the average determinant of the covariance matrix for paw dorsum/digit reach endpoints
for group = 1 : 2   % plot individual rats' det. of the cov. matrix for paw dorsum endpoint across sessions
    axes(h_axes(1,group+1))
    plotVarEndPointIndiv_split(detVal,5,group)
    if group == 2
        set(gca,'ylabel',[],'YTickLabel',{' '})
        text(2.85,9950,'non-learners','FontSize',9)
    else
        text(5,9950,'learners','FontSize',9)
    end
    set(gca,'xlabel',[],'XTickLabel',{' '})
    %set(gca,'ylim',[0 10000],'ytick',[0 5000 10000]);
end

for group = 1 : 2   % plot individual rats' det. of the cov. matrix for digit endpoints across sessions (raw position data)
    for part = 1 : 4
        axes(h_axes(part+1,group))
        plotVarEndPointIndiv_split(detVal,part,group)
        if part < 4
            set(gca,'XTickLabel',{' '})
        end
        if group > 1 
            set(gca,'YTickLabel',{' '},'ylabel',[])
        end
        set(gca,'xlabel',[])
        if part == 1 && group == 1
            text(5,31500,'learners','FontSize',9)
        elseif part == 1 && group == 2
            text(1.8,31500,'non-learners','FontSize',9)
        end
    end
end

detVal = calculateDetVarMatrixfromPaw;  % calculate the average determinant of the covariance matrix for digit reach endpoints (subtracted position)
for group = 1 : 2
    for part = 1 : 4    % plot individual rats' det. of the cov. matrix for digit endpoints across sessions (subtracted position data)
        axes(h_axes(part+1,group+2))
        plotVarEndPointIndiv_split(detVal,part,group)
        if part < 4
            set(gca,'xlabel',[],'XTickLabel',{' '})
        end
        if group > 1 
            set(gca,'YTickLabel',{' '})
        end
        set(gca,'ylabel',[],'xlabel',[])
        set(gca,'ylim',[1E-2 1E3],'ytick',[1E-2 1 1E3]);
        if part == 1 && group == 1
            text(5,218,'learners','FontSize',9)
        elseif part == 1 && group == 2
            text(1.8,218,'non-learners','FontSize',9)
        end
    end
   
end

% add labels, text
h_figAxis = createFigAxes(h_fig);
axes(h_figAxis);

h = text(.01,.36,'endpoint variability','FontSize',10);
set(h,'Rotation',90)
text(.4,.035,'day number','FontSize',10)

fig=gcf; % set print properties
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 figProps.width figProps.height];
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];

print(pdfName,'-dpdf'); % save figure  
