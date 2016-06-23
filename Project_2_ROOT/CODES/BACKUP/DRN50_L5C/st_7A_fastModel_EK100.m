function main(CSt, CEd)
addpath('../../')
paramInit;
St = str2num(CSt);
Ed = str2num(CEd);
FeaType = 'DRN50_L5C';
TrnType = 'E021-E040_100Ex';
inModelFolder  = [ dataRoot, 'LinSVM/', FeaType, '/', TrnType, '/'];
outModelFolder = [ dataRoot, 'hz_LinFastSVM/', FeaType, '/', TrnType, '/'];
dirmake(outModelFolder);
 
for eventCnt = St:Ed
	EventID = [ 'E0', num2str(eventCnt) ];
	fprintf('Processing:%s...\n', EventID);
 	modelFile    = [ inModelFolder, EventID ,'.mat'];
	outModelFile = [ outModelFolder, EventID, '.mat'];
	temp = load(modelFile);
	model = temp.model;
	[n,dim] = size(model.SVs);
	hyperPlane = zeros(1, dim);
	for cnt = 1:model.totalSV
		hyperPlane = hyperPlane + model.sv_coef(cnt) * model.SVs(cnt,:);
	end
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	fastModel = containers.Map();
	fastModel('ProbA') = model.ProbA;
	fastModel('ProbB') = model.ProbB;
	fastModel('rho')   = model.rho;
	fastModel('hyperPlane') = hyperPlane;
	save(outModelFile, 'fastModel');
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
end
