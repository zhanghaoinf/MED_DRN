#!/usr/bin/env python
import scipy.io as sio
import numpy as np
import os
import sys
import string
from subroutine import maxPool3DMat, createFolder

dataRoot     = '/home/hzhang57/NEW_WORLD/Project_2_ROOT/DATA'
trecvidFolder = '/home/hzhang57/Data/MED'
###----------only modify this part-----------------------
fmt = '.mat'
tarFmt = '.7z'
feature = 'DRN50_L5C'
dataSet = 'E021-E040_100Ex'
###---------------------------------------------
fileList   = os.path.join(trecvidFolder, 'STRUCTURE', dataSet+'.txt')
featureFolder = os.path.join(trecvidFolder,'Features', dataSet, feature)
createFolder(os.path.join(dataRoot, 'SPMAX'))
createFolder(os.path.join(dataRoot, 'SPMAX', dataSet))
outFolder     = os.path.join(dataRoot, 'SPMAX',dataSet, feature)
createFolder(outFolder)

ArgvLen = len(sys.argv)
if ArgvLen!= 3:
	print ("-" * 30)
	print("Number of argv is not correct\n please specify start and end number")
	print ("-" * 30)
	exit(0)
stLine = string.atoi(sys.argv[1])
edLine = string.atoi(sys.argv[2])
cntRange = range(stLine-1, edLine)
fid = open(fileList)
vidList = fid.readlines()
vidNum  = len(vidList)
Disp = '|' + str(vidNum) + '|' + str(edLine) + '----' + str(stLine -1) + ':'
for cnt in cntRange:
	print Disp + str(cnt)
	vid = vidList[cnt].strip()
	outFeatPath = os.path.join(outFolder, vid + fmt)
	if os.path.exists(outFeatPath):
		continue
	else:
		vidFeatFile = os.path.join(featureFolder, vid + tarFmt)
		cmd1 = '7z x ' + vidFeatFile + ' -o./temp/'
		os.system(cmd1)
		vidTempFile =  os.path.join('./temp', vid + fmt)
		vidMatTemp  = sio.loadmat(vidTempFile)
		cmd2 = 'rm ./temp/' + vid + fmt
		os.system(cmd2) 
		######################################
		vidMat      = vidMatTemp['F5C']
		######################################
		[Dim, H, nW] = vidMat.shape
		n = nW / H
		for sigKF in range(1, n+1):
			id1 = sigKF * H
			id2 = sigKF * H - H
			sigFeat = vidMat[:,:,id2:id1]
			sp1   = maxPool3DMat(sigFeat, (7,7),1)
			sp2   = maxPool3DMat(sigFeat, (6,6),1)
			sp3   = maxPool3DMat(sigFeat, (5,5),1)
			sp4   = maxPool3DMat(sigFeat, (2,2),1)
			spFeat = np.concatenate((sp1, sp2, sp3, sp4),axis=0)
			if sigKF == 1:
				vidFeat = np.array(spFeat)
			else:
				vidFeat = np.concatenate((vidFeat, spFeat), axis=0)
		sio.savemat(outFeatPath, {'vidFeat':vidFeat})



