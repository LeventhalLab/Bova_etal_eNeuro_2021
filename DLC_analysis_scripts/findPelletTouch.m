function  [min_dist, min_distPawPart, min_distPawPartName, min_distFrame] = findPelletTouch(pawTrajectory, bodyparts,...
    pawPref, invalid_direct,invalid_mirror, reproj_error, initPellet3D, varargin)

% finds the paw part that is closest to the initial pellet location during
% the initial reach and identifies the frame that this occurs in
%
% INPUTS
%   pawTrajectory - numFrames x 3 x numBodyparts array. Each numFrame x 3
%       matrix contains x,y,z points for each bodypart. 
%   bodyparts - cell array containing strings describing each bodypart in
%       the same order as in the pawTrajectory array
%   pawPref - 'left' or 'right'
%   invalid_direct - bodyparts x numframes boolean array where true values
%       indicate that a bodypart in a given frame was (probably) not
%       correctly identified
%   invalid_mirror - same as invalid_direct for the mirror view
%   reproj_error - num_bodyparts x numFrames x 2 array where
%       reproj_error(bodypart,frame,1) is the euclidean distance
%       between the reprojected 3D point and originally
%       measured direct view point. reproj_error(bodypart,frame,2) is
%       the same for the mirror view
%   initPellet3D - x,y,z points for initial pellet location
%
% VARARGS
%   'slot_z' - z coordinate of reaching slot
%   'maxReprojError' - - maximum tolerable reprojection error from 3D points
%       back to original images
%   
% OUTPUTS
%   min_dist = minimum distance of any paw part from the initial pellet
%       location during the first identified reach in a trial
%   min_distPawPart = index of paw part that was identified as being
%       closest to the pellet
%   min_distPawPartName = name of paw part identified as being closest to
%       the pellet
%   min_distFrame = frame number where paw part was identified as being
%       closest to the pellet

% if isempty(initPellet3D)
%     return;
% end

slot_z = 200; 
maxReprojError = 10;
min_consec_frames = 5;

if iscategorical(pawPref)
    pawPref = char(pawPref);
end

for iarg = 1 : 2 : nargin - 7
    switch lower(varargin{iarg})
        case 'maxreprojerror'
            maxReprojError = varargin{iarg + 1};
        case 'slot_z'
            slot_z = varargin{iarg + 1};
        case 'minconsecframes'
            min_consec_frames = varargin{iarg + 1};
    end
end

maxDigitReachFrame = NaN;

[mcpIdx,pipIdx,digIdx,pawDorsumIdx] = findReachingPawParts(bodyparts,pawPref);

% only look for paw parts after the paw has been
% identified behind the front panel
pawDorsum_z = pawTrajectory(:,3,pawDorsumIdx);
pawDorsum_mirror_valid = ~invalid_mirror(pawDorsumIdx,:);
pawDorsum_reproj_error = squeeze(reproj_error(pawDorsumIdx,:,:));

if isrow(pawDorsum_z)
    pawDorsum_z = pawDorsum_z';
end
if isrow(pawDorsum_mirror_valid)
    pawDorsum_mirror_valid = pawDorsum_mirror_valid';
end

% truncate pawDorsum_mirror_valid, which has the same number of points as
% most of the videos. However, sometimes a video recording gets cut off,
% and pawDorsum_z will not have as many points
numFramesInThisVideo = size(pawDorsum_z,1);
validPawDorsumIdx = (pawDorsum_mirror_valid(1:numFramesInThisVideo)) & ... % only accept points identified with high probability
                    (pawDorsum_z > slot_z) & ...     % only accept points on the far side of the reaching slot
                    (pawDorsum_reproj_error(:,1) < maxReprojError) & ...   % only accept points that are near the epipolar line defined by the direct view observation (if present)
                    (pawDorsum_reproj_error(:,2) < maxReprojError);   
firstValidPawDorsum = find(validPawDorsumIdx,1);
if isempty(firstValidPawDorsum)
    firstValidPawDorsum = 1;
end
if firstValidPawDorsum > 350    % didn't find the paw on the first reach
    min_dist = NaN;
    min_distPawPart = NaN;
    min_distPawPartName = NaN;
    min_distFrame = NaN;
    return;
end

pastValidDorsum = false(size(validPawDorsumIdx));
pastValidDorsum(firstValidPawDorsum:end) = true;
                
numPawParts = length(mcpIdx) + length(pipIdx) + length(digIdx) + length(pawDorsumIdx);
pawPartsList = cell(1,numPawParts);
curPartIdx = 0;
allPawPartsIdx = zeros(numPawParts,1);
for ii = 1 : length(mcpIdx)
    curPartIdx = curPartIdx + 1;
    pawPartsList{curPartIdx} = bodyparts{mcpIdx(ii)};
    allPawPartsIdx(curPartIdx) = mcpIdx(ii);
