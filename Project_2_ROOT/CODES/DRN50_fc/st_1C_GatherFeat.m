[featPaths, kfIDs] = textread(['./Params/DRN50_fc_1B_list.txt'], '%s%d','delimiter',':');
featNum = length(featPaths);

Dim = 1000;
FeatMat = zeros(featNum, Dim);
for cnt = 1: featNum
	featPathSig = strtrim(char(featPaths{cnt}));
	kfSig       = kfIDs(cnt);
	fprintf('%d %d\n', cnt, featNum);
	temp = load(featPathSig);
	Feat = temp.fc(kfSig,:);
	FeatMat(cnt, :) = Feat;
end
save ./Params/FeatMat_DRN50_fc.mat FeatMat -v7.3
