function detVal = calculateDetVarMatrix

dataDir = '/Volumes/DLC_data/rat kinematic summaries';  % directory with individul rat kinematic summaries
cd(dataDir)

ratFiles = dir('R*ary.mat');   

script_findLearners     % separate rats into "learners" and "non-learners"

for i_rat = 1:length(ratFiles)  % load in each rat's covariance data
    
    curRatFile = ratFiles(i_rat).name;
    load(curRatFile)
    
    pawPref = thisRatInfo.pawPref;
  
    for i_sess = 1:10
        meanPdEnd(:,i_sess,i_rat) = squeeze(ratSummary.mean_pd_endPt_reach(i_sess,1,:));
        meanCovPd(:,:,i_sess,i_rat) = squeeze(ratSummary.cov_pd_endPts_reach(i_sess,1,:,:));
        meanDig1End(:,i_sess,i_rat) = squeeze(ratSummary.mean_dig_endPts_reach(i_sess,1,1,:));
        meanCovDig1(:,:,i_sess,i_rat) = squeeze(ratSummary.cov_dig_endPts_reach(i_sess,1,1,:,:));
        meanDig2End(:,i_sess,i_rat) = squeeze(ratSummary.mean_dig_endPts_reach(i_sess,1,2,:));
        meanCovDig2(:,:,i_sess,i_rat) = squeeze(ratSummary.cov_dig_endPts_reach(i_sess,1,2,:,:));
        meanDig3End(:,i_sess,i_rat) = squeeze(ratSummary.mean_dig_endPts_reach(i_sess,1,3,:));
        meanCovDig3(:,:,i_sess,i_rat) = squeeze(ratSummary.cov_dig_endPts_reach(i_sess,1,3,:,:));
        meanDig4End(:,i_sess,i_rat) = squeeze(ratSummary.mean_dig_endPts_reach(i_sess,1,4,:));
        meanCovDig4(:,:,i_sess,i_rat) = squeeze(ratSummary.cov_dig_endPts_reach(i_sess,1,4,:,:));
    end
    
    switch pawPref  % make right and left pawed rats endpoint positions consistent
        case 'left'
            meanPdEnd(1,:,i_rat) = -meanPdEnd(1,:,i_rat);
            meanCovPd(1,2:3,:,i_rat) = -meanCovPd(1,2:3,:,i_rat);
            meanCovPd(2:3,1,:,i_rat) = -meanCovPd(2:3,1,:,i_rat);
            meanDig1End(1,:,i_rat) = -meanDig1End(1,:,i_rat);
            meanCovDig1(1,2:3,:,i_rat) = -meanCovDig1(1,2:3,:,i_rat);
            meanCovDig1(2:3,1,:,i_rat) = -meanCovDig1(2:3,1,:,i_rat);
            meanDig2End(1,:,i_rat) = -meanDig2End(1,:,i_rat);
            meanCovDig2(1,2:3,:,i_rat) = -meanCovDig2(1,2:3,:,i_rat);
            meanCovDig2(2:3,1,:,i_rat) = -meanCovDig2(2:3,1,:,i_rat);
            meanDig3End(1,:,i_rat) = -meanDig3End(1,:,i_rat);
            meanCovDig3(1,2:3,:,i_rat) = -meanCovDig3(1,2:3,:,i_rat);
            meanCovDig3(2:3,1,:,i_rat) = -meanCovDig3(2:3,1,:,i_rat);
            meanDig4End(1,:,i_rat) = -meanDig4End(1,:,i_rat);
            meanCovDig4(1,2:3,:,i_rat) = -meanCovDig4(1,2:3,:,i_rat);
            meanCovDig4(2:3,1,:,i_rat) = -meanCovDig4(2:3,1,:,i_rat);
        case 'right'
    end
end 

% calculate average determinant of covariance matrix for paw and digits
for i_rat = 1 : length(ratFiles)   
    for i_sess = 1 : 10
        detValPd(i_rat,i_sess) = det(meanCovPd(:,:,i_sess,i_rat));
    end
end

for i_rat = 1 : length(ratFiles)
    for i_sess = 1 : 10
        detValDig1(i_rat,i_sess) = det(meanCovDig1(:,:,i_sess,i_rat));
    end
end

for i_rat = 1 : length(ratFiles)
    for i_sess = 1 : 10
        detValDig2(i_rat,i_sess) = det(meanCovDig2(:,:,i_sess,i_rat));
    end
end

for i_rat = 1 : length(ratFiles)
    for i_sess = 1 : 10
        detValDig3(i_rat,i_sess) = det(meanCovDig3(:,:,i_sess,i_rat));
    end
end

for i_rat = 1 : length(ratFiles)
    for i_sess = 1 : 10
        detValDig4(i_rat,i_sess) = det(meanCovDig4(:,:,i_sess,i_rat));
    end
end

% separate determinant values by "learners" (1) and "non-learners" (2)
nl_rats = 1 : 14;
nl_rats(learningRats) = [];

detVal(1).paw = detValPd(learningRats,:);   % learners
detVal(1).dig1 = detValDig1(learningRats,:);
detVal(1).dig2 = detValDig2(learningRats,:);
detVal(1).dig3 = detValDig3(learningRats,:);
detVal(1).dig4 = detValDig4(learningRats,:);
detVal(2).paw = detValPd(nl_rats,:);    % non-learenrs
detVal(2).dig1 = detValDig1(nl_rats,:);
detVal(2).dig2 = detValDig2(nl_rats,:);
detVal(2).dig3 = detValDig3(nl_rats,:);
detVal(2).dig4 = detValDig4(nl_rats,:);
