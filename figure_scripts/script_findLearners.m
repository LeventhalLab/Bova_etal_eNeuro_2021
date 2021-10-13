% script_findLearners

% find rats that "learned" (improved their performance/success rate from days 1-2 to
% days 9-10) and did not (no improvement from days 1-2 to days 9-10);
% comparison made with chi-squared test, only considered "learner" if the
% change was positive

ratSummaryDir = fullfile('/Volumes/DLC_data/rat kinematic summaries');
cd(ratSummaryDir)

load('sessScoresAll.mat')   % pull out outcome scores for all rats

num_rats = size(sessScoresAll,2);

for i_rat = 1 : num_rats    % get number of first success reaches for first 2 and last 2 sessions, compare using chi square test
    
    num_firstSuccEarly(1,i_rat) = sum(sum(sessScoresAll(i_rat).data(:,1:2) == 1)); % count number of "1" scores (first reach success)
    num_trialsEarly(1,i_rat) = sum(sum(~isnan(sessScoresAll(i_rat).data(:,1:2)))) - sum(sum(sessScoresAll(i_rat).data(:,1:2) == 0)); % total number trials excluding "0" scores (no pellet available)
    
    num_firstSuccLate(1,i_rat) = sum(sum(sessScoresAll(i_rat).data(:,9:10) == 1)); % count number of "1" scores (first reach success)
    num_trialsLate(1,i_rat) = sum(sum(~isnan(sessScoresAll(i_rat).data(:,9:10)))) - sum(sum(sessScoresAll(i_rat).data(:,9:10) == 0)); % total number trials excluding "0" scores (no pellet available)
    
    chiOut(1,i_rat) = prop_test([num_firstSuccEarly(1,i_rat) num_firstSuccLate(1,i_rat)],[num_trialsEarly(1,i_rat) num_trialsLate(1,i_rat)],true);
end  

signifChange = find(chiOut == 1);   % find rats that were significantly different between first 2 and last 2 sessions

for i = signifChange    % calculate success rate for these rats    
    succRate(1,i) = num_firstSuccEarly(1,i)/num_trialsEarly(1,i);
    succRate(2,i) = num_firstSuccLate(1,i)/num_trialsLate(1,i);   
end 

diffSucc = succRate(2,:) - succRate(1,:);   % find any rats where success rate decreased from first 2 to last 2 sessions
badOnes = find(diffSucc < 0);

if any(signifChange == badOnes)     % remove these rats from "learning" groups
    delWhich = find(signifChange == badOnes);
    signifChange(delWhich) = [];
end
    
learningRats = signifChange;