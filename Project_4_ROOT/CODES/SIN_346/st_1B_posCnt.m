function posCnt()
addpath('../../')
paramInit
ConceptsListFile = [ dataRoot, 'SIN_346/concept346.txt'];
ConceptsList     = textread(ConceptsListFile, '%s','delimiter','\n');
ConceptsNum      = length(ConceptsList);
OutFile = [dataRoot, 'SIN_346/NumPosClass.txt'];
fid = fopen(OutFile, 'w');
aveNum = 0;
for ConceptCnt = 1:ConceptsNum
	fprintf('%d of %d\n', ConceptCnt, ConceptsNum);
	Concept = strtrim(char(ConceptsList{ConceptCnt}));
	ConceptPosFile = [Concept, '.txt'];
	ConceptPosPath = [ dataRoot, 'SIN_346/Pos/', ConceptPosFile ];
	PosKf = textread(ConceptPosPath,'%s','delimiter','\n');
	fprintf(fid,'%s\t%d\n', Concept, length(PosKf));
	aveNum = aveNum + length(PosKf);
end
	aveNum = aveNum / ConceptsNum;
	fprintf(fid,'%s\t%f\n', 'AVE', aveNum);
fclose(fid);
end
