function main(EventID)
% EventID '21'
addpath('../../');
paramInit
% Feature Config
Feature = 'DRN50_L4F';
Dim     = 256*256;

CEventID = ['E021-E040_100Ex'];
% Infolder
InFolder  = [ dataRoot, Feature, '_VLAD_ENC/', CEventID, '/'];
% Outfolder
OutFolder = [ dataRoot, Feature, '_COLLECTION_ENC/', CEventID ];
dirmake(OutFolder);
OutFile = [ OutFolder,'/E0',EventID, '_VLAD.mat' ]; 
% Structure 
VidListFolder = [ tvMed, 'STRUCTURE/MED14/',CEventID,'/'];
VidListFile   = [ VidListFolder, 'E0', EventID, '_POS.txt' ];
VidList     = textread(VidListFile, '%s','delimiter','\n');
VidNum      = length(VidList);

POS_MAT      = zeros(VidNum, Dim);
POS_Cnt = 1;
for VidCnt = 1: VidNum
	fprintf('%d %d %d\n', VidNum, VidCnt, 1);
	Vid = strtrim(char(VidList{VidCnt}));
	VidFeatFile = [ InFolder, Vid, '.txt' ];
	if ~exist(VidFeatFile)
		continue;
	end
	VidFeat     = csvread(VidFeatFile);
	POS_MAT(POS_Cnt,:) = VidFeat;
	POS_Cnt = POS_Cnt + 1;
end
	if POS_Cnt < VidNum
		POS_MAT(POS_Cnt:VidNum,:) = [];
	end
	save(OutFile, 'POS_MAT');
end
