function sessionInfo = readSessionInfoTable(csvfname,ratIDnum)
%
% function to read rat information in from a .csv spreadsheet (birth dates,
% training dates, interventions, etc.)

sessionInfo = readtable(csvfname);

if ratIDnum > 381 && ratIDnum < 388
    sessionInfo = cleanUpSessionsTableOHDA(sessionInfo);    % 6-OHDA rats have different table categories because no laser was used
else
    sessionInfo = cleanUpSessionsTable(sessionInfo);
end


