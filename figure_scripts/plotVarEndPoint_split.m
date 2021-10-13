function plotVarEndPoint_split(detVal,part)

% plots average determinant of the covariance matrix for endpoint of paw
% part (part) over sessions for learners, non-learners, all rats combined

if part == 5    % pull out appropriate paw part data
    data_l = detVal(1).paw;
    data_n = detVal(2).paw;
elseif part == 1
    data_l = detVal(1).dig1;
    data_n = detVal(2).dig1;
elseif part == 2
    data_l = detVal(1).dig2;
    data_n = detVal(2).dig2;
elseif part == 3
    data_l = detVal(1).dig3;
    data_n = detVal(2).dig3;
elseif part == 4
    data_l = detVal(1).dig4;
    data_n = detVal(2).dig4;
end 

data_all = [data_l;data_n]; % combine data from all rats

avgData_l = nanmean(data_l,1);  % calculate averages
avgData_n = nanmean(data_n,1);
avgData_all = nanmean(data_all,1);

numDataPts_l = sum(~isnan(data_l),1);
errbars_l = nanstd(data_l,0,1)./sqrt(numDataPts_l);   % calculate s.e.m. (learners and non-learners)
numDataPts_n = sum(~isnan(data_n),1);
errbars_n = nanstd(data_n,0,1)./sqrt(numDataPts_n);

% set plot colors
l_color = [0/255 102/255 0/255];
n_color = [226/255 88/255 148/255];

% set marker sizes
avgMarkerSize = 40; 

line(1:10,avgData_all,'Color','k','lineWidth',5)    % plot all rat data average
hold on
scatter(1:10,avgData_l,avgMarkerSize,'filled','MarkerEdgeColor',l_color,'MarkerFaceColor',l_color); % plot average learners
el = errorbar(1:10,avgData_l,errbars_l,'linestyle','none');      % add error bars
el.Color = l_color;
scatter(1:10,avgData_n,avgMarkerSize,'filled','MarkerEdgeColor',n_color,'MarkerFaceColor',n_color); % plot average non-learners
el = errorbar(1:10,avgData_n,errbars_n,'linestyle','none');      % add error bars
el.Color = n_color;

% figure properties
ylabel('endpoint variability','FontSize',10)
xlabel('session number')
% set(gca,'ylim',[0 10000],'ytick',[0 5000 10000]);
%set(gca,'ylim',[1E1 1E5])
set(gca,'xlim',[.5 10.5]);
set(gca,'xtick',[2 4 6 8 10]);
set(gca,'FontSize',10);
box off
set(gca,'Yscale','log')