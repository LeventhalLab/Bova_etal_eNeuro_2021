% add manually marked calibration images to automatically marked calibration images
%
% revised 20191125 to incorporate time and box number in calibration
% names

% set which month to detect calibration points for
% eventually, change directory structure to have a separate set of
% calibration images for each box
month_to_analyze = '202009';

darkDates = [1 2 3];    % dates with dark images - mark to brighten when read in images
bNum = 30;

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
    [month_to_analyze '_calibration'],[month_to_analyze 'calibration_files']);


if ~exist(allMarkedDir,'dir')
    mkdir(allMarkedDir);
end

camParamFile = '';
load(camParamFile);

pointsStillDistorted = true;
% in this version, undistorting points is the last thing that happens. in
% older versions, points were undistorted by this point; need to note that
% for the script_calibrateBoxes script

saveMarkedImages = true;
markRadius = 5;
colorList = {'red','green','blue'};
markOpacity = 1;

% parameters for detecting borders around checkerboards
threshStepSize = 0.01;
diffThresh = 0.1;
maxThresh = 0.2;

minDirectCheckerboardArea = 5000;
maxDirectCheckerboardArea = 25000;

minMirrorCheckerboardArea = 5000;
maxMirrorCheckerboardArea = 20000;
    
maxDistFromMainBlob = 200;  
minSolidity = 0.8;
SEsize = 3;

% first row red, second row green, third row blue
direct_hsvThresh = [0,0.1,0.85,1,0.85,1;
                    0.30,0.05,0.85,1,0.85,1;
                    0.60,0.1,0.85,1,0.85,1];

mirror_hsvThresh = [0,0.1,0.85,1,0.85,1;
                    0.30,0.05,0.85,1,0.85,1;
                    0.60,0.1,0.85,1,0.85,1];

boardSize = [4 5];
points_per_board = prod(boardSize-1);

anticipatedBoardSize = [4 5];

cd(manuallyMarkedDir)
csvList = dir('GridCalibration_*.csv');

cd(calImageDir)
imgList = dir('GridCalibration_*.png');

% load test image
A = imread(imgList(1).name,'png');
h = size(A,1); w = size(A,2);
% [x,y,w,h]. first row is for direct cube view, second row top mirror,
% third row left mirror, fourth row right mirror
rightMirrorLeftEdge = 1700;
ROIs = [750,300,500,500;
        750,1,600,325;
        1,400,350,500;
        rightMirrorLeftEdge,400,w-rightMirrorLeftEdge,500];
    
numBoards = size(ROIs,1) - 1;

mirrorOrientation = {'top','left','right'};

cd(calImageDir);
[imFiles_from_same_boxdate, boxList, datesForBox] = groupCalibrationImagesbyDateBoxTime(imgList);

[csvFiles_from_same_boxdate, csv_boxList, csv_datesForBox] = group_csv_files_by_boxdate(csvList);
numBoxes = length(csv_boxList);

