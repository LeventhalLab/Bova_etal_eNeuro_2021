function percentPart = calculatePercentFirstPawContact(reachData,numTrials,pawPref)

all_first_contacts = cell(numTrials,1);
all_first_dist = NaN(numTrials,1);

for iTrial = 1 : size(reachData,2)
    
    if ~isempty(reachData(iTrial).closestPawPart)
        all_first_contacts(iTrial) = cellstr(reachData(iTrial).closestPawPart{1});
        all_first_dist(iTrial) = reachData(iTrial).closestDistToPellet(1);
    end 
    
    if all_first_dist(iTrial) > 5
        all_first_contacts(iTrial) = {'x'};
    end 
    
    if isempty(all_first_contacts{iTrial})
        all_first_contacts(iTrial) = {'x'};
    end
    
end 

if pawPref(1) == 'r'
    pawParts = {'rightdigit1','rightdigit2','rightdigit3','rightdigit4','rightpip1','rightpip2','rightpip3',...
        'rightpip4','rightmcp1','rightmcp2','rightmcp3','rightmcp4','rightpawdorsum'};
else
    pawParts = {'leftdigit1','leftdigit2','leftdigit3','leftdigit4','leftpip1','leftpip2','leftpip3',...
        'leftpip4','leftmcp1','leftmcp2','leftmcp3','leftmcp4','leftpawdorsum'};
end 

total_trials = NaN(1,13);

for iPart = 1 : size(pawParts,2)
    
    total_trials(1,iPart) = size(find(contains(all_first_contacts,pawParts{iPart})),1);
    
end

num_counted_trials = sum(total_trials);

percentPart = (total_trials./num_counted_trials)*100;
        
    
    
    
