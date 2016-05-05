function main()
addpath('../../')
paramInit
fid = fopen('./Param/train.txt','w');
for CID = 1:497
	fprintf('CID:%d\n',CID-1);
	KfFolder = [ dataRoot,'RC_497/PosSamples/', num2str(CID-1),'/'];
	KfList   = dir([KfFolder, '*.jpg']);
	KfNum = length(KfList);
	for KfCnt = 1: KfNum
		Kf = strtrim(char(KfList(KfCnt).name));
		KfPath = [num2str(CID-1),'/',Kf];
		fprintf(fid, '%s %d\n',KfPath, CID-1);
	end
end
fclose(fid);
end
