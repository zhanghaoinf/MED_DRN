[featPaths, kfIDs] = textread(['./Params/DRN50_prob_1B_list.txt'], '%s%d','delimiter',':');
featNum = length(featPaths);

Dim = 1000;
FeatMat = zeros(featNum, Dim);
for cnt = 1: featNum
	featPathSig = strtrim(char(featPaths{cnt}));
	kfSig       = kfIDs(cnt);
	fprintf('%d %d\n', cnt, featNum);
	temp = load(featPathSig);
	Feat = temp.prob(kfSig,:);
	FeatMat(cnt, :) = Feat;
end
save ./Params/FeatMat_DRN50_prob.mat FeatMat -v7.3
