function main(CSt, CEd)
addpath('../../')
paramInit;
run([toolkit, 'vlfeat-0.9.20/toolbox/vl_setup']);

Feature  = 'DRN50_L5A';
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
DataType =  'E021-E040_100Ex';
FileList = [ tvMed, 'STRUCTURE/',DataType,'.txt'];
VidList = textread(FileList, '%s','delimiter','\n');
VidNum = length(VidList);
St = str2num(CSt);
Ed = str2num(CEd);
Ed =min(Ed, VidNum);
OutPutFolder = [ dataRoot, Feature,'_VLAD_ENC_V4/', DataType,'/'];
dirmake(OutPutFolder);
for VidCnt = St: Ed
	Vid = strtrim(char(VidList{VidCnt}));
	savepath = [ OutPutFolder, Vid,'.txt' ];
	if exist(savepath)
		continue;
	end
	inFile = [ dataRoot,'Tar_SPMAX/', DataType, '/', Feature,'/', Vid,'.7z'];
	cmd1 = [ '7z x ', inFile, ' -o./temp/' ];
	system(cmd1);
	tempFile = ['./temp/', Vid, '.mat'];
	temp = load(tempFile);
	cmd2 = ['rm ', tempFile ];
	system(cmd2);
	%%+++++++++++++++++++++++++++++++++++++++++++++++++++
	feat = myl2norm(temp.vidFeat);
	%feat = (temp.vidFeat);
	[N, tDim] = size(feat);
	fprintf('%s Encode %d-%d-%d:%d\n', DataType, Ed,VidCnt, St, N);

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