for iBox = 1 : numBoxes
    
    curBox = csv_boxList(iBox);
    imgBoxIdx = find(boxList == curBox);
    if isempty(imgBoxIdx)
        continue;
    end
    numDatesForBox = length(csv_datesForBox{iBox});
    numOrigDatesForBox = length(datesForBox{iBox});
    
    if numOrigDatesForBox > numDatesForBox  % if date didn't have any images that needed manually marked, need to move the auto files into all_marked folder
        for iDate = 1:numOrigDatesForBox
            curDates = datesForBox{iBox};
            csvDates = csv_datesForBox{iBox};
            matchDate = find(csvDates(:,:) == curDates(iDate));
            if isempty(matchDate)   % found date that was not manually marked
                
                curDateString = datestr(curDates(iDate),'yyyymmdd');
                
                autoFileName = sprintf('GridCalibration_box0%d_%s_auto.mat',curBox,curDateString);
                autoFileDir = fullfile(autoImageDir,autoFileName);
                load(autoFileDir);   % load auto .mat file
                
                matSaveFileName = sprintf('GridCalibration_box%02d_%s_all.mat',boxList(iBox),curDateString);
                matSaveFileName = fullfile(allMarkedDir,matSaveFileName);
                save(matSaveFileName, 'directChecks','mirrorChecks','allMatchedPoints','cameraParams','imFileList','curDate','pointsStillDistorted');
                
                for i_imgBoxDate = 1 : length(imFiles_from_same_boxdate)
                    if (imFiles_from_same_boxdate(i_imgBoxDate).box == curBox && ...
                        imFiles_from_same_boxdate(i_imgBoxDate).date == curDate)

                        validImgBoxDateCombo = true;
                        break

                    end
                end
                
                if saveMarkedImages
                    numImgPerDate = length(imFiles_from_same_boxdate(i_imgBoxDate).fnames);
                    for iImg = 1 : numImgPerDate

                        % was there a previously marked image?
                        curImgName = imFileList{iImg};
                        cd(calImageDir);
                        oldImg = imread(curImgName,'png');
                        newImg = oldImg;

                        for iBoard = 1 : numBoards

                            curChecks = squeeze(directChecks(:,:,iBoard,iImg));
                            for i_pt = 1 : size(curChecks,1)
                                if isnan(curChecks(i_pt,1)); continue; end
                                newImg = insertShape(newImg,'rectangle',...
                                    [curChecks(i_pt,1),curChecks(i_pt,2),2*markRadius,2*markRadius],...
                                    'color',colorList{iBoard},'opacity',markOpacity);
                            end

                            curChecks = squeeze(mirrorChecks(:,:,iBoard,iImg));
                            for i_pt = 1 : size(curChecks,1)
                                if isnan(curChecks(i_pt,1)); continue; end
                                newImg = insertShape(newImg,'rectangle',...
                                    [curChecks(i_pt,1),curChecks(i_pt,2),2*markRadius,2*markRadius],...
                                    'color',colorList{iBoard},'opacity',markOpacity);
                            end

                        end

                        h_fig = figure;
                        imshow(newImg);
                        [~,curImg_nosuffix,~] = fileparts(curImgName);
                        imgNum = str2double(curImg_nosuffix(end));
                        newImgName = sprintf('GridCalibration_box%02d_%s_%d_all_marked.png', boxList(iBox),curDateString,imgNum);
                        newImgName = fullfile(allMarkedDir,newImgName);
                        set(gcf,'name',newImgName);
                        imwrite(newImg,newImgName,'png');
                        close(h_fig)
                    end       
                end
                
            else
                continue;
            end 
        end 
    end 
                
    
    for iDate = 1 : numDatesForBox
        curDate = csv_datesForBox{iBox}(iDate);
        curDateString = datestr(curDate,'yyyymmdd');
        
        % comment in if only want to analyze specific boxes from specific dates
%         if ~any(strcmp({'20170113'}, curDateString))
%             continue;
%         end
        
        
        fprintf('working on box %d, %s\n',csv_boxList(iBox),curDateString);
        
        % find the csvFiles_from_same_boxdate structure for this box/date
        % combination
        validBoxDateCombo = false;
        for i_boxDate = 1 : length(csvFiles_from_same_boxdate)
            if (csvFiles_from_same_boxdate(i_boxDate).box == curBox && ...
                csvFiles_from_same_boxdate(i_boxDate).date == curDate)
                
                validBoxDateCombo = true;
                break
                
            end
        end
        if ~validBoxDateCombo
            continue
        end
        
        num_csvPerDate = length(csvFiles_from_same_boxdate(i_boxDate).fnames);
        
        validImgBoxDateCombo = false;
        % find this box/date combo in imFiles_from_same_boxdate
        for i_imgBoxDate = 1 : length(imFiles_from_same_boxdate)
            if (imFiles_from_same_boxdate(i_imgBoxDate).box == curBox && ...
                imFiles_from_same_boxdate(i_imgBoxDate).date == curDate)
                
                validImgBoxDateCombo = true;
                break
                
            end
        end
        if ~validImgBoxDateCombo
            continue
        end
        
        img_date_idx = find(datesForBox{imgBoxIdx} == curDate);
    
        numImgPerDate = length(imFiles_from_same_boxdate(i_imgBoxDate).fnames);
        img = cell(1, numImgPerDate);
    
        csvData = cell(1,num_csvPerDate);
        csvNumList = zeros(1,num_csvPerDate);
        cd(manuallyMarkedDir)
    
        for i_csv = 1 : num_csvPerDate
            cur_csvName = csvFiles_from_same_boxdate(i_boxDate).fnames{i_csv};
