function main()
addpath('../../');
paramInit;
fprintf('\n');
Test_Set = 'MED14_Test';
%Setting------------------------
PredictFolder_1  = [ dataRoot,'hz_LinFastAsse_V5/DRN50_L5A/E021-E040_100Ex/'];
PredictFolder_2  = [ dataRoot,'hz_LinFastAsse_V5/DRN50_L5A/E021-E040_10Ex/'];

PredictFolder_3  = [ dataRoot,'IDT_L5A_V5_FUS/E021-E040_100Ex/'];

PredictFolder = PredictFolder_3
%-------------------------------
TestGroundTruthFolder = [ tvMed,'/STRUCTURE/MED14/MED14-Test_Ground_Truth_Modified/' ];
Map = 0;
for EventID = 21:40
	CEventID = ['E0',num2str(EventID)];
	PosEstFile= [ PredictFolder, CEventID, '.mat'];
	GroundTruthFile = [ TestGroundTruthFolder, CEventID, '.txt' ];
	PosRaw = load(PosEstFile);
	PosEstimates = PosRaw.PosEstimates;
	[Vid, GroundTruth] = textread(GroundTruthFile,'%s%d','delimiter',',');
	Ap = AP_N(GroundTruth,PosEstimates);
	Ap = round(Ap * 1000) / 1000;
	Map = Map + Ap;
	fprintf('%s\t%.3f\n',CEventID, Ap);
end
	Map = round(Map * 1000) ./ 20000;
	fprintf('%s\t%.3f\n','MAP',Map);
end
