function main()
addpath('../../')
paramInit
fid = fopen('./Param/test.txt','w');
for CID = 1:346
	fprintf('CID:%d\n',CID-1);
	KfFolder = [ dataRoot,'SIN_346/SValSamples/', num2str(CID-1),'/'];
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