%             csvNamePrefix = sprintf('GridCalibration_box%02d',curBox);
%             C = textscan(cur_csvName,[csvNamePrefix '_' curDateString '_%d.csv']);
%             csvNumList(i_csv) = C{1};
            [~,csv_nosuffix,~] = fileparts(cur_csvName);
            csvNumList(i_csv) = str2double(csv_nosuffix(end));
            csvData{i_csv} = readFIJI_csv(cur_csvName);
        end
    
        % load images, but only ones for which there is a .csv file
        cd(calImageDir)
        imgNumList = zeros(1,numImgPerDate);
        numImgLoaded = 0;
        if exist('img','var')
            clear img
        end
        for iImg = 1 : numImgPerDate
            curImgName = imFiles_from_same_boxdate(i_imgBoxDate).fnames{iImg};
            [~,img_nosuffix,~] = fileparts(curImgName);
%             imgNamePrefix = sprintf('GridCalibration_box%02d',curBox);
%             C = textscan(curImgName,[imgNamePrefix '_' curDateString '_%d.png']);
%             imageNumber = C{1};
            imageNumber = str2double(img_nosuffix(end));
            if any(csvNumList == imageNumber)
                % load this image
                numImgLoaded = numImgLoaded + 1;
                img{numImgLoaded} = imread(curImgName);
                imgNumList(numImgLoaded) = imageNumber;
                
                if any(darkDates == iDate)  % brighten image if marked as too dark
                    img{numImgLoaded} = img{numImgLoaded}+bNum;
                end 

            end
        end

        if any(strcmp({'20181101','20181106'}, curDateString))
            % this is a goofy session where the calibration cube was left
            % inside the reaching box. Assume first 12 marks are the green face
            % in the left mirror, next 12 are the green face, direct view, next
            % 12 are blue face, direct view, last 12 are blue face, mirror view

            directChecks = NaN(prod(boardSize-1),2,3,numImgPerDate);
            mirrorChecks = NaN(prod(boardSize-1),2,3,numImgPerDate);

            old_directChecks = NaN(prod(boardSize-1),2,3,numImgPerDate);
            old_mirrorChecks = NaN(prod(boardSize-1),2,3,numImgPerDate);

            for i_csv = 1 : num_csvPerDate

                % figure out what image index to use
                img_idx = i_csv;

                % update directChecks and mirrorChecks arrays
                mirrorChecks(:,:,2,img_idx) = csvData{i_csv}(1:12,:);
                directChecks(:,:,2,img_idx) = csvData{i_csv}(13:24,:);

                mirrorChecks(:,:,3,img_idx) = csvData{i_csv}(37:48,:);
                directChecks(:,:,3,img_idx) = csvData{i_csv}(25:36,:);

            end
        else
        
            [directBorderMask, initDirBorderMask] = findDirectBorders(img, direct_hsvThresh, ROIs, ...
                    'diffthresh', diffThresh, 'threshstepsize', threshStepSize, 'maxthresh', maxThresh, ...
                    'maxdistfrommainblob', maxDistFromMainBlob, 'mincheckerboardarea', minDirectCheckerboardArea, ...
                    'maxcheckerboardarea', maxDirectCheckerboardArea, 'sesize', SEsize, 'minsolidity', minSolidity);
            [mirrorBorderMask, initMirBorderMask] = findMirrorBorders(img, mirror_hsvThresh, ROIs, ...
                    'diffthresh', diffThresh, 'threshstepsize', threshStepSize, 'maxthresh', maxThresh, ...
                    'maxdistfrommainblob', maxDistFromMainBlob, 'mincheckerboardarea', minMirrorCheckerboardArea, ...
                    'maxcheckerboardarea', maxMirrorCheckerboardArea, 'sesize', SEsize, 'minsolidity', minSolidity);

            % read in corresponding .mat file if it exists
            cd(autoImageDir)
            matBaseName = sprintf('GridCalibration_box%02d',curBox);
            matFileName = [matBaseName '_' curDateString '_auto.mat'];
            foundMatFile = false;
            if exist(matFileName,'file')
                load(matFileName);
                foundMatFile = true;
            else
                % create arrays to hold the marked checkerboard points if not
                % already loaded from the auto-detection .mat file
                directChecks = NaN(prod(boardSize-1),2,size(directBorderMask{1},3),numImgPerDate);
                mirrorChecks = NaN(prod(boardSize-1),2,size(mirrorBorderMask{1},3),numImgPerDate);
            end
            
        end

        old_directChecks = directChecks;
        old_mirrorChecks = mirrorChecks;
        % now loop through .csv files
        for i_csv = 1 : num_csvPerDate
            clear new_directChecks
            clear new_mirrorChecks

            % figure out what image index to use
            img_idx = find(imgNumList == csvNumList(i_csv));

            % fill out the directChecks and mirrorChecks arrays. Assume that
            % the image number is the correct index to use. Note that
            % previously labeled images should be used in Fiji
            
            switch curDateString
                case '20171110'
                    % workaround for goofy cube orientation
                    if i_csv == 1
                        new_directChecks = NaN(12,2,3);
                        new_mirrorChecks = NaN(12,2,3);

                        new_mirrorChecks(:,:,1) = csvData{i_csv}(1:12,:);
                        new_directChecks(:,:,1) = csvData{i_csv}(13:24,:);
                        new_directChecks(:,:,3) = csvData{i_csv}(25:36,:);
                        new_mirrorChecks(:,:,2) = csvData{i_csv}(37:48,:);
                    else
                        [new_directChecks, new_mirrorChecks] = assign_csv_points_to_checkerboards(directBorderMask{img_idx}, ...
                                                            mirrorBorderMask{img_idx}, ...
                                                            ROIs, csvData{i_csv}, ...
                                                            anticipatedBoardSize, ...
                                                            mirrorOrientation);
                    end
                otherwise
                    [new_directChecks, new_mirrorChecks] = assign_csv_points_to_checkerboards(directBorderMask{img_idx}, ...
                                                            mirrorBorderMask{img_idx}, ...
                                                            ROIs, csvData{i_csv}, ...
                                                            anticipatedBoardSize, ...
                                                            mirrorOrientation);
            end

            % update directChecks and mirrorChecks arrays
            for iBoard = 1 : size(new_directChecks,3)
                testPoints = squeeze(new_directChecks(:,:,iBoard));
                if ~all(isnan(testPoints(:)))
                    % marked points were found for this board
                    try
                    directChecks(:,:,iBoard,imgNumList(img_idx)) = testPoints;
                    catch
                        keyboard
                    end
                end

                testPoints = squeeze(new_mirrorChecks(:,:,iBoard));
                if ~all(isnan(testPoints(:)))
                    % marked points were found for this board
                    try
                    mirrorChecks(:,:,iBoard,imgNumList(img_idx)) = testPoints;
                    catch
                        keyboard
                    end
                end

            end

        end

        allMatchedPoints = NaN(points_per_board * numImgPerDate, 2, 2, numBoards);
        for iImg = 1 : numImgPerDate
            for iBoard = 1 : numBoards
                curDirectChecks = squeeze(directChecks(:,:,iBoard,iImg));
                curMirrorChecks = squeeze(mirrorChecks(:,:,iBoard,iImg));

                if all(isnan(curDirectChecks(:))) || all(isnan(curMirrorChecks(:)))
                    % don't have matching points for the direct and mirror view
                    continue;
                end 
                matchIdx = matchCheckerboardPoints(curDirectChecks, curMirrorChecks);

                matchStartIdx = (iImg-1) * points_per_board + 1;
                matchEndIdx = (iImg) * points_per_board;

                allMatchedPoints(matchStartIdx:matchEndIdx,:,1,iBoard) = curDirectChecks(matchIdx(:,1),:);
                allMatchedPoints(matchStartIdx:matchEndIdx,:,2,iBoard) = curMirrorChecks(matchIdx(:,2),:);

                directChecks(:,:,iBoard,iImg) = curDirectChecks(matchIdx(:,1),:);
                mirrorChecks(:,:,iBoard,iImg) = curMirrorChecks(matchIdx(:,2),:);
            end
        end
    
        matSaveFileName = sprintf('GridCalibration_box%02d_%s_all.mat',boxList(iBox),curDateString);
        matSaveFileName = fullfile(allMarkedDir,matSaveFileName);
        imFileList = imFiles_from_same_boxdate(i_imgBoxDate).fnames;
        save(matSaveFileName, 'directChecks','mirrorChecks','allMatchedPoints','cameraParams','imFileList','curDate','pointsStillDistorted');
    
        if saveMarkedImages
            for iImg = 1 : numImgPerDate

                % was there a previously marked image?
                curImgName = imFileList{iImg};
                cd(calImageDir);
                oldImg = imread(curImgName,'png');
    %             newImg = undistortImage(oldImg,cameraParams);
                newImg = oldImg;

                for iBoard = 1 : numBoards

                    curChecks = squeeze(directChecks(:,:,iBoard,iImg));
                    for i_pt = 1 : size(curChecks,1)
                        if isnan(curChecks(i_pt,1)); continue; end
                        newImg = insertShape(newImg,'rectangle',...
                            [curChecks(i_pt,1),curChecks(i_pt,2),2*markRadius,2*markRadius],...
                            'color',colorList{iBoard},'opacity',markOpacity);
                    end

                    curChecks = squeeze(mirrorChecks(:,:,iBoard,iImg));
                    for i_pt = 1 : size(curChecks,1)
                        if isnan(curChecks(i_pt,1)); continue; end
                        newImg = insertShape(newImg,'rectangle',...
                            [curChecks(i_pt,1),curChecks(i_pt,2),2*markRadius,2*markRadius],...
                            'color',colorList{iBoard},'opacity',markOpacity);
                    end

                    % plot points that had been detected automatically
                    curChecks = squeeze(old_directChecks(:,:,iBoard,iImg));
                    for i_pt = 1 : size(curChecks,1)
                        if isnan(curChecks(i_pt,1)); continue; end
                        newImg = insertShape(newImg,'circle',...
                            [curChecks(i_pt,1),curChecks(i_pt,2),markRadius],...
                            'color',colorList{iBoard},'opacity',markOpacity);
                    end

                    curChecks = squeeze(old_mirrorChecks(:,:,iBoard,iImg));
                    for i_pt = 1 : size(curChecks,1)
                        if isnan(curChecks(i_pt,1)); continue; end
                        newImg = insertShape(newImg,'circle',...
                            [curChecks(i_pt,1),curChecks(i_pt,2),markRadius],...
                            'color',colorList{iBoard},'opacity',markOpacity);
                    end

                end

                h_fig = figure;
                imshow(newImg);
                %imgTime = imFiles_from_same_boxdate(i_imgBoxDate).picTimes(iImg);
                %timeString = datestr(imgTime,'HH-MM-SS');
                [~,curImg_nosuffix,~] = fileparts(curImgName);
                imgNum = str2double(curImg_nosuffix(end));
                newImgName = sprintf('GridCalibration_box%02d_%s_%d_all_marked.png', boxList(iBox),curDateString,imgNum);
%                 newImgName = strrep(curImgName,'.png','_all_marked.png');
                newImgName = fullfile(allMarkedDir,newImgName);
                set(gcf,'name',newImgName);
                imwrite(newImg,newImgName,'png');
                close(h_fig)
            end       
        end
    end
end