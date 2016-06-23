function eventDetectorTrain(EventID)
addpath('../../');
paramInit;
% Setting-----
Pooling = 'VLAD';
C = 2;
DetectorType = 'E021-E040_100Ex';
Feature = 'DRN50_L5A';
%------------
% Feature Folder
BgFile = [ dataRoot, Feature, '_COLLECTION_ENC_V4/Event_BG_', Pooling,'.mat' ];
PosFile= [ dataRoot, Feature, '_COLLECTION_ENC_V4/',DetectorType,'/E0', EventID, '_',Pooling,'.mat' ];

% Out Folder
OutFolder = [dataRoot, 'LinSVM_V4/',Feature, '/', DetectorType,'/'];
dirmake(OutFolder);
%--------------
TempBg = load(BgFile);
TempPos= load(PosFile);

BG_Mapped_MAT = sparse([TempBg.BG_MAT]);
POS_Mapped_MAT= sparse([TempPos.POS_MAT]);
[LenPos, Dim] = size(POS_Mapped_MAT);
[LenBg, Dim]  = size(BG_Mapped_MAT);
LabelPos = ones(LenPos,1);
LabelBg  = -1 .* ones(LenBg, 1);

FeatMat = [POS_Mapped_MAT; BG_Mapped_MAT];
LabelMat= [ LabelPos; LabelBg];
Opt = ['-b 1 -t 0 -c ', num2str(C)];
model = svmtrain(LabelMat, FeatMat, Opt);
saveFile = [ OutFolder, 'E0', EventID, '.mat' ];
save(saveFile, 'model');
end
