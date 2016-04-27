function main(st, ed, layer)
addpath('../')
paramInit
stLine = str2num(st);
edLine = str2num(ed);
dataSet = 'Event_BG'
%layer = '3C'
Feature = ['DRN50_L' , layer]
feat  = ['F', layer]

FastFolder   = [ dataRoot, 'FastFeatRaw/', dataSet, '/', Feature, '/' ]; 
RegionFolder = [ dataRoot, 'RegionFeatures/', dataSet, '/', Feature, '/'];

listFile = [ tvMed, 'STRUCTURE/', dataSet, '.txt' ];
vidList  = textread(listFile, '%s', 'delimiter', '\n');
vidNum   = length(vidList);
edLine = min(edLine, vidNum)
allAve = 0;
allCnt = 0;
for vidCnt = stLine: edLine
	vid = strtrim(char(vidList{vidCnt}));
	%
	vidFastFolder   = [ FastFolder, vid, '/'];
	vidRegionFolder = [ RegionFolder, vid, '/'];
	
	kfList = dir([vidFastFolder, '*.mat']);
	kfNum  = length(kfList);
	ave = 0;
	samCnt = 0;
	for cnt = 1: kfNum
		kfName = strtrim(char(kfList(cnt).name));
		kfFastFile   = [ vidFastFolder, kfName ];
		kfRegionFile = [ vidRegionFolder, kfName ]; 
		if exist(kfFastFile) && exist(kfRegionFile)
			temp1 = load(kfFastFile);
			temp2 = load(kfRegionFile);
			FastFeat   = getfield(temp1,feat);
			RegionFeat = getfield(temp2,feat);
			sim = hzsim(FastFeat, RegionFeat); 
			ave = ave + sim;
			samCnt = samCnt + 1;
		end
		fprintf('%d-%d|%d:%s:%s:%f\n', edLine, stLine, vidCnt, vid, kfName, sim);
	end
	fprintf('----------------------------\n')
	fprintf('%s: %f\n', vid, ave / samCnt);
	allAve = allAve + ave /samCnt;
	allCnt = allCnt + 1
	fprintf('----------------------------\n')
end
	fprintf('****************************\n')
	fprintf('****************************\n')
	fprintf('%s: %f\n', vid, allAve / allCnt);
	fprintf('****************************\n')
	fprintf('****************************\n')
end

function sim = hzsim(Mat1, Mat2)
	shape1 = size(Mat1);
	shape2 = size(Mat2);
	N = shape2(1);
	x = shape2(2);
	y = shape2(3);
	if numel(Mat1) == numel(Mat2)
		resMat1 = reshape(Mat1, 1, numel(Mat1));
	else
		% bilinear Mapping
		nMat1 = zeros(shape2);
		for dimCnt = 1: N
			sigMat1 = Mat1(dimCnt,:,:);
			[temp, xx, yy] = size(sigMat1);
			tempMat = zeros(xx, yy);
			for xxCnt = 1:xx
				for yyCnt = 1:yy
					tempMat(xxCnt, yyCnt) = sigMat1(1, xxCnt, yyCnt);
				end
			end
			tempMat2 = resizem(tempMat, [x, y], 'bilinear');
			tempMat  = zeros(1, xx, yy);
			for xxCnt = 1:x
				for yyCnt = 1:y
					tempMat(1, xxCnt, yyCnt) = tempMat2(xxCnt, yyCnt);
				end
			end
			nMat1(dimCnt,:,:) = tempMat;
			
		end
		resMat1 = reshape(nMat1, 1, numel(nMat1));
	end
	resMat2 = reshape(Mat2, 1, numel(Mat2));
	sim = sum(resMat1 .* resMat2) ./ sqrt(sum(resMat1 .^2) * sum(resMat2 .^2));
end
