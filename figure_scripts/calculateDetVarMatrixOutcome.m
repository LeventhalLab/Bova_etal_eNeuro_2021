function detValL = calculateDetVarMatrixOutcome(exptOutcomeSummary)

% calculates the determinant of the covariance matrix for paw and digit tip
% endpoints separately for successful vs. failed reaches

script_findLearners % find learners vs. non-learners

for i_rat = 1:size(exptOutcomeSummary.cov_pd_endPt,5)  % load in each rats covariance data
    
    pawPref = exptOutcomeSummary.pawPref(i_rat);

    for i_sess = 1:10   % pull out covariance matrix values for outcome types
        outC = 1;
        for i_out = [2 4]   % 2 - success; 4 = failed
            meanCovPd(:,:,i_sess,outC,i_rat) = squeeze(exptOutcomeSummary.cov_pd_endPt(i_sess,i_out,:,:,i_rat));
            meanCovDig1(:,:,i_sess,outC,i_rat) = squeeze(exptOutcomeSummary.cov_dig1_endPt(i_sess,i_out,:,:,i_rat));
            meanCovDig2(:,:,i_sess,outC,i_rat) = squeeze(exptOutcomeSummary.cov_dig2_endPt(i_sess,i_out,:,:,i_rat));
            meanCovDig3(:,:,i_sess,outC,i_rat) = squeeze(exptOutcomeSummary.cov_dig3_endPt(i_sess,i_out,:,:,i_rat));
            meanCovDig4(:,:,i_sess,outC,i_rat) = squeeze(exptOutcomeSummary.cov_dig4_endPt(i_sess,i_out,:,:,i_rat));
            outC = 2;
        end
    end

    switch pawPref  % make equivalent between left and right pawed rats
        case 'left'
            meanCovPd(1,2:3,:,:,i_rat) = -meanCovPd(1,2:3,:,:,i_rat);
            meanCovPd(2:3,1,:,:,i_rat) = -meanCovPd(2:3,1,:,:,i_rat);
            meanCovDig1(1,2:3,:,:,i_rat) = -meanCovDig1(1,2:3,:,:,i_rat);
            meanCovDig1(2:3,1,:,:,i_rat) = -meanCovDig1(2:3,1,:,:,i_rat);
            meanCovDig2(1,2:3,:,:,i_rat) = -meanCovDig2(1,2:3,:,:,i_rat);
            meanCovDig2(2:3,1,:,:,i_rat) = -meanCovDig2(2:3,1,:,:,i_rat);
            meanCovDig3(1,2:3,:,:,i_rat) = -meanCovDig3(1,2:3,:,:,i_rat);
            meanCovDig3(2:3,1,:,:,i_rat) = -meanCovDig3(2:3,1,:,:,i_rat);
            meanCovDig4(1,2:3,:,:,i_rat) = -meanCovDig4(1,2:3,:,:,i_rat);
            meanCovDig4(2:3,1,:,:,i_rat) = -meanCovDig4(2:3,1,:,:,i_rat);
        case 'right'
    end
    
end 

for i_rat = 1 : size(exptOutcomeSummary.cov_pd_endPt,5)     % calculate determinant of cov. matrix
    for i_sess = 1 : 10
        for i_out = 1:2
            detVal(i_rat,i_sess,i_out,1) = det(meanCovPd(:,:,i_sess,i_out,i_rat));
            detVal(i_rat,i_sess,i_out,2) = det(meanCovDig1(:,:,i_sess,i_out,i_rat));
            detVal(i_rat,i_sess,i_out,3) = det(meanCovDig2(:,:,i_sess,i_out,i_rat));
            detVal(i_rat,i_sess,i_out,4) = det(meanCovDig3(:,:,i_sess,i_out,i_rat));
            detVal(i_rat,i_sess,i_out,5) = det(meanCovDig4(:,:,i_sess,i_out,i_rat));
        end
    end
end

nl_rats = 1 : 14;   % separate by learners and non-learners
nl_rats(learningRats) = [];

detValL(1).paw = detVal(learningRats,:,:,1);
detValL(1).dig1 = detVal(learningRats,:,:,2);
detValL(1).dig2 = detVal(learningRats,:,:,3);
detValL(1).dig3 = detVal(learningRats,:,:,4);
detValL(1).dig4 = detVal(learningRats,:,:,5);
detValL(2).paw = detVal(nl_rats,:,:,1);
detValL(2).dig1 = detVal(nl_rats,:,:,2);
detValL(2).dig2 = detVal(nl_rats,:,:,3);
detValL(2).dig3 = detVal(nl_rats,:,:,4);
detValL(2).dig4 = detVal(nl_rats,:,:,5);
