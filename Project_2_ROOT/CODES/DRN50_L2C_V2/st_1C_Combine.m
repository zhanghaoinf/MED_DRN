function main()
addpath('../../');
paramInit;

[featPaths, kfIDs] = textread(['./Params/DRN50_L2C_1B_list.txt'], '%s%d','delimiter',':');
featNum = length(featPaths);

Dim = 256;
FeatMat = zeros(featNum, Dim);
idx = 1;
for cnt = 1:100
	fprintf('%d\n',cnt);
	featPath = ['./Params/FeatMat_DRN50_L2C_',num2str(cnt),'.mat'];
	temp = load(featPath);
	Feat = temp.FeatMat;
	[len, Dim] = size(Feat);
	FeatMat(idx:idx+len-1,:) = Feat;
	idx = idx+len;
end
save(['./Params/FeatMat_DRN50_L2C','.mat'], 'FeatMat', '-v7.3')
end
