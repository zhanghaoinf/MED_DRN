function main(eventid)
addpath('../../');
paramInit;

DetType = 'E021-E040_100Ex'
OutFolder = [ dataRoot, 'IDT_L5A_V5_FUS/', DetType, '/' ];
%createFolder(OutFolder);
OutFile   = [ OutFolder, 'E0', eventid, '.mat'];

% L5A_V5
inFile1 = [dataRoot, 'hz_LinFastAsse_V5/DRN50_L5A/', DetType, '/E0', eventid ,'.mat'];
temp = load(inFile1);
pos = temp.PosEstimates;
pos = (pos - min(pos)) / (max(pos) - min(pos));
% IDT
inFile2 = [ dataRoot, 'IDT/', DetType, '/E0', eventid, '.mat' ];
temp = load(inFile2);
pos2  = temp.PosEstimates;
pos2 = (pos2 - min(pos2)) / (max(pos2) - min(pos2));

PosEstimates = (pos + pos2)/2;
save(OutFile, 'PosEstimates');
end
