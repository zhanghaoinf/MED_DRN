function main(CSt, CEd)
addpath('../../')
paramInit;
run([toolkit, 'vlfeat-0.9.20/toolbox/vl_setup']);

Feature  = 'DRN50_L5C';
FeatDim = 2048;
%%--------------Load Centers-------------------
centersFile = [ './Params/', Feature,'/centers_V2.mat' ];
centersTemp = load(centersFile);
centers = centersTemp.centers; % n-by-d
centers = centers'; % d-by-n
%%-------------Load PCA ------------------------
pcaFile = [ './Params/', Feature,'/PCAparam_V2.mat' ];
pcaTemp = load(pcaFile);
pca_eigvector = pcaTemp.pca_eigvector;
pca_eigvalue  = pcaTemp.pca_eigvalue;

%+++++++++++++++++++++++++++++++++++++++++++++++++
K = 256;
TopN = 5;
Beta = 1;
DataType =  'MED14_Test';
FileList = [ tvMed, 'STRUCTURE/',DataType,'.txt'];
VidList = textread(FileList, '%s','delimiter','\n');
VidNum = length(VidList);
St = str2num(CSt);
Ed = str2num(CEd);
Ed =min(Ed, VidNum);
OutPutFolder = [ dataRoot, Feature,'_VLAD_ENC/', DataType,'/'];
dirmake(OutPutFolder);
for VidCnt = St: Ed
	fprintf('%s Encode %d-%d-%d\n', DataType, Ed,VidCnt, St);
	Vid = strtrim(char(VidList{VidCnt}));
	savepath = [ OutPutFolder, Vid,'.txt' ];
	if exist(savepath)
		continue;
	end
	inFile = [ dataRoot,'SPMAX/', DataType, '/', Feature,'/', Vid,'.mat'];
	temp = load(inFile);
	%%+++++++++++++++++++++++++++++++++++++++++++++++++++
	feat = temp.vidFeat;
	[N, tDim] = size(feat);

	%%+++++++++++++++++++++++++++++++++++++++++++++++++++
	%-------------------%
	% VLAD Encoding	    %
	%-------------------%
	% PROCESS_2: PCA white
	invDiag = 1 ./ sqrt(pca_eigvalue');
	RdFeatMat = bsxfun(@times, feat*pca_eigvector, invDiag); % N-by-Dim
	[numData, Dim] = size(RdFeatMat);
	% PROCESS_3: VLAD
	[Dim, numClusters] = size(centers);
	kdtree = vl_kdtreebuild(centers);
	[INDEX, DIST] = vl_kdtreequery(kdtree,double(centers),double(RdFeatMat'),'NumNeighbors', TopN);
	assignments = zeros(numClusters, numData);
	for j = 1: TopN
		%for k = 1: numData
			nn= double(INDEX(j,:));
			assignments(sub2ind(size(assignments), nn,1:length(nn)))= 1;
		%end
	end
	assignments = assignments /TopN;
	enc = (vl_vlad(double(RdFeatMat'), double(centers), assignments,'SquareRoot','NormalizeComponents'))';
	csvwrite(savepath, enc)
end
end
