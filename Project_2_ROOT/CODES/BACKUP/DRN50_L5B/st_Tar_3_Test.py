#!/usr/bin/env python
import os
import sys
import string
from subroutine import createFolder

dataRoot = '/home/hzhang57/NEW_WORLD/Project_2_ROOT/DATA'
tvFolder = '/home/hzhang57/Data/MED'

###-------------------only modify this part --------------------------
fmt = '.mat'
tarFmt = '.7z'
feat   = 'DRN50_L5B'
dataSet = 'MED14_Test'
###-------------------only modify this part --------------------------
fileList = os.path.join(tvFolder, 'STRUCTURE', dataSet + '.txt')
sp_folder = os.path.join(dataRoot, 'SPMAX', dataSet, feat)
createFolder(os.path.join(dataRoot, 'Tar_SPMAX'))
createFolder(os.path.join(dataRoot, 'Tar_SPMAX', dataSet))
tar_folder= os.path.join(dataRoot, 'Tar_SPMAX', dataSet, feat)
createFolder(tar_folder)

ArgvLen = len(sys.argv)
if ArgvLen != 3:
	print ("-"*30)
	print ("Number of argv is not correct\n, please specify start and end number\n" )
	print ("-"*30)

fid = open(fileList, 'r')
vidList = fid.readlines()
vidNum = len(vidList)
fid.close()
stLine = string.atoi(sys.argv[1])
edLine = min( string.atoi(sys.argv[2]), vidNum)
cntRange = range(stLine -1 , edLine)

for cnt in cntRange:
	print ("%d|%d-%d") % (cnt, stLine-1, edLine-1)
	vid = vidList[cnt].strip()
	oriIn = os.path.join(sp_folder, vid+fmt)
	tarOut = os.path.join(tar_folder, vid + tarFmt)
	if not (os.path.exists(oriIn)):
		continue
	else:
		cmd1 = '7za a -t7z -m0=LZMA2 -mmt=10 ' + tarOut + ' '	+ oriIn
		cmd2 = 'rm ' + oriIn
		os.system(cmd1)
		os.system(cmd2)

