function plotEndPtVarOutcomeSplit(detValL,i_paw,group)

% plots endpoint variability for successful vs. failed reaches

if group == 1   % set plot colors
    succColor = [0/255 102/255 0/255];
else
    succColor = [226/255 88/255 148/255]; 
end
failColor = 'k';

if i_paw == 1   % pull out data 
    data = detValL(group).paw(:,:,:);
elseif i_paw == 3
    data = detValL(group).dig2(:,:,:);
end

for i_outcome = 1:2     % calculate averages and s.e.m. for each outcome type
    for i_sess = 1:10      
        avgData(i_sess,i_outcome) = nanmean(data(:,i_sess,i_outcome),1);  
        numDataPoints = sum(~isnan(data(:,i_sess,i_outcome)));
        errBars(i_sess,i_outcome) = nanstd(data(:,i_sess,i_outcome),0)./sqrt(numDataPoints); 
    end 
end 

% set marker sizes
avgMarkerSize = 45;

% plot data
scatter(1:10,avgData(1:10,1),avgMarkerSize,'MarkerEdgeColor',succColor,'MarkerFaceColor',succColor);
hold on
e = errorbar(1:10,avgData(1:10,1),errBars(1:10,1),'linestyle','none','HandleVisibility','off');
e.Color = succColor;
scatter(1:10,avgData(1:10,2),avgMarkerSize,'MarkerEdgeColor',failColor,'MarkerFaceColor',failColor);
e1 = errorbar(1:10,avgData(1:10,2),errBars(1:10,2),'linestyle','none','HandleVisibility','off');
e1.Color = failColor;

% figure properties
set(gca,'Yscale','log')
if i_paw == 1
    set(gca,'ylim',[1E-1 1E4],'ytick',[1E-1 1E2 1E4]);
else
    set(gca,'ylim',[1E0 1E5],'ytick',[1E0 1E3 1E5]);
end

box off
set(gca,'xlim',[.5 10.5])
set(gca,'xtick',[2:2:10]);
set(gca,'FontSize',10);
ylabel({'endpoiint variability'})
xlabel('session number')

end