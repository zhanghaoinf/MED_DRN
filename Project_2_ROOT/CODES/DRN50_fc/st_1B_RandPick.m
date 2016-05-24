inListFile = './Params/DRN50_fc_1A_list.txt';
inList     = textread(inListFile, '%s', 'delimiter','\n');
inNum      = length(inList);
listRand   = randperm(inNum);
idxRand    = randperm(inNum);

selected = 521266;
%selected = 521;
selected = min(selected, inNum);
idxs     = idxRand(1:selected);

List = listRand(idxs);

outListFile= './Params/DRN50_fc_1B_list.txt';
fid = fopen(outListFile, 'w');
for cnt = 1: length(List)
	fprintf('Processing: %d/%d\n', cnt, length(List));
	Line = strtrim(char( inList{ List(cnt) }));
	fprintf(fid, '%s\n', Line);
end

fclose(fid);

