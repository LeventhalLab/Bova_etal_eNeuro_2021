function streakBorders = findConsecutiveEntries(x)
%
% find the borders of consecutive true values in a boolean vector x
%
% INPUTS
%	x - vector of booleans
%
% OUTPUTS
%   streakBorders - length(x) x 2 array. The first column contains
%       indices where each streak of true values starts; the second column
%       contains indices where each streak of true values ends

% make sure x is a column vector
if isrow(x)
    x = x';
end

x_diff = diff(x);

start_indices = find(x_diff == 1) + 1;
end_indices  = find(x_diff == -1);

if x(1)
    start_indices = [1;start_indices];
end

if x(end)
    end_indices = [end_indices;length(x)];
end

streakBorders = [start_indices,end_indices];