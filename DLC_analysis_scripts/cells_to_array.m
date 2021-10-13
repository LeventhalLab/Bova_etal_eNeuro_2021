function y = cells_to_array(c)
% convert array of cells into an array of doubles
%
% INPUTS
%
% OUTPUTS
%

y = zeros(size(c));

for ii = 1 : numel(c)
    
    y(ii) = str2double(c{ii});
    
end