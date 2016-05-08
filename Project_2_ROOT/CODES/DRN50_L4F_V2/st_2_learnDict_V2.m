% Learn Dict for VLAD
addpath('../../')
paramInit;

%%------------------Settings-----------------
FeatType = 'DRN50_L4F'
FeatMatFile = './Params/FeatMat_DRN50_L4F.mat';
%%-------------------------------------------
fprintf('LoadingMat...\n');
FeatMatTemp = load(FeatMatFile);
FeatMat = FeatMatTemp.FeatMat;				% Feat is N-by-Dim Matrix
clear FeatMatTemp;

[Num, Dim] = size(FeatMat);
fprintf('Done\n');
% Setting
LearnPca = 1;
LearnDict = 1;

% PROCESS_1: L2 norm on CNN descriptor
L2NormMat = myl2norm(FeatMat); 			% N-by-Dim
clear FeatMat;
% PROCESS_2: PCA with wightening
if LearnPca == 1
	K = 256; % Dimension to be reduced
	[pca_eigvector, pca_eigvalue] = HPCA(L2NormMat, K);
	dirmake(['./Params/', FeatType]);
	save(['./Params/', FeatType ,'/PCAparam_V2.mat'], 'pca_eigvector' ,'pca_eigvalue',  '-v7.3');
	% Calculate DimRed featmat
	invDiag = 1 ./ sqrt(pca_eigvalue)';
	RdFeatMat = bsxfun(@times, L2NormMat * pca_eigvector, invDiag); % wightning Rd N-by-Dim
end
% PROCESS_3 k-means
if LearnDict == 1
	run([toolkit, 'vlfeat-0.9.20/toolbox/vl_setup']);
	numClusters = 256;
	fprintf('K-means clustering...');
	centers = vl_kmeans(RdFeatMat', numClusters,'Initialization','plusplus'); % centers is Dim-by-num Clusters.
	centers = centers'; % N-by-Dim
	save(['./Params/', FeatType, '/centers_V2.mat'], 'centers',  '-v7.3');
	fprintf('done\n');
end

