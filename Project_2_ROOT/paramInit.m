homeFolder  = [ '/home/hzhang57/'];
projectRoot = [ homeFolder, 'NEW_WORLD/Project_2_ROOT/'];
dataRoot    = [ projectRoot, 'DATA/' ];

toolkit     = [ homeFolder, 'toolkit/'];
svmToolkit  = [ toolkit, 'libsvm/matlab/'];
hzToolkit   = [ toolkit, 'hzToolkit/' ];

addpath(svmToolkit);
addpath(hzToolkit);

tvMed       = [ homeFolder, 'Data/MED/' ];
