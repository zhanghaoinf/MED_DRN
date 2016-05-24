function main()
addpath('../../');
paramInit
% Feature Config
Feature = 'DRN50_L5A';
Dim     = 256*256;

CEventID = ['Event_BG'];
% Infolder
InFolder  = [ dataRoot, Feature, '_VLAD_ENC_V3/', CEventID, '/'];
% Outfolder
OutFolder = [ dataRoot, Feature, '_COLLECTION_ENC_V3/'];
dirmake(OutFolder);
OutFile = [ OutFolder, CEventID, '_VLAD.mat' ]; 
% Structure 
VidListFile = [ tvMed, 'STRUCTURE/',CEventID,'.txt'];
VidList     = textread(VidListFile, '%s','delimiter','\n');
VidNum      = length(VidList);

BG_MAT      = zeros(VidNum, Dim);
BG_Cnt = 1;
for VidCnt = 1: VidNum
	fprintf('%d %d %d\n', VidNum, VidCnt, 1);
	Vid = strtrim(char(VidList{VidCnt}));
	VidFeatFile = [ InFolder, Vid, '.txt' ];
	if ~exist(VidFeatFile)
		continue;
	end
	VidFeat     = csvread(VidFeatFile);
	BG_MAT(BG_Cnt,:) = VidFeat;
	BG_Cnt = BG_Cnt + 1;
end
	if BG_Cnt < VidNum
		BG_MAT(BG_Cnt:VidNum,:) = [];
	end
	save(OutFile, 'BG_MAT','-v7.3');
end
