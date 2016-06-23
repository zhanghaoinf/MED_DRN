function main(CSt, CEd)
addpath('../../')
paramInit;
run([toolkit, 'vlfeat-0.9.20/toolbox/vl_setup']);

FeatTypes= {'DRN50_L4F', 'DRN50_L5A'};
TypeNum  = length(FeatTypes);
FeatComb = '5A4F';
%%--------------Load Centers-------------------
centersFile = [ './Params/', FeatComb,'/centers_V2.mat' ];
centersTemp = load(centersFile);
centers = centersTemp.centers; % n-by-d
centers = centers'; % d-by-n
%%-------------Load PCA ------------------------
pcaFile = [ './Params/', FeatComb,'/PCAparam_V2.mat' ];
pcaTemp = load(pcaFile);
pca_eigvector = pcaTemp.pca_eigvector;
pca_eigvalue  = pcaTemp.pca_eigvalue;

%+++++++++++++++++++++++++++++++++++++++++++++++++
K = 256;
TopN = 5;
Beta = 1;
DataType =  'Event_BG';
FileList = [ tvMed, 'STRUCTURE/',DataType,'.txt'];
VidList = textread(FileList, '%s','delimiter','\n');
VidNum = length(VidList);
St = str2num(CSt);
Ed = str2num(CEd);
Ed =min(Ed, VidNum);
OutPutFolder = [ dataRoot, FeatComb,'_VLAD_ENC/', DataType,'/'];
dirmake(OutPutFolder);
for VidCnt = St: Ed
	Vid = strtrim(char(VidList{VidCnt}));
	savepath = [ OutPutFolder, Vid,'.txt' ];
	if exist(savepath)
		continue;
	end
	for cnt = 1: TypeNum
		Feature = strtrim(char(FeatTypes{cnt}));
		inFile = [ dataRoot,'Tar_SPMAX/', DataType, '/', Feature,'/', Vid,'.7z'];
		cmd1 = [ '7z x ', inFile, ' -o./temp/' ];
		system(cmd1);
		tempFile = ['./temp/', Vid, '.mat'];
		temp = load(tempFile);
		cmd2 = ['rm ', tempFile ];
		system(cmd2);
		%%+++++++++++++++++++++++++++++++++++++++++++++++++++
		feat = myl2norm(temp.vidFeat);
		[N, tDim] = size(feat);
		fprintf('%s Encode %d-%d-%d:%d\n', DataType, Ed,VidCnt, St, N);
		pcaFile = ['../', FeatType, '_V2/Params/', FeatType, '/PCAparam_V2.mat'];
		pcaTemp = load(pcaFile);
		sigPca_egvalue = pcaTemp.pca_eigvalue;
		invDiag = 1 ./ sqrt(sigPca_egvalue');
		sigPca_egvector = pcaTemp.pca_eigvector;
		RdFeatMat = bsxfun(@times, feat*sigPca_egvector, invDiag); % N-by-Dim
		if  cnt == 1
			maFeatMat = RdFeatMat;
		else
			maFeatMat = [ maFeatMat, RdFeatMat];
		end
	end

	%%++++++++++++++++++++++++++++++++++++++V+++++++++++++
	L2NormMat = myl2norm(maFeatMat);
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
