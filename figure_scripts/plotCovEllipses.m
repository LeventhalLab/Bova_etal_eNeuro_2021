function plotCovEllipses(ratSummary,thisRatInfo,i_sess)

% plot covariance ellipses for paw and digit tip endpoints of single session
% from one rat

% plot properties
pdCol = [81/266 91/255 135/255];    % set colors for each paw part 
digColor = {[147/255 169/255 209/255] [183/255 108/255 164/255] ...
    [228/255 187/255 37/255] [136/255 176/255 75/255]};
lineW = 1;
faVal = .8;

pawPref = thisRatInfo.pawPref;

for i_dim = 1:3 % calculate average endpoints in x,y,z directions (paw dorsum)
    pd_mean(1,i_dim) = ratSummary.mean_pd_endPt_reach(i_sess,1,i_dim);
end

pd_mean(2:3) = fliplr(pd_mean(2:3));    % plot y on the z-axis and z on the y-axes

pd_cov(1,1) = ratSummary.cov_pd_endPts_reach(i_sess,1,1,1); % put covariance data in a format for plotting
pd_cov(2,1) = ratSummary.cov_pd_endPts_reach(i_sess,1,3,1);
pd_cov(3,1) = ratSummary.cov_pd_endPts_reach(i_sess,1,1,2);
pd_cov(1,2) = ratSummary.cov_pd_endPts_reach(i_sess,1,3,1);
pd_cov(2,2) = ratSummary.cov_pd_endPts_reach(i_sess,1,3,3);
pd_cov(3,2) = ratSummary.cov_pd_endPts_reach(i_sess,1,3,2);
pd_cov(1,3) = ratSummary.cov_pd_endPts_reach(i_sess,1,2,1);
pd_cov(2,3) = ratSummary.cov_pd_endPts_reach(i_sess,1,2,3);
pd_cov(3,3) = ratSummary.cov_pd_endPts_reach(i_sess,1,2,2);

switch pawPref  % flip coordinates for left pawed rats
    case 'left'
        pd_mean(1) = -pd_mean(1);
        pd_cov(1,2:end) = -pd_cov(1,2:end);
        pd_cov(2:end,1) = -pd_cov(2:end,1);
    case 'right'
end

eigenvals = eig(pd_cov);

if all(eigenvals > 0)   % plot paw dorsum
    % sometimes, when there are only a few reaches, the covariance
    % matrix is barely positive-definite, and matlab gets confused.
    % For now, just skip these.
    h_pd = error_ellipse(pd_cov,pd_mean);
    hold on
    set(h_pd(1),'Color',pdCol,'linewidth',lineW); 
    set(h_pd(2),'Color',pdCol,'linewidth',lineW);
    set(h_pd(3),'Color',pdCol,'linewidth',lineW);
    set(h_pd(4),'FaceColor',pdCol,'EdgeColor',pdCol,'FaceAlpha',faVal);
end
hold on

for i_dig = 1 : 4   % plot digits
    for i_dim = 1:3
        cur_dig_mean(1,i_dim) = ratSummary.mean_dig_endPts_reach(i_sess,1,i_dig,i_dim);
    end 
    
    cur_dig_mean(2:3) = fliplr(cur_dig_mean(2:3));     % plot y on the z-axis and z on the y-axes
    
    for i_row = 1:3
        for i_col = 1:3
            cur_dig_cov(i_row,i_col) = ratSummary.cov_dig_endPts_reach(i_sess,1,i_dig,i_col,i_row);
        end
    end 
    
    cur_dig_cov(2:end,:) = flipud(cur_dig_cov(2:end,:));
    cur_dig_cov(:,2:end) = fliplr(cur_dig_cov(:,2:end));
    
    switch pawPref
        case 'left' % flip coordinates for left pawed rats)
            cur_dig_mean(1) = -cur_dig_mean(1);
            cur_dig_cov(2:end,1) = -cur_dig_cov(2:end,1);
            cur_dig_cov(2:end,1) = -cur_dig_cov(2:end,1);
        case 'right'
    end
    
    eigenvals = eig(cur_dig_cov);
    
    if all(eigenvals > 0)
        % sometimes, when there are only a few reaches, the covariance
        % matrix is barely positive-definite, and matlab gets confused.
        % For now, just skip these.
        try
        h_dig = error_ellipse(cur_dig_cov,cur_dig_mean);
        hold on
        set(h_dig(1),'Color',digColor{i_dig},'linewidth',lineW); 
        set(h_dig(2),'Color',digColor{i_dig},'linewidth',lineW);
        set(h_dig(3),'Color',digColor{i_dig},'linewidth',lineW);
        set(h_dig(4),'FaceColor',digColor{i_dig},'EdgeColor',digColor{i_dig},'FaceAlpha',faVal);
        catch
            fprintf('error_ellipse error, digit %d\n',i_dig);
        end
    end
end 

% figure properties
reachEnd_zlim = [-10 30];
x_lim = [-30 10];
y_lim = [-20 15];

scatter3(0,0,0,25,'marker','*','markerfacecolor','k','markeredgecolor','k');
set(gca,'zdir','reverse','xlim',x_lim,'ylim',reachEnd_zlim,'zlim',y_lim)%...
set(gca,'view',[-70 30])
set(gca,'ztick',[-20 0 15],'xtick',[-30 -10 10],'ytick',[-10 10 30])
set(gca,'YTickLabels',[30 10 -10])
xlabel('x (mm)');ylabel('z (mm)');zlabel('y (mm)');

