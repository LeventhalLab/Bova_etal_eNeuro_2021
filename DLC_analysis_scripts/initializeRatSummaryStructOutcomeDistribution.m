function ratSummary = initializeRatSummaryStructOutcomeDistribution(ratID,outcomeCategories,outcomeNames,sessions_analyzed)

% summary structure for:
% number of trials
% outcome percents

ratSummary.ratID = ratID;
num_outcome_categories = length(outcomeCategories);

numSessions_to_analyze = size(sessions_analyzed,1);

ratSummary.sessions_analyzed = sessions_analyzed;

ratSummary.num_trials = NaN(numSessions_to_analyze,num_outcome_categories);
ratSummary.outcomePercent = NaN(numSessions_to_analyze,num_outcome_categories);

ratSummary.sessionDates = NaT(numSessions_to_analyze,1);
ratSummary.sessionTypes = cell(numSessions_to_analyze,1);

ratSummary.outcomeCategories = outcomeCategories;
ratSummary.outcomeNames = outcomeNames;