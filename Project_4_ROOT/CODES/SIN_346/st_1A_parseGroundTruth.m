function parseGroundTruth(CSt, CEd)
St = str2num(CSt);
Ed = str2num(CEd);
addpath('../../')
paramInit
PosFolder = [dataRoot, 'SIN_346/Pos/'];
NegFolder = [dataRoot, 'SIN_346/Neg/'];
dirmake(PosFolder);
dirmake(NegFolder);
ConceptsListFile = [ dataRoot, 'SIN_346/concept346.txt' ];
ConceptsList = textread(ConceptsListFile, '%s','delimiter','\n');
ConceptsNum  = length(ConceptsList);
Ed = min(Ed, ConceptsNum);
for ConceptCnt = St: Ed
	Concept = strtrim(char(ConceptsList{ConceptCnt}));
	ConceptAnnFile = [ Concept, '.ann'];
	ConceptAnnPath = [ dataRoot, 'SIN_346/ann_2013/', ConceptAnnFile];
	PosFile   = [PosFolder, Concept,'.txt'];
	NegFile   = [NegFolder, Concept,'.txt'];
	PosFid    = fopen(PosFile,'w');
	NegFid    = fopen(NegFile,'w');
	[LIG, XX, Cpt, Video, VidKf, Label] = textread(ConceptAnnPath,'%s%s%s%s%s%s');
	VidKfNum = length(VidKf);
	for VidCnt = 1: VidKfNum
		VidLabel = strtrim(char(Label{VidCnt}));
		VidKfSig = strtrim(char(VidKf{VidCnt}));
		if VidLabel == 'N'
			fprintf(NegFid, '%s\n', VidKfSig);		

		else
			if VidLabel == 'P'
			fprintf(PosFid, '%s\n', VidKfSig);		
			end
		end
		fprintf('|%d:%s|%d of %d\n',ConceptCnt,Concept,VidCnt,VidKfNum);
	end
	fclose(PosFid);
	fclose(NegFid);
end
end
