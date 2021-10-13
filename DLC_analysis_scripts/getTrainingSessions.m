function new_sessionTable = getTrainingSessions(sessionTable,ratIDnum)
%
%
% extract all sessions starting with the last 2 training sessions

    
% divide sessionTable into blocks of similar sessions
if ratIDnum > 381 && ratIDnum < 388
    sessionBlockLabels = identifySessionTransitionsOHDA(sessionTable);
else
    sessionBlockLabels = identifySessionTransitions(sessionTable);
end
% sessions_remaining = calcSessionsRemainingFromBlockLabels(sessionBlockLabels);

trainingRows = sessionTable.trainingStage == 'training';
startRow = find(trainingRows,1,'first');

% find the table row with the last "training" sessions
endRow = startRow+9; % for now to make easier
% endRow = find(trainingRows,1,'last');

new_sessionTable = sessionTable(startRow:endRow,:);
