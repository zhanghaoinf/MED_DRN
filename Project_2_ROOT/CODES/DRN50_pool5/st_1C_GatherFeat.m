[featPaths, kfIDs] = textread(['./Params/DRN50_pool5_1B_list.txt'], '%s%d','delimiter',':');
featNum = length(featPaths);

Dim = 2048;
FeatMat = zeros(featNum, Dim);
for cnt = 1: featNum
	featPathSig = strtrim(char(featPaths{cnt}));
	kfSig       = kfIDs(cnt);
	fprintf('%d %d\n', cnt, featNum);
	temp = load(featPathSig);
	Feat = temp.pool5(kfSig,:);
	FeatMat(cnt, :) = Feat;
end
save ./Params/FeatMat_DRN50_pool5.mat FeatMat -v7.3
