function assembleResult(EventID)
addpath('../../');
paramInit;
% InFolder
Feature =  'DRN50_pool5';
DetectorType = 'E021-E040_100Ex';
InFolder = [ dataRoot, 'hz_LinFastPred/',Feature,'/',DetectorType,'/'];
% OutFolder
OutFolder = [dataRoot, 'hz_LinFastAsse/',Feature,'/', DetectorType,'/'];
dirmake(OutFolder);
% Structure MED14
Med14VidListFile = [ tvMed, 'STRUCTURE/MED14_Test.txt' ];
VidList     = textread(Med14VidListFile,'%s','delimiter','\n');
VidNum      = length(VidList);
PosEstimates = zeros(VidNum,1);
CEventID = ['E0', EventID];
for VidCnt = 1: VidNum
	fprintf('|Assemble|%d-%d-%d|\n', VidNum, VidCnt, 1);
	Vid = strtrim(char(VidList{VidCnt}));
	VidPredFile = [ InFolder, CEventID, '/',Vid, '.txt' ];
	if exist(VidPredFile)
		Pred = csvread(VidPredFile);
	else
		Pred = 0;
	end
	PosEstimates(VidCnt) = Pred;
end
SavePath = [ OutFolder, CEventID,'.mat'];
save(SavePath,'PosEstimates');
end
