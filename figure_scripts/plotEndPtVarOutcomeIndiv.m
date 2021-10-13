function plotEndPtVarOutcomeIndiv(detValL,i_paw,group,i_out)

% plots endpoint variability for successful vs. failed reaches

if group == 1   % set plot colors
    succColor = {[0/255 102/255 0/255] [95/255 130/255 226/255] [216/255 85/255 116/255] [212/255 216/255 85/255]};
else
    succColor = {[0/255 102/255 0/255] [95/255 130/255 226/255] [216/255 85/255 116/255] [212/255 216/255 85/255] [1 153/255 51/255]...
        [185/255 122/255 212/255] [210/255 21/255 21/255] [33/255 13/255 134/255] [160/255 160/255 160/255] [106/255 216/255 102/255]}; 
end

if i_paw == 1   % pull out data 
    data = detValL(group).paw(:,:,i_out);
elseif i_paw == 3
    data = detValL(group).dig2(:,:,i_out);
end

num_rats = size(data,1);


% set marker sizes
markerSize = 4;

% plot data
for i_rat = 1 : num_rats
    plot(1:10,data(i_rat,:),'-o','MarkerSize',markerSize,'Color',succColor{i_rat},'MarkerEdgeColor',...
        succColor{i_rat},'MarkerFaceColor',succColor{i_rat});  
    hold on
end 

%figure properties
set(gca,'Yscale','log')
if i_paw == 1
    set(gca,'ylim',[1E-5 1E5],'ytick',[1E-5 1E0 1E5]);
    ylabel({'hand';'endpoint variability'})
else
    set(gca,'ylim',[1E-5 1E5],'ytick',[1E-5 1E0 1E5]);
    ylabel({'digit 2';'endpoint variability'})
end

box off
set(gca,'xlim',[.5 10.5])
set(gca,'xtick',[2:2:10]);
set(gca,'FontSize',10);
xlabel('day number')

end