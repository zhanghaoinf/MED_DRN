homeFolder  = [ '/home/hzhang57/'];
projectRoot = [ homeFolder, 'NEW_WORLD/Project_3_ROOT/'];
dataRoot    = [ projectRoot, 'DATA/' ];

toolkit     = [ homeFolder, 'toolkit/'];
svmToolkit  = [ toolkit, 'libsvm/matlab/'];
hzToolkit   = [ toolkit, 'hzToolkit/' ];
ssToolkit   = [ toolkit, 'SelectiveSearchCodeIJCV/'];

addpath(svmToolkit);
addpath(hzToolkit);
addpath(ssToolkit);

tvMed       = [ homeFolder, 'Data/MED/' ];
