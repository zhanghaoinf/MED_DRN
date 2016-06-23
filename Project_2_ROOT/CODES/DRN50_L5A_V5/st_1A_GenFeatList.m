addpath('../../')
paramInit
%%%-----------------------------
feat = 'DRN50_L5A'
fmt  = 'mat';
tempFolder = './Params/';
dirmake(tempFolder);
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
posStaFolder  = [ dataRoot, 'Tar_STA/E021-E040_100Ex/', feat, '/' ];
posFeatFolder = [ dataRoot, 'Tar_SPMAX/E021-E040_100Ex/', feat, '/' ];
for vidCnt = 1: numPos
	vid =strtrim(char(listPos{vidCnt}));
	vidFile = [ posStaFolder, vid, '.mat'];
	vidFeatFile = [ posFeatFolder, vid, '.7z'];
	temp    = load(vidFile);
	%--------------------------------------------
	featNum = temp.kfcnt;
	%--------------------------------------------
	if featNum ~=0 
		for featCnt = 1:featNum
			fprintf('1/3|POS|VID: %d/%d |KF: %d/%d\n ', vidCnt, numPos, featCnt, featNum);
			featPath = [ vidFeatFile,':' , num2str(featCnt) ];
			fprintf(fid, '%s\n', featPath);
		end
	end
end


bgStaFolder = [ dataRoot, 'Tar_STA/Event_BG/', feat, '/' ]; 
bgFeatFolder = [ dataRoot, 'Tar_SPMAX/Event_BG/', feat, '/' ]; 
for vidCnt = 1: numBg
	vid =strtrim(char(listBg{vidCnt}));
	vidFile = [ bgStaFolder, vid, '.mat'];
	vidFeatFile = [ bgFeatFolder, vid, '.7z'];
	temp    = load(vidFile);
	%--------------------------------------------
	featNum = temp.kfcnt;
	%--------------------------------------------
	if featNum ~=0 
		for featCnt = 1:featNum
			fprintf('1/3|BG|VID: %d/%d |KF: %d/%d\n ', vidCnt, numBg, featCnt, featNum);
			featPath = [ vidFeatFile,':' , num2str(featCnt) ];
			fprintf(fid, '%s\n', featPath);
		end
	end
end

fclose(fid);

