function main(EventID)
addpath('../../')
paramInit;
% Setting-----
% Temporal Pooling strategy for Baseline and Object Pooling
ValidationFold = 5;
Feature = 'DRN50_L5A'
% Baseline Representation
BgFileBS   = [ dataRoot, Feature, '_COLLECTION_ENC_V5/Event_BG_VLAD.mat'];
PosFileBS  = [ dataRoot, Feature, '_COLLECTION_ENC_V5/E021-E040_100Ex/E0', EventID, '_VLAD','.mat'];

% Obejct Pooling Representation

%--------
TempBgBS = load(BgFileBS);
TempPosBS= load(PosFileBS);

BG_MAT  = sparse([ TempBgBS.BG_MAT ]);
POS_MAT = sparse([ TempPosBS.POS_MAT]);
%--------
BG_Mapped_MAT = BG_MAT;
POS_Mapped_MAT= POS_MAT;

clear BG_MAT;
clear POS_MAT;
clear TempBgBS;
clear TempPosBS;

KF = ['./Kernels/E0', EventID, '.mat']
load(KF)

[LenPos, Dim] = size(POS_Mapped_MAT);
[LenBg, Dim]  = size(BG_Mapped_MAT);
LabelPos = ones(LenPos,1);
LabelBg  = -1 .* ones(LenBg,1);

fprintf('Parse Data...\n');
for FoldCnt = 1:ValidationFold
	[ValPosSt, ValPosEnd] = sbatch(FoldCnt, ValidationFold, LenPos);
	[ValBgSt, ValBgEnd]   = sbatch(FoldCnt, ValidationFold, LenBg);

	valPosIndx{FoldCnt} = [ValPosSt: ValPosEnd];
	valNegIndx{FoldCnt} = [ValBgSt:ValBgEnd];

	trnPosIndx{FoldCnt} = setxor([1:LenPos], [ValPosSt:ValPosEnd]);
	trnNegIndx{FoldCnt} = setxor([1:LenBg] , [ValBgSt: ValBgEnd]);

end
% Cross Validation
ResultFolder = ['./cvRaw2/'];
dirmake(ResultFolder);
FidResult = fopen([ ResultFolder, EventID, '.txt' ],'w');
fprintf(FidResult, 'C\tFold\tAP\n');

ResultStaFolder= ['./cvSta2/'];
dirmake(ResultStaFolder);
FidResultSta = fopen([ResultStaFolder, EventID, '.txt'],'w');
fprintf(FidResultSta,'C\tAP\n');
CRanges = 2.^[-9:2:9];
for C = CRanges
	FoldApMean = 0;
	FoldApMax  = 0;
	for FoldCnt = 1:ValidationFold
		% Train
		% Calculate trn-trn Kernel
		fprintf('Calculate trn-trn kernle...\n')
		% 
		foldPosLabel = LabelPos(trnPosIndx{FoldCnt});
		foldNegLabel = LabelBg(trnNegIndx{FoldCnt});
		foldLabel    = [foldPosLabel ; foldNegLabel];
		P = sum(foldLabel > 0);
		Np = sum(foldLabel < 0);
		Nvsp =Np / P
		Opt = ['-b 1 -t 4 -c ', num2str(C), ' -w1 ', num2str(Nvsp)];
		part1 = KernelM(trnPosIndx{FoldCnt}          , trnPosIndx{FoldCnt});
		part2 = KernelM(trnPosIndx{FoldCnt}          , LenPos + trnNegIndx{FoldCnt});
		part3 = KernelM(LenPos + trnNegIndx{FoldCnt} , trnPosIndx{FoldCnt});
		part4 = KernelM(LenPos + trnNegIndx{FoldCnt} , LenPos + trnNegIndx{FoldCnt});
		trainKernel = [ part1 , part2; part3 , part4];
		n = length(foldLabel);
		model = svmtrain( foldLabel, [(1:n)', trainKernel], Opt);
		% Predict
		Opt2 = ['-b 1'];
		% Calcluate tst-trn Kernel
		fprintf('Calculate tst-trn kernle...\n')

		part1 = KernelM(valPosIndx{FoldCnt}          , trnPosIndx{FoldCnt});
		part2 = KernelM(valPosIndx{FoldCnt}          , LenPos + trnNegIndx{FoldCnt});
		part3 = KernelM(LenPos + valNegIndx{FoldCnt} , trnPosIndx{FoldCnt});
		part4 = KernelM(LenPos + valNegIndx{FoldCnt} , LenPos + trnNegIndx{FoldCnt});

		testKernel = [ part1, part2 ; part3 , part4];
		fprintf('Done\n');
		vPosLabel = LabelPos(valPosIndx{FoldCnt});
		vNegLabel =  LabelBg(valNegIndx{FoldCnt});
		vLabel    = [ vPosLabel ; vNegLabel ];
		m = length(vLabel);
		[PredLabel, Accurancy, PosNegEstimates] = svmpredict(vLabel, [(1:m)', testKernel], model, Opt2);
		PosEstimates = PosNegEstimates(:,1);
		Ap = AP_HZ(vLabel,PosEstimates);
		fprintf(FidResult, '%f\t%d%f\n',C,FoldCnt,Ap);
		FoldApMean = FoldApMean + Ap;
		FoldApMax  = max(FoldApMax, Ap);
	end
		FoldApMean = FoldApMean / ValidationFold;
		fprintf(FidResultSta,'%f\t%f\n',C, FoldApMean);
end
fclose(FidResult);
fclose(FidResultSta)
end
