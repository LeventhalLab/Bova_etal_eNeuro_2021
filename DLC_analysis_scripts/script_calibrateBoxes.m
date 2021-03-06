% calibrate boxes given marked checkerboard points
%
% saves the following structure:
%   boxCal - box calibration structure with the following fields:
%       E - 3 x 3 x 3 array continaing essential matrices
%           E(:,:,1) = essential matrix for direct view, top mirror
%           E(:,:,2) = essential matrix for direct view, left mirror
%           E(:,:,3) = essential matrix for direct view, right mirror
%       F - 3 x 3 x 3 array continaing fundamental matrices
%           F(:,:,1) = fundamental matrix for direct view, top mirror
%           F(:,:,2) = fundamental matrix for direct view, left mirror
%           F(:,:,3) = fundamental matrix for direct view, right mirror
%       Pn - 3 x 3 x 3 array continaing camera matrices for virtual cameras
%           P for direct view assumed to be eye(4,3)
%           Pn(:,:,1) = camera matrix for top mirror
%           Pn(:,:,2) = camera matrix for left mirror
%           Pn(:,:,3) = camera matrix for right mirror
%       cameraParams - matlab camera parameters structure with intrinsic
%           parameters for the real camera
%       curDate - character array containing the date the calibration was 
%           performed (YYYYMMDD)
%       directChecks - ptsPerImage x 2 x number of boards x number of images
%           array. each ptsPerImage x 2 subarray contains (x,y) pairs for
%           matched points in a single image for a single mirror. For
%           example, directChecks(:,:,1,1) is the checkerboard coordinates
%           on the top panel in the first calibration image,
%           directChecks(:,:,2,2) is the checkerboard coordinates on the
%           left panel in the second calibration image,
%           directChecks(:,:,3,1) is the checkerboard coordinates on the
%           right panel in the first calibration image, etc...
%       mirrorChecks - same as directChecks but in the corresponding mirror
%           views
%       imFileList - names of the grid calibration files that went into the
%           calibration
%       scaleFactor - n x 3 array, where n is the number of calibration
%           images. scaleFactor(1,:) - scale factor for top view;
%           scaleFactor(2,:) - scale factor for left view; scaleFactor(3,:)
%           - scale factor for right view. Converts world coordinates to mm

camParamFile = '';

month_to_analyze = '202009';
year_to_analyze = month_to_analyze(1:4);
rootDir = '/Volumes/DLC_data/calibration_images';
calImageDir = fullfile(rootDir,year_to_analyze,...
    [month_to_analyze '_calibration'],[month_to_analyze '_original_images']);
autoImageDir = fullfile(rootDir,year_to_analyze,...
    [month_to_analyze '_calibration'],[month_to_analyze '_auto_marked']);
manuallyMarkedDir = fullfile(rootDir,year_to_analyze,...
    [month_to_analyze '_calibration'],[month_to_analyze '_manually_marked']);
allMarkedDir = fullfile(rootDir,year_to_analyze,...
    [month_to_analyze '_calibration'],[month_to_analyze '_all_marked']);
calFileDir = fullfile(rootDir,year_to_analyze,...
    [month_to_analyze '_calibration'],[month_to_analyze '_calibration_files']);

if ~exist(calFileDir,'dir')
    mkdir(calFileDir);
end

load(camParamFile);

K = cameraParams.IntrinsicMatrix;   % camera intrinsic matrix (matlab format, meaning lower triangular
                                    %       version - Hartley and Zisserman and the rest of the world seem to
                                    %       use the transpose of matlab K)
                                    
cb_spacing = 4;   % real world spacing between calibration checkerboard vertices, in mm
anticipatedBoardSize = [4,5];

cd(allMarkedDir)

all_pt_matList = dir('Grid*_all.mat');
P = eye(4,3);
for iMat = 1 : length(all_pt_matList)
    
    if exist('pointsStillDistorted','var')
        clear pointsStillDistorted
    end
    
    if contains(all_pt_matList(iMat).name,'box')
        C = textscan(all_pt_matList(iMat).name,'GridCalibration_box%02d_*');
        boxNum = C{1};
    else
        boxNum = 99;
    end
    load(all_pt_matList(iMat).name);
    if isdatetime(curDate)
        curDateString = datestr(curDate,'yyyymmdd');
    else
        curDateString = curDate;
    end
    
%     if ~any(strcmp({'20170102','20170103','20170105'}, curDateString))
%         continue;
%     end

    fprintf('working on %s\n',curDateString);
    % allMatchedPoints - totalNumPts x 2 x 2 x numMirrors array. each
    %   totalNumPts x 2 subarray contains (x,y) points for each matched
    %   point in a mirror view across calibration images.
    % directChecks - ptsPerImage x 2 x number of boards x number of images
    %   array. each ptsPerImage x 2 subarray contains (x,y) pairs for
    %   matched points in a single image for a single mirror.
    
    % estimate fundamental matrix, exploiting constraints imposed by using
    % mirrors
    numBoards = size(allMatchedPoints, 4);
    num_img = size(directChecks, 4);
    F = NaN(3,3,numBoards);
    E = NaN(3,3,numBoards);
    Pn = NaN(4,3,numBoards);
    scaleFactor = NaN(numBoards, num_img);
    
    for iBoard = 1 : size(allMatchedPoints, 4)
        mp_direct = squeeze(allMatchedPoints(:,:,1,iBoard));
        mp_mirror = squeeze(allMatchedPoints(:,:,2,iBoard));
        valid_mp_direct = mp_direct(~isnan(mp_direct));
        valid_mp_direct = reshape(valid_mp_direct,size(valid_mp_direct,1)/2,2);
        valid_mp_mirror = mp_mirror(~isnan(mp_mirror));
        valid_mp_mirror = reshape(valid_mp_mirror,size(valid_mp_mirror,1)/2,2);
        
        if isempty(valid_mp_direct) || isempty(valid_mp_mirror)
            continue;
        end
        
        if exist('pointsStillDistorted','var')    % this was added into the all_pt_matList files on 20190301 so that
                                                  % point matching could be
                                                  % performed prior to
                                                  % undistortion; now
                                                  % have to undistort here
            if pointsStillDistorted  % points not undistorted yet
                try
                valid_mp_direct = undistortPoints(valid_mp_direct,cameraParams);
                catch
                    keyboard
                end
                valid_mp_mirror = undistortPoints(valid_mp_mirror,cameraParams);
                
                for iImg = 1 : num_img
                    curDirectChecks = squeeze(directChecks(:,:,iBoard,iImg));
                    curMirrorChecks = squeeze(mirrorChecks(:,:,iBoard,iImg));
                    
                    curDirectChecks_ud = undistortPoints(curDirectChecks,cameraParams);
                    curMirrorChecks_ud = undistortPoints(curMirrorChecks,cameraParams);
                    
                    directChecks(:,:,iBoard,iImg) = curDirectChecks_ud;
                    mirrorChecks(:,:,iBoard,iImg) = curMirrorChecks_ud;
                end
            end
        end
