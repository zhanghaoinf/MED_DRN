addpath('../../')
paramInit
%%%-----------------------------
feat = 'DRN50_L5C'
fmt  = 'mat';
tempFolder = './Params/';
outFile_1  = [ tempFolder, feat, '_1A_list.txt' ];
%%%-----------------------------

% Bg list
listBgFile = [ tvMed, 'STRUCTURE/Event_BG.txt' ];
listBg     = textread(listBgFile, '%s', 'delimiter','\n');
numBg	   = length(listBg);
% Pos list
listPosFile = [ tvMed, 'STRUCTURE/E021-E040_100Ex.txt' ];
listPos     = textread(listPosFile, '%s', 'delimiter', '\n');
numPos      = length(listPos);

% Step 1: Frame List Gen
fid = fopen(outFile_1,'w');
posFeatFolder = [ dataRoot, 'SPMAX/E021-E040_100Ex/', feat, '/' ];
for vidCnt = 1: numPos
	vid =strtrim(char(listPos{vidCnt}));
	vidFile = [ posFeatFolder, vid, '.mat'];
	temp    = load(vidFile);
	%--------------------------------------------
	featMat = temp.vidFeat;
	%--------------------------------------------
	[featNum, dim]    = size(featMat);
	if featNum ~=0 
		for featCnt = 1:featNum
			fprintf('1/3|POS|VID: %d/%d |KF: %d/%d\n ', vidCnt, numPos, featCnt, featNum);
			featPath = [ vidFile,':' , num2str(featCnt) ];
			fprintf(fid, '%s\n', featPath);
		end
	end
end


bgFeatFolder = [ dataRoot, 'SPMAX/Event_BG/', feat, '/' ]; 
for vidCnt = 1: numBg
	vid =strtrim(char(listBg{vidCnt}));
	vidFile = [ bgFeatFolder, vid, '.mat'];
	temp    = load(vidFile);
	%--------------------------------------------
	featMat = temp.vidFeat;
	%--------------------------------------------
	[featNum, dim]	= size(featMat);
	if featNum ~=0 
		for featCnt = 1:featNum
			fprintf('1/3|BG|VID: %d/%d |KF: %d/%d\n ', vidCnt, numBg, featCnt, featNum);
			featPath = [ vidFile,':' , num2str(featCnt) ];
			fprintf(fid, '%s\n', featPath);
		end
	end
end

fclose(fid);

