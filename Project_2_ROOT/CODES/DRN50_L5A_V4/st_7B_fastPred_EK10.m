function eventPredictAVE(StCVid, EdCVid)
addpath('../../');
paramInit;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setting-----
DetectorType = 'E021-E040_10Ex';
Feature = 'DRN50_L5A';
BSFeatFolder = [ dataRoot, Feature, '_VLAD_ENC_V4/MED14_Test/'];
ModelFolder  = [ dataRoot, 'hz_LinFastSVM_V4/',Feature,'/',DetectorType,'/']
PredFolder   = [ dataRoot, 'hz_LinFastPred_V4/',Feature,'/',DetectorType,'/'];
dirmake(PredFolder);
%------------------
%StruCture File: MED14List
Med14VidListFile = [ tvMed, 'STRUCTURE/MED14_Test.txt'];
VidList = textread(Med14VidListFile, '%s','delimiter','\n');
VidNum  = length(VidList);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Loading Model
MODEL = containers.Map;
EventList = [21:40];
for EventID = EventList % Event21 to Event40
	CEventID = ['E0', num2str(EventID)];
	ModelFile = [ ModelFolder, CEventID, '.mat' ];
	ModelTemp = load(ModelFile);
	Model = ModelTemp.fastModel;
	MODEL(CEventID) = Model;
	OutEventPredFolder = [ PredFolder, CEventID, '/'];
	dirmake(OutEventPredFolder);
end
% Predict Med14 Test
StVid = str2num(StCVid);
EdVid = str2num(EdCVid);
for VidCnt = StVid : EdVid
	Vid = strtrim(char(VidList{VidCnt}));
	fprintf('|Predict|%d|%d-%d-%d|\n',VidNum, EdVid, VidCnt, StVid);
	SaveFile = [PredFolder,'E040/', Vid,'.txt' ];
	if  exist(SaveFile)
		continue;
	end
	VidFeatBSFile = [ BSFeatFolder, Vid, '.txt' ];
	if exist(VidFeatBSFile)
		VidFeatBS = csvread(VidFeatBSFile);
		VidFeat = [ VidFeatBS ];
		if sum(VidFeat) ~=0
			VidFeatMapped = sparse(VidFeat);
			for Event = EventList
				CEventID = ['E0', num2str(Event)];
				Model = MODEL(CEventID);
				ProbA = Model('ProbA');
				ProbB = Model('ProbB');
				hyperPlane = Model('hyperPlane');
				rho        = Model('rho');
				%Label = 1;
				SaveFile = [PredFolder, CEventID,'/', Vid,'.txt' ];
				PosEstimates = 1 / ( 1 + exp( ProbA * ( VidFeatMapped * hyperPlane' - rho) +ProbB ) );
				%[PredLabel,Acurrancy, PosNegEstimates] = svmpredict(Label,VidFeatMapped,Model,Opt_2);
				csvwrite(SaveFile,PosEstimates);
			end
		end
	else
		continue;
	end
end
end