end
for ii = 1 : length(pipIdx)
    curPartIdx = curPartIdx + 1;
    pawPartsList{curPartIdx} = bodyparts{pipIdx(ii)};
    allPawPartsIdx(curPartIdx) = pipIdx(ii);
end
for ii = 1 : length(digIdx)
    curPartIdx = curPartIdx + 1;
    pawPartsList{curPartIdx} = bodyparts{digIdx(ii)};
    allPawPartsIdx(curPartIdx) = digIdx(ii);
end
for ii = 1 : length(pawDorsumIdx)
    curPartIdx = curPartIdx + 1;
    pawPartsList{curPartIdx} = bodyparts{pawDorsumIdx(ii)};
    allPawPartsIdx(curPartIdx) = pawDorsumIdx(ii);
end

xyz_coords = pawTrajectory(:,:,allPawPartsIdx);
x_coords = squeeze(xyz_coords(:,1,:));
y_coords = squeeze(xyz_coords(:,2,:));
z_coords = squeeze(xyz_coords(:,3,:));

for iPart = 1 : numPawParts
    part_reproj_error = squeeze(reproj_error(iPart,:,:));
    invalid_reproj = part_reproj_error(:,1) > maxReprojError | ...
                     part_reproj_error(:,2) > maxReprojError;
                 
    x_coords(invalid_direct(iPart,1:numFramesInThisVideo),iPart) = NaN;
    x_coords(invalid_mirror(iPart,1:numFramesInThisVideo),iPart) = NaN;
    x_coords(invalid_reproj,iPart) = NaN;
    
    y_coords(invalid_direct(iPart,1:numFramesInThisVideo),iPart) = NaN;
    y_coords(invalid_mirror(iPart,1:numFramesInThisVideo),iPart) = NaN;
    y_coords(invalid_reproj,iPart) = NaN;
    
    z_coords(invalid_direct(iPart,1:numFramesInThisVideo),iPart) = NaN;
    z_coords(invalid_mirror(iPart,1:numFramesInThisVideo),iPart) = NaN;
    z_coords(invalid_reproj,iPart) = NaN;
end

% identify reaches
min_z_diff_pre_reach = 1;     % minimum number of millimeters the paw must have moved since the previous reach to count as a new reach
min_z_diff_post_reach = 1;   
maxFramesPriorToAdvance = 10;   % if the paw extends further within this many frames after a local minimum, don't count it as a reach
pts_to_extract = 20;  % look pts_to_extract frames on either side of each z
extraFramesToExtract = pts_to_extract+1;

localMins = islocalmin(z_coords(:,10));

reachFrameMarkers = find_reaches2(localMins(firstValidPawDorsum:end),z_coords(firstValidPawDorsum:end,10),...
    y_coords(firstValidPawDorsum:end,10),min_z_diff_pre_reach,min_z_diff_post_reach,maxFramesPriorToAdvance,...
    extraFramesToExtract,pts_to_extract);

if any(reachFrameMarkers)
    endPtFrame = firstValidPawDorsum-1 + find(reachFrameMarkers,1);
else
    endPtFrame = NaN;
end

% calculate euclidian distances between every paw part in every frame and the pellet
diff_fromPellet(:,:,1) = x_coords - initPellet3D(1);
diff_fromPellet(:,:,2) = y_coords - initPellet3D(2);
diff_fromPellet(:,:,3) = z_coords - initPellet3D(3);

dist_fromPellet = sqrt(sum(diff_fromPellet.^2,3));

% find frame with paw part nearest pellet for each part
if ~isnan(endPtFrame)
    for iPart = 1 : numPawParts

        if endPtFrame+40 > numFramesInThisVideo
            all_min_dist(iPart,1) = min(dist_fromPellet(firstValidPawDorsum:numFramesInThisVideo,iPart));
        else
            all_min_dist(iPart,1) = min(dist_fromPellet(firstValidPawDorsum:endPtFrame+40,iPart));
        end

        if ~isnan(all_min_dist(iPart,1))
            allmin_distFrame(iPart,1) = find(dist_fromPellet(:,iPart) == all_min_dist(iPart,1));
        else    % no valid points in this range for this paw part
            allmin_distFrame(iPart,1) = NaN;
        end   
    end
    
    min_dist = min(all_min_dist);
    min_distPawPart = find(all_min_dist(:,:) == min_dist);
    min_distPawPartName = pawPartsList{min_distPawPart};
    min_distFrame = allmin_distFrame(min_distPawPart);
else
    min_dist = NaN;
    min_distPawPart = NaN;
    min_distPawPartName = NaN;
    min_distFrame = NaN;
end 
    

    

end 


