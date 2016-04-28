function GenRePos(CSt, CEd)
addpath('../../')
paramInit
ConceptsFile = [ dataRoot, 'SIN_346/concept346_ID.txt' ];
[Concepts, CIDS] = textread(ConceptsFile, '%s\t%s');
ConceptNum = length(Concepts);
OutputTrainFolder = [ dataRoot, 'SIN_346/SPosSamples/'];
dirmake(OutputTrainFolder);
OutputValFolder   = [ dataRoot, 'SIN_346/SValSamples/'];
dirmake(OutputValFolder);
St = str2num(CSt);
Ed = str2num(CEd);
Partion = 0.7
MaxNum = 3000;
for CptCnt = St:Ed
	fprintf('|%d-%d|%d\n',Ed, St, CptCnt);
	Concept = strtrim(char(Concepts{CptCnt}));
	CID 	= strtrim(char(CIDS{CptCnt}));
	OutputTrainCID = [ OutputTrainFolder, CID,'/' ];
	dirmake(OutputTrainCID);
	
	OutputValCID = [ OutputValFolder, CID,'/' ];
	dirmake(OutputValCID);

	ConceptPos = [ dataRoot, 'SIN_346/Pos/', Concept, '.txt'];
	PosPaths = textread(ConceptPos, '%s');
	PosNum   = length(PosPaths)
	RealNum = min(PosNum, MaxNum);
	TrainPos = floor(RealNum * Partion);
	
	NUMLIST = randperm(PosNum);
	for PosCnt = 1: TrainPos
		fprintf('|%d-%d|%dPOS:%d of %d|%d|\n', Ed, St,CptCnt,PosCnt, TrainPos,NUMLIST(PosCnt))
		PosIns = strtrim(char(PosPaths{NUMLIST(PosCnt)}));
		SubStr = strsplit(PosIns, '/');
		Img    = strtrim(char(SubStr(2)));
		OriPath = [ dataRoot, 'SIN_346/keyframes_2013/', PosIns,'.jpg' ];
		DestPath =[ OutputTrainCID, Img,'.jpg' ];
		im = imread(OriPath);
		imRes = imresize(im,[256,256],'bilinear');
		imwrite( imRes, DestPath);
	end
	for PosCnt = TrainPos+1:RealNum
		fprintf('|%d-%d|%dVal:%d of %d|%d|\n', Ed, St, CptCnt,PosCnt, RealNum,NUMLIST(PosCnt))
		PosIns = strtrim(char(PosPaths{NUMLIST(PosCnt)}));
		SubStr = strsplit(PosIns, '/');
		Img    = strtrim(char(SubStr(2)));
		OriPath = [ dataRoot, 'SIN_346/keyframes_2013/', PosIns,'.jpg' ];
		DestPath =[ OutputValCID, Img,'.jpg' ];
		im = imread(OriPath);
		imRes = imresize(im,[256,256],'bilinear');
		imwrite( imRes, DestPath);
	end
end
end