%         if any(isnan(mp_direct(:))) || any(isnan(mp_mirror(:)))
        if isempty(valid_mp_direct) || isempty(valid_mp_mirror)
            % either didn't have marks for these images or the marks
            % weren't assigned to the correct boards/images
            fprintf('no matched points on board %d\n',iBoard);
            continue;
        end
        if size(valid_mp_direct,1) ~= size(valid_mp_mirror,1)
            fprintf('direct and mirror point arrays do not match for board %d\n',iBoard);
        end
        F(:,:,iBoard) = fundMatrix_mirror(valid_mp_direct, valid_mp_mirror);
        
        E(:,:,iBoard) = K * squeeze(F(:,:,iBoard)) * K';
        
        cur_E = squeeze(E(:,:,iBoard));
        [rot,t] = EssentialMatrixToCameraMatrix(cur_E);
        [cRot,cT,~] = SelectCorrectEssentialCameraMatrix_mirror(...
            rot,t,valid_mp_mirror',valid_mp_direct',K');
        Ptemp = [cRot,cT];
        Pn(:,:,iBoard) = Ptemp';
        
        % normalize matched points by K in preparation for calculating
        % world points
        for iImg = 1 : num_img
            mp_direct = squeeze(directChecks(:,:,iBoard,iImg));
            mp_mirror = squeeze(mirrorChecks(:,:,iBoard,iImg));
            
            if all(isnan(mp_direct(:))) || all(isnan(mp_mirror(:)))
                % either didn't have marks for these images or the marks
                % weren't assigned to the correct boards/images
                try
                fprintf('no matched points on board %d, image %s\n',iBoard,imFileList{iImg});
                catch
                    keyboard
                end
                continue;
            end
        
            direct_hom = [mp_direct, ones(size(mp_direct,1),1)];
            direct_norm = (K' \ direct_hom')';
            direct_norm = bsxfun(@rdivide,direct_norm(:,1:2),direct_norm(:,3));
            
            mirror_hom = [mp_mirror, ones(size(mp_mirror,1),1)];
            mirror_norm = (K' \ mirror_hom')';
            mirror_norm = bsxfun(@rdivide,mirror_norm(:,1:2),mirror_norm(:,3));
            
            cur_P = squeeze(Pn(:,:,iBoard));
            [wpts, reproj]  = triangulate_DL(direct_norm, mirror_norm, P, cur_P);
            gs = calcGridSpacing(wpts,anticipatedBoardSize-1);
            scaleFactor(iBoard,iImg) = cb_spacing / mean(gs);
            
            % comment in below to make scatter plots of world points
%             figure(iImg + 3)
%             if iBoard == 1
%                 hold off
%             else
%                 hold on
%             end
%             scatter3(wpts(:,1),wpts(:,2),wpts(:,3))
        end
        
    end
    
    % write box calibration information to disk
    calibrationFileName = sprintf('SR_boxCalibration_box%02d_%s.mat',boxNum,curDateString);
    calibrationFileName = fullfile(calFileDir,calibrationFileName);
    save(calibrationFileName,'P','Pn','F','E','scaleFactor','directChecks','mirrorChecks','cameraParams','curDate','imFileList');
    
    % comment in below to draw lines between matching points
    
%     img = cell(1, length(imFileList));
%     for ii = 1 : length(imFileList)
%         img{ii} = imread(imFileList{ii},'png');
%         img{ii} = undistortImage(img{ii},cameraParams);
%         
%         figure(ii)
%         imshow(img{ii})
%         h = size(img{ii},1);
%         w = size(img{ii},2);
%         hold on
%         num_pts = size(directChecks,1);
%         for jj = 1 : size(directChecks,3)   % view index
%             cur_F = squeeze(F(:,:,jj));
%             if ~any(isnan(cur_F(:)))
%                 [isIn,epipole] = isEpipoleInImage(cur_F, [h,w]);
%             else
%                 epipole = NaN(1,2);
%             end
%             for kk = 1 : num_pts
%                 line([epipole(1),directChecks(kk,1,jj,ii)],...
%                     [epipole(2),directChecks(kk,2,jj,ii)],'color','r');
%                 line([directChecks(kk,1,jj,ii),mirrorChecks(kk,1,jj,ii)],...
%                     [directChecks(kk,2,jj,ii),mirrorChecks(kk,2,jj,ii)],'color','b')
%             end
%         end
%     end
        
end