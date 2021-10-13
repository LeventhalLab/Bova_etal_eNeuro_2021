function plot_3Dtraj_full(curSessData,avgSessData,iSess,pawPref)

% makes 3d plot of individual reach trajectories and average

pawColor = [81/266 91/255 135/255]; % set line colors for paw and digits
digColor = {[147/255 169/255 209/255] [183/255 108/255 164/255] [228/255 187/255 37/255] [136/255 176/255 75/255]};

% figure properties
lnWdth = .8;
full_traj_z_lim = [-5 40];
x_lim = [-30 10];
y_lim = [-35 10];

for iTrial = 1:size(curSessData,2) % plot individual reach trajectories (4 digit tips + paw dorsum) for each trial/reach
    clear curPdData
    clear curDigData
    if isempty(curSessData(iTrial).pd_trajectory_reach) || isempty(curSessData(iTrial).pd_trajectory_grasp{1})
        continue
    else
    curPdData = [curSessData(iTrial).pd_trajectory_reach{1,1}; curSessData(iTrial).pd_trajectory_grasp{1,1}(2:end,:)];
    for i_dig = 1:4
        curDigData(:,:,i_dig) = [curSessData(iTrial).dig_trajectory_reach{1,1}(:,:,i_dig); curSessData(iTrial).dig_trajectory_grasp{1,1}(2:end,:,i_dig)];
    end 
    
    if pawPref == 'left'    % flip the plot if a left pawed rat so it's consistent for all rats no matter the paw used
        curPdData(:,1) = curPdData(:,1)*-1;
        curDigData(:,1,:) = curDigData(:,1,:)*-1;
    end 
    
    plot3(curPdData(:,1),curPdData(:,3),curPdData(:,2),'Color',pawColor,'LineWidth',lnWdth) % plot paw dorsum trajectory
    hold on
    for iDig = 1:4  % plot digit trajectories
        if size(curDigData,1) < 36      % set to plot digits only from slot 
            plot3(curDigData(:,1,iDig),curDigData(:,3,iDig),curDigData(:,2,iDig),'Color',digColor{iDig},'LineWidth',lnWdth)
        else
            plot3(curDigData(end-35:end,1,iDig),curDigData(end-35:end,3,iDig),curDigData(end-35:end,2,iDig),'Color',digColor{iDig},'LineWidth',lnWdth)   
        end 
    end 
       
    set(gca,'zdir','reverse')   % figure properties
    set(gca,'view',[-40 15])
    set(gca,'xlim',x_lim,'ylim',full_traj_z_lim,'zlim',y_lim)
    set(gca,'ztick',[-30 -10 10],'xtick',[-30 -10 10],'ytick',[0 20 40])
    xlabel('x (mm)');ylabel('z (mm)');zlabel('y (mm)');
    grid on
    end 
end 

scatter3(0,0,0,60,'marker','o','markerfacecolor','k','markeredgecolor','k');    % plot position of pellet
% plot average trajectories 
avgPD = [avgSessData.mean_pd_trajectory_reach(iSess,:,1) avgSessData.mean_pd_trajectory_grasp(iSess,:,1);...
    avgSessData.mean_pd_trajectory_reach(iSess,:,2) avgSessData.mean_pd_trajectory_grasp(iSess,:,2);...
    avgSessData.mean_pd_trajectory_reach(iSess,:,3) avgSessData.mean_pd_trajectory_grasp(iSess,:,3)];
for i_dig = 1:4
    avgDig(:,:,i_dig) = [avgSessData.mean_dig_trajectories_reach(iSess,:,1,i_dig) avgSessData.mean_dig_trajectories_grasp(iSess,:,1,i_dig);...
        avgSessData.mean_dig_trajectories_reach(iSess,:,2,i_dig) avgSessData.mean_dig_trajectories_grasp(iSess,:,2,i_dig);...
        avgSessData.mean_dig_trajectories_reach(iSess,:,3,i_dig) avgSessData.mean_dig_trajectories_grasp(iSess,:,3,i_dig)];
end 
    
if pawPref == 'left'
    avgPD(1,:) = avgPD(1,:)*-1;
    avgDig(1,:,:) = avgDig(1,:,:)*-1;
end 

plot3(avgPD(1,:),avgPD(3,:),avgPD(2,:),'k','LineWidth',3)
hold on
for i_dig = 1:4
    plot3(avgDig(1,:,i_dig),avgDig(3,:,i_dig),avgDig(2,:,i_dig),'k','LineWidth',3)
end 

legend('dig1','dig2','dig3','dig4','paw','Location','northeast')

