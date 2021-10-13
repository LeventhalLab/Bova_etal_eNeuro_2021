function plotVarEndPointIndiv_split(detVal,part,group)

% plots individual rats' average determinant of the covariance matrix
% across sessions for paw/digit reach endpoints

% pull out data for selected paw part
if part == 5 % paw
    data_l = detVal(1).paw;
    data_n = detVal(2).paw;
    ylab_text = 'hand';
elseif part == 1    % dig1
    data_l = detVal(1).dig1;
    data_n = detVal(2).dig1;
    ylab_text = 'digit 1';
elseif part == 2    % dig2
    data_l = detVal(1).dig2;
    data_n = detVal(2).dig2;
    ylab_text = 'digit 2';
elseif part == 3    % dig3
    data_l = detVal(1).dig3;
    data_n = detVal(2).dig3;
    ylab_text = 'digit 3';
elseif part == 4    % dig4
    data_l = detVal(1).dig4;
    data_n = detVal(2).dig4;
    ylab_text = 'digit 4';
end 

% set plot colors
if group == 1
    plot_color = {[0/255 102/255 0/255] [95/255 130/255 226/255] [216/255 85/255 116/255] [212/255 216/255 85/255]};
    data = data_l;
else
    plot_color = {[0/255 102/255 0/255] [95/255 130/255 226/255] [216/255 85/255 116/255] [212/255 216/255 85/255] [1 153/255 51/255]...
        [185/255 122/255 212/255] [210/255 21/255 21/255] [33/255 13/255 134/255] [160/255 160/255 160/255] [106/255 216/255 102/255]};
    data = data_n;
end

num_rats = size(data,1);

% set marker sizes
indMarkerSize = 3;

for i_rat = 1 : num_rats % plot individual rat data
    plot(1:10,data(i_rat,:),'-o','MarkerSize',indMarkerSize,'Color',plot_color{i_rat},'MarkerEdgeColor',...
        plot_color{i_rat},'MarkerFaceColor',plot_color{i_rat});
    hold on
end     

% figure properties
ylabel(ylab_text,'FontSize',10,'FontWeight','bold')
xlabel('session number')
set(gca,'Yscale','log')
set(gca,'ylim',[1 1E5],'ytick',[1 1E2 1E5])
% set(gca,'ylim',[0 32000],'ytick',[0 16000 32000]);
set(gca,'xlim',[.5 10.5]);
set(gca,'xtick',[2 4 6 8 10]);
set(gca,'FontSize',10);
box off