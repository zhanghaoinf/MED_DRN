function main(EventID)
addpath('../../')
paramInit;
% Setting-----
% Temporal Pooling strategy for Baseline and Object Pooling
Feature = 'DRN50_L3D'
% Baseline Representation
BgFileBS   = [ dataRoot, Feature, '_COLLECTION_ENC/Event_BG_VLAD.mat'];
PosFileBS  = [ dataRoot, Feature, '_COLLECTION_ENC/E021-E040_100Ex/E0', EventID, '_VLAD','.mat'];

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
clear  TempPosBS;
dirmake('./Kernels');
CEventID = ['./Kernels/E0', EventID, '.mat'];
KernelM = [POS_Mapped_MAT; BG_Mapped_MAT] * [POS_Mapped_MAT; BG_Mapped_MAT]';
save(CEventID, 'KernelM');
end
