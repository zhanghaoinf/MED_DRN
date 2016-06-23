%% Learn Dict for VLAD
addpath('../../')
paramInit;
run([toolkit, 'vlfeat-0.9.20/toolbox/vl_setup']);
% -----------------------Settings---------------------
FeatTypes = {'DRN50_L4F', 'DRN50_L5A' };
FeatComb = '5A4F';
TypeNum   = length(FeatTypes);
%%---------------------------------------------------
fprintf('Loading Mat .....\n');
for cnt = 1: TypeNum
	FeatType = strtrim(char(FeatTypes{cnt}));
	fprintf('%s\n', FeatType);
	FeatMatFile = ['../', FeatType, '_V2/Params/FeatMat_', FeatType, '.mat']; 
	FeatMatTemp = load(FeatMatFile);
	FeatMat     = FeatMatTemp.FeatMat;
	clear('FeatMatTemp');
	L2NormMat = myl2norm(FeatMat);
	pcaFile     = [ '../', FeatType, '_V2/Params/', FeatType,'/PCAparam_V2.mat'];
	pcaTemp     = load(pcaFile)
	pca_eigvector = pcaTemp.pca_eigvector;
	pca_eigvalue  = pcaTemp.pca_eigvalue;
	invDiag = 1 ./ sqrt(pca_eigvalue)';
	RdFeatMat = bsxfun(@times, L2NormMat * pca_eigvector, invDiag);
	size(RdFeatMat)
	clear('L2NormMat');
	clear('pca_eigvector');
	clear('invDiag');
	if cnt == 1
		maFeatMat = RdFeatMat;
	else
		maFeatMat = [maFeatMat, RdFeatMat ];
	end
end
	clear('RdFeatMat');
	L2NormMat = myl2norm(maFeatMat);
	K = 256;
	[pca_eigvector, pca_eigvalue] = HPCA(L2NormMat, K);
	dirmake(['./Params/', FeatComb]);
	save(['./Params/', FeatComb, '/PCAparam_V2.mat'], 'pca_eigvector', 'pca_eigvalue', '-v7.3');
	invDiag = 1 ./ sqrt(pca_eigvalue)';
	RdFeatMat = bsxfun(@times, L2NormMat * pca_eigvector, invDiag);
	numClusters = 256;
	fprintf('K-means clustering...');
	centers = vl_kmeans(RdFeatMat', numClusters, 'Initialization', 'plusplus');
	centers = centers'; % N-by-Dim
	save(['./Params/', FeatComb, '/centers_V2.mat'], 'centers', '-v7.3');
	fprintf('Done\n');
